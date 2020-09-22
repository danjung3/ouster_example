#!/bin/bash

xhost +local:root
IMG=kbearrk/ouster_example_cartographer:latest

# If NVIDIA is present, use Nvidia-docker
if test -c /dev/nvidia0
then
    docker run --rm -it \
      --runtime=nvidia \
      --privileged \
      --device /dev/dri:/dev/dri \
      --env="DISPLAY" \
      --env="QT_X11_NO_MITSHM=1" \
      -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
      $IMG \
      bash
else
    docker run --rm -it \
      -e DISPLAY \
      --device=/dev/dri:/dev/dri \
      -v "/tmp/.X11-unix:/tmp/.X11-unix" \
      $IMG \
      bash
fi

## Docker nvidia troubleshooting 

# Stop docker before running 'sudo dockerd --add-runtime=nvidia=/usr/bin/nvidia-container-runtime'
# sudo systemctl stop docker

# Change mode of docker.sock if you have a permission issue
# sudo chmod 666 /var/run/docker.sock

# Add the nvidia runtime to allow docker to use nvidia GPU
# sudo dockerd --add-runtime=nvidia=/usr/bin/nvidia-container-runtime

## Google Cartographer commands

# Get sample data
# cd /root/bags
# curl -O https://data.ouster.io/downloads/os1_townhomes_cartographer.bag 

# Source the workspace
# source /root/catkin_ws/devel/setup.bash

# Navigate to the cartographer_ros launch file directory
# cd /root/catkin_ws/src/ouster_example/cartogrpaher_ros/launch

## Validate rosbag
#rosrun cartographer_ros cartographer_rosbag_validate -bag_filename /root/bags/os1_townhomes_cartographer.bag

## Run 2D online
# roslaunch demo_cart_2d.launch bag_filename:=/root/bags/os1_townhomes_cartographer.bag

## Run 2D offline (to generate .pbstream file)
# roslaunch offline_cart_2d.launch bag_filenames:=/root/bags/os1_townhomes_cartographer.bag

## Run 2D assets_writer
# roslaunch assets_writer_cart_2d.launch bag_filenames:=/root/bags/os1_townhomes_cartographer.bag  pose_graph_filename:=/root/bags/os1_townhomes_cartographer.bag.pbstream 

## View output pngs
# xdg-open os1_townhomes_cartographer.bag_xray_xy_all.png
# xdg-open os1_townhomes_cartographer.bag_probability_grid.png

## Run 3D online
# roslaunch demo_cart_3d.launch bag_filename:=/root/bags/os1_townhomes_cartographer.bag

## Run 3D offline
# roslaunch offline_cart_3d.launch bag_filenames:=/root/bags/os1_townhomes_cartographer.bag 

## Run 3D assets_writer
# roslaunch assets_writer_cart_3d.launch bag_filenames:=/root/bags/os1_townhomes_cartographer.bag  pose_graph_filename:=/root/bags/os1_townhomes_cartographer.bag.pbstream 

## Open image assets from assets_writer
# xdg-open os1_townhomes_cartographer.bag_xray_xy_all.png
# xdg-open os1_townhomes_cartographer.bag_probability_grid.png

