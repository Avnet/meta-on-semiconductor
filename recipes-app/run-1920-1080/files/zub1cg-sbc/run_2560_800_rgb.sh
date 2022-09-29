#!/bin/bash

INPUT_RESOLUTION=2560x800
OUTPUT_W=2560
OUTPUT_H=800
OUTPUT_RESOLUTION=${OUTPUT_W}x${OUTPUT_H}

# Specify MIPI capture pipeline devices
mipi_video_dev="/dev/video0"
mipi_media_dev="/dev/media0"
mipi_ap1302_i2c="ap1302.1-003c"

# Configure MIPI capture pipeline for RGB
media-ctl -d ${mipi_media_dev} -V "'ap1302.1-003c':2 [fmt:UYVY8_1X16/$INPUT_RESOLUTION field:none]"
media-ctl -d ${mipi_media_dev} -V "'b0000000.mipi_csi2_rx_subsystem':0 [fmt:UYVY8_1X16/$INPUT_RESOLUTION field:none]"
media-ctl -d ${mipi_media_dev} -V "'b0000000.mipi_csi2_rx_subsystem':1 [fmt:UYVY8_1X16/$INPUT_RESOLUTION field:none]"
media-ctl -d ${mipi_media_dev} -V "'b0010000.v_proc_ss':0 [fmt:UYVY8_1X16/$INPUT_RESOLUTION field:none]"
media-ctl -d ${mipi_media_dev} -V "'b0010000.v_proc_ss':1 [fmt:RBG24/$INPUT_RESOLUTION field:none]"
media-ctl -d ${mipi_media_dev} -V "'b0040000.v_proc_ss':0 [fmt:RBG24/$INPUT_RESOLUTION field:none]"
media-ctl -d ${mipi_media_dev} -V "'b0040000.v_proc_ss':1 [fmt:RBG24/$OUTPUT_RESOLUTION field:none]"

# Turn off AWB for case of AR0144 sensors (monochrome)
media_ctl=$(media-ctl -p -d /dev/media0)
if [[ "$media_ctl" == *"ar0144"* ]]; then
	echo "Detected AR0144 - disabling AWB"
  v4l2-ctl --set-ctrl white_balance_auto_preset=0 -d ${mipi_video_dev}
  echo "Detected AR0144 - setting brightness"
  v4l2-ctl --set-ctrl brightness=256 -d ${mipi_video_dev}
fi
if [[ "$media_ctl" == *"ar1335"* ]]; then
	echo "Detected AR1335 - enabling AWB"
	v4l2-ctl --set-ctrl white_balance_auto_preset=1 -d ${mipi_video_dev}
fi

# Launch gstreamer pipeline
gst-launch-1.0 v4l2src device=${mipi_video_dev} io-mode="dmabuf" \
	! "video/x-raw, width=$OUTPUT_W, height=$OUTPUT_H, format=BGR, framerate=60/1" \
	! videoconvert \
	! fpsdisplaysink video-sink="autovideosink" text-overlay=false sync=false \
	-v

