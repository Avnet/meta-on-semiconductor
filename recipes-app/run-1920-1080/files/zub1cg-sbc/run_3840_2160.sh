#!/bin/bash

INPUT_RESOLUTION=2560x800
OUTPUT_W=3840
OUTPUT_H=2160
OUTPUT_RESOLUTION=${OUTPUT_W}x${OUTPUT_H}

media-ctl -d /dev/media0 -V "'ap1302.0-003c':2 [fmt:UYVY8_1X16/$INPUT_RESOLUTION field:none]"

media-ctl -d /dev/media0 -V "'b0000000.mipi_csi2_rx_subsystem':0 [fmt:UYVY8_1X16/$INPUT_RESOLUTION field:none]"
media-ctl -d /dev/media0 -V "'b0000000.mipi_csi2_rx_subsystem':1 [fmt:UYVY8_1X16/$INPUT_RESOLUTION field:none]"

media-ctl -d /dev/media0 -V "'b0010000.v_proc_ss':0 [fmt:UYVY8_1X16/$INPUT_RESOLUTION field:none]"
media-ctl -d /dev/media0 -V "'b0010000.v_proc_ss':1 [fmt:UYVY8_1X16/$INPUT_RESOLUTION field:none]"

media-ctl -d /dev/media0 -V "'b0040000.v_proc_ss':0 [fmt:UYVY8_1X16/$INPUT_RESOLUTION field:none]"
media-ctl -d /dev/media0 -V "'b0040000.v_proc_ss':1 [fmt:UYVY8_1X16/$OUTPUT_RESOLUTION field:none]"

modetest -D fd4a0000.display -s 43@41:$OUTPUT_RESOLUTION@RG16 -P 39@41:$OUTPUT_RESOLUTION@YUYV -w 40:alpha:0 &
sleep 1

# Check if running on AR0144 sensors
media_ctl=$(media-ctl -p -d /dev/media0)
if [[ "$media_ctl" == *"ar0144"* ]]; then
	echo "ERROR: /usr/bin/run_3840_2160 : 3840x2160 not supported with AR0144 sensor(s) !"
	exit 1
fi
if [[ "$media_ctl" == *"ar1335"* ]]; then
	echo "Detected AR1335 - enabling AWB"
	v4l2-ctl --set-ctrl white_balance_auto_preset=1 -d /dev/video0
fi

gst-launch-1.0 v4l2src device=/dev/video0 io-mode="dmabuf" \
	! "video/x-raw, width=$OUTPUT_W, height=$OUTPUT_H, format=YUY2, framerate=60/1" \
	! videoconvert \
	! kmssink plane-id=39 bus-id=fd4a0000.display render-rectangle="<0,0,$OUTPUT_W,$OUTPUT_H> fullscreen-overlay=true sync=false" \
	-v
