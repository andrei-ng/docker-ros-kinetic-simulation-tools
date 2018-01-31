#!/usr/bin/env bash

# Check args
if [ "$#" -lt 1 ]; then
  echo "usage: ./run.sh IMAGE_NAME"
  return 1
fi

set -e

IMAGE_NAME=$1 && shift 1

THIS_HOST=`hostname`
NVIDIA_DOCKER_VERSION=$(dpkg -l | grep nvidia-docker | awk '{ print $3 }' | awk -F'[_.]' '{print $1}')

# Determine the appropriate version of the docker run command
if [ $NVIDIA_DOCKER_VERSION = "1" ]; then
    docker_run_cmd="nvidia-docker run --rm"
elif [ $NVIDIA_DOCKER_VERSION = "2" ]; then
    docker_run_cmd="docker run --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=0 --rm"
else
    echo "[Warning] nvidia-docker not installed, running docker without Nvidia hardware acceleration / OpenGL support"
    docker_run_cmd="docker run --rm"
fi

# Run the container with NVIDIA Graphics acceleration, shared network interface, shared hostname, shared X11
$(echo $docker_run_cmd) \
    --net=host \
    --ipc=host \
    --privileged \
    -e DISPLAY=$DISPLAY \
    -e XAUTHORITY=/root/.Xauthority \
    -e ROS_HOSTNAME=$THIS_HOST \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v $HOME/.Xauthority:/root/.Xauthority
    -it $IMAGE_NAME "$@"