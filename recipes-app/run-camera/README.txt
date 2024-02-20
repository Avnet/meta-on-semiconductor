Notes:
When testing for dualcam on the u96 platform with dp connected, and test the run_camera with mode=dp and without dp connected, reboot, and run_camera from ssh -X terminal. Verify the video sink as well, as when running from
    gst-launch-1.0 v4l2src device=/dev/video0 io-mode=dmabuf '!' 'video/x-raw, width=640, height=480, format=YUY2, framerate=60/1' '!' videoconvert '!' fpsdisplaysink 'video-sink='\''glimagesink'\''' text-overlay=false sync=false -v
Can cause strange artifacting as the video sink can affect performance.
    gst-launch-1.0 v4l2src device=/dev/video0 io-mode=dmabuf '!' 'video/x-raw, width=640, height=480, format=YUY2, framerate=60/1' '!' videoconvert '!' fpsdisplaysink 'video-sink='\''ximagesink'\''' text-overlay=false sync=false -v
On the other hand had posed no issue.
