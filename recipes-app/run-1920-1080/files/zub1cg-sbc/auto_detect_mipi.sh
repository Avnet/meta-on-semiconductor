#!/bin/bash

# Find mipi source
declare -a mipi_video_list
declare -a mipi_media_list
mipi_video_idx=0
mipi_media_idx=0
for dev_video in `ls /dev/video*`
do
  dev_v4l2_ctl=$(v4l2-ctl -D -d $dev_video)  
  if [[ "$dev_v4l2_ctl" == *"vcap_CAPTURE_PIPELINE_v_proc_ss"* ]]; then
    echo "$dev_video is a mipi video device"
    mipi_video_list[$mipi_video_idx]=$dev_video
    mipi_video_idx=$mipi_video_idx+1
  fi 
done
echo "mipi video devices = ${mipi_video_list[@]}"
mipi_video_dev=${mipi_video_list[0]}
for dev_media in `ls /dev/media*`
do
  dev_media_ctl=$(media-ctl -p -d $dev_media)  
  if [[ "$dev_media_ctl" == *"vcap_CAPTURE_PIPELINE_v_proc_ss"* ]]; then
    echo "$dev_media is a mipi media device"
    mipi_media_list[$mipi_media_idx]=$dev_media
    mipi_media_idx=$mipi_media_idx+1
  fi 
done
echo "mipi media devices = ${mipi_media_list[@]}"
mipi_media_dev=${mipi_media_list[0]}

echo "mipi : $mipi_video_dev, $mipi_media_dev"

