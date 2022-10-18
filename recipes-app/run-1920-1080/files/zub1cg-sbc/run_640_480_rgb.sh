#!/bin/bash

INPUT_RESOLUTION=2560x800
OUTPUT_W=640
OUTPUT_H=480
OUTPUT_RESOLUTION=${OUTPUT_W}x${OUTPUT_H}

media-ctl -d /dev/media0 -V "'ap1302.0-003c':2 [fmt:UYVY8_1X16/$INPUT_RESOLUTION field:none]"

media-ctl -d /dev/media0 -V "'b0000000.mipi_csi2_rx_subsystem':0 [fmt:UYVY8_1X16/$INPUT_RESOLUTION field:none]"
media-ctl -d /dev/media0 -V "'b0000000.mipi_csi2_rx_subsystem':1 [fmt:UYVY8_1X16/$INPUT_RESOLUTION field:none]"

media-ctl -d /dev/media0 -V "'b0010000.v_proc_ss':0 [fmt:UYVY8_1X16/$INPUT_RESOLUTION field:none]"
media-ctl -d /dev/media0 -V "'b0010000.v_proc_ss':1 [fmt:RBG24/$INPUT_RESOLUTION field:none]"

media-ctl -d /dev/media0 -V "'b0040000.v_proc_ss':0 [fmt:RBG24/$INPUT_RESOLUTION field:none]"
media-ctl -d /dev/media0 -V "'b0040000.v_proc_ss':1 [fmt:RBG24/$OUTPUT_RESOLUTION field:none]"

sleep 1

# Turn off AWB for case of AR0144 sensors (monochrome)
media_ctl=$(media-ctl -p -d /dev/media0)
if [[ "$media_ctl" == *"ar0144"* ]]; then
	echo "Detected AR0144 - disabling AWB"
	v4l2-ctl --set-ctrl white_balance_auto_preset=0 -d /dev/video0
	echo "Detected AR0144 - setting brightness"
	v4l2-ctl --set-ctrl brightness=256 -d ${mipi_video_dev}
fi
if [[ "$media_ctl" == *"ar1335"* ]]; then
	echo "Detected AR1335 - enabling AWB"
	v4l2-ctl --set-ctrl white_balance_auto_preset=1 -d /dev/video0
fi

gst-launch-1.0 v4l2src device=/dev/video0 io-mode="dmabuf" \
	! "video/x-raw, width=$OUTPUT_W, height=$OUTPUT_H, format=BGR, framerate=60/1" \
	! videoconvert \
	! fpsdisplaysink video-sink="autovideosink" text-overlay=false sync=false \
	-v
