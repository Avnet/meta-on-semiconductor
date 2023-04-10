#!/bin/bash

# Script inputs
print_usage() {
    echo "USAGE: run_camera.sh [OPTIONS]"
    echo " -m|--mode           mode must be 'dual', 'primary' or 'secondary'"
    echo " -s|--sink           sink must be 'dp', 'window' or 'fake'"
    echo " -f|--format         output format must be 'yuv' or 'rgb'"
    echo " -w|--width          output width"
    echo " -h|--height         output height"
}

while [ "$1" != "" ]; do
    case "$1" in
        -m|--mode)
            case "$2" in
                "dual" | "primary" | "secondary")
                    mode=$2
                ;;
                *)
                    echo "ERROR: Unknown mode specified";
                    print_usage
                    exit 1
                ;;
            esac
            shift
            ;;
        -s|--sink)
            case "$2" in
                "dp" | "fake" | "window")
                    sink=$2
                ;;
                *)
                    echo "ERROR: Unknown sink specified";
                    print_usage
                    exit 1
                ;;
            esac
            shift
            ;;
        -f|--format)
            case "$2" in
                "yuv" | "rgb")
                    format=$2
                ;;
                *)
                    echo "ERROR: Unknown format specified";
                    print_usage
                    exit 1
                ;;
            esac
            shift
            ;;
        -w|--width)
            width=$2
            shift
            ;;
        -h|--height)
            height=$2
            shift
            ;;
        *) # unknown argument
            echo "unknown arg $1"
            print_usage
            exit 1
            ;;
    esac
    shift
done

if [ -z $mode ]
then
    echo "WARNING: mode not set: using default 'dual' mode";
    mode="dual"
fi

if [ -z $sink ]
then
    echo "WARNING: sink not set: using default 'window' mode";
    sink="window"
fi

if [ -z $format ]
then
    echo "WARNING: format not set: using default 'yuv' format";
    format="yuv"
fi

if [ -z $width ] || [ -z $height ]
then
    echo "WARNING: output resolution not set: using default '640x480' resolution";
    width=640
    height=480
fi

output_res=${width}x${height}

echo -e "\n\nRun Camera with: mode=$mode, sink=$sink, output resolution=$output_res, format=$format\n"

# Detect MIPI capture pipeline devices
MEDIA_DEV=/dev/$(ls /sys/devices/platform/amba_pl@0/amba_pl@0\:vcap_CAPTURE_PIPELINE_v_proc_ss_scaler_0/ | grep media)
VIDEO_DEV=/dev/$(ls /sys/devices/platform/amba_pl@0/amba_pl@0\:vcap_CAPTURE_PIPELINE_v_proc_ss_scaler_0/video4linux/ | grep video)

CSC_DEV=$(ls /sys/bus/platform/drivers/xilinx-vpss-csc/  | grep v_proc_ss)
SCALER_DEV=$(ls /sys/bus/platform/drivers/xilinx-vpss-scaler/  | grep v_proc_ss)
MIPI_DEV=$(ls /sys/bus/platform/drivers/xilinx-csi2rxss/  | grep mipi_csi2_rx_subsystem)


MODEL=$(tr -d '\0' < $(find /sys/firmware/devicetree -name "sensor,model"))

BUS_DEV=$(ls /sys/bus/i2c/drivers/ap1302 | grep 003c)

AP1302_I2C="${BUS_DEV}"
AP1302_DEV="ap1302.${AP1302_I2C}"
AP1302_SENSOR="${AP1302_I2C}.${MODEL}"

sensor_width_hex=$(xxd -ps -l 4 $(find /sys/firmware/devicetree -name "sensor,resolution"))
sensor_height_hex=$(xxd -ps -l 4 -s 4 $(find /sys/firmware/devicetree -name "sensor,resolution"))
sensor_width=`printf "%d\n" 0x$sensor_width_hex`
sensor_height=`printf "%d\n" 0x$sensor_height_hex`

if [ "$mode" = "dual" ]
then
    CAMERA_RESOLUTION=$((sensor_width*2))x${sensor_height}
else
    CAMERA_RESOLUTION=${sensor_width}x${sensor_height}
fi

if [ "$format" = "yuv" ]
then
    GST_FORMAT="YUY2"
    MEDIA_FORMAT="UYVY8_1X16"
else
    GST_FORMAT="BGR"
    MEDIA_FORMAT="RBG24"
fi

# Configure MIPI capture pipeline for RGB
set -x
media-ctl -d ${MEDIA_DEV} -V "'${AP1302_DEV}':2 [fmt:UYVY8_1X16/$CAMERA_RESOLUTION field:none]"
media-ctl -d ${MEDIA_DEV} -V "'${MIPI_DEV}':0 [fmt:UYVY8_1X16/$CAMERA_RESOLUTION field:none]"
media-ctl -d ${MEDIA_DEV} -V "'${MIPI_DEV}':1 [fmt:UYVY8_1X16/$CAMERA_RESOLUTION field:none]"
media-ctl -d ${MEDIA_DEV} -V "'${CSC_DEV}':0 [fmt:UYVY8_1X16/$CAMERA_RESOLUTION field:none]"
media-ctl -d ${MEDIA_DEV} -V "'${CSC_DEV}':1 [fmt:$MEDIA_FORMAT/$CAMERA_RESOLUTION field:none]"
media-ctl -d ${MEDIA_DEV} -V "'${SCALER_DEV}':0 [fmt:$MEDIA_FORMAT/$CAMERA_RESOLUTION field:none]"
media-ctl -d ${MEDIA_DEV} -V "'${SCALER_DEV}':1 [fmt:$MEDIA_FORMAT/$output_res field:none]"
set +x

# Setup Sensors links to AP1302
link1_enable=1
link2_enable=1

if [ "$mode" = "primary" ]
then
    link2_enable=0
fi

if [ "$mode" = "secondary" ]
then
    link1_enable=0
fi
set -x
media-ctl -d ${MEDIA_DEV} -l "'${AP1302_SENSOR}.0':0 -> '${AP1302_DEV}':0[$link1_enable]"
media-ctl -d ${MEDIA_DEV} -l "'${AP1302_SENSOR}.1':0 -> '${AP1302_DEV}':1[$link2_enable]"
set +x

# Turn off AWB for case of AR0144 sensors (monochrome)
if [[ "$MODEL" == "ar0144" ]]; then
	echo "Detected AR0144 - disabling AWB"
	v4l2-ctl --set-ctrl white_balance_auto_preset=0 -d ${VIDEO_DEV}
	echo "Detected AR0144 - setting brightness"
	v4l2-ctl --set-ctrl brightness=256 -d ${VIDEO_DEV}
fi
if [[ "$MODEL" == "ar1335" ]]; then
	echo "Detected AR1335 - enabling AWB"
	v4l2-ctl --set-ctrl white_balance_auto_preset=1 -d ${VIDEO_DEV}
fi

# Setup sink
case "$sink" in
    "dp")
        modetest -D fd4a0000.display -s 43@41:$output_res@RG16 -P 39@41:$output_res@YUYV -w 40:alpha:0 &
        sleep 1
        sink_cmd="kmssink plane-id=39 bus-id=fd4a0000.display render-rectangle=\"<0,0,$width,$height>\" fullscreen-overlay=true sync=false"
    ;;
    "window")
        sink_cmd="fpsdisplaysink video-sink='autovideosink' text-overlay=false sync=false"
    ;;
    "fake")
        sink_cmd="fpsdisplaysink video-sink='fakevideosink' text-overlay=false sync=false"
    ;;
    *)
        echo "ERROR: Unknown sink specified";
        print_usage
        exit 1
    ;;
esac

# Start Pipeline
set -x
gst-launch-1.0 v4l2src device=${VIDEO_DEV} io-mode="dmabuf" \
	! "video/x-raw, width=$width, height=$height, format=$GST_FORMAT, framerate=60/1" \
	! videoconvert \
	! $sink_cmd \
	-v

set +x
