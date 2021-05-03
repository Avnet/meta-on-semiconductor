#!/bin/bash
	
media-ctl -d /dev/media0 -V '"ap1302.4-003c":2 [fmt:UYVY8_1X16/2560x800 field:none]'

media-ctl -d /dev/media0 -V '"b0000000.mipi_csi2_rx_subsystem":0 [fmt:UYVY8_1X16/2560x800 field:none]'
media-ctl -d /dev/media0 -V '"b0000000.mipi_csi2_rx_subsystem":1 [fmt:UYVY8_1X16/2560x800 field:none]'

media-ctl -d /dev/media0 -V  '"b0040000.v_proc_ss":0 [fmt:UYVY8_1X16/2560x800 field:none]'
media-ctl -d /dev/media0 -V  '"b0040000.v_proc_ss":1 [fmt:UYVY8_1X16/1920x1080 field:none]'

modetest -M xlnx -s 43:1920x1080@RG16 -P 39@41:1920x1080@YUYV -w 40:alpha:0 &
pid=$!
echo $pid
sleep 5

gst-launch-1.0 v4l2src device=/dev/video0 io-mode="dmabuf" ! "video/x-raw, width=1920, height=1080, format=YUY2, framerate=60/1" \
	! videoconvert \
	! kmssink plane-id=39 bus-id=fd4a0000.zynqmp-display render-rectangle="<0,0,1920,1080> fullscreen-overlay=true sync=false" -v

kill -9 $pid
