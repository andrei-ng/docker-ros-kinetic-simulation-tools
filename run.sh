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

# Run the container with NVIDIA Graphics acceleration, shared network interface, shared hostname, shared X11
if [ $NVIDIA_DOCKER_VERSION = "2" ]; then
  docker run --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=0 --rm \
    --net=host \
    --ipc=host \
    --privileged \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v $HOME/.Xauthority:/root/.Xauthority -e XAUTHORITY=/root/.Xauthority \
    -v $HOME/Projects/devs/simulation/v-rep:/extern/v-rep \
    -e ROS_HOSTNAME=$THIS_HOST \
    -it $IMAGE_NAME "$@"
elif [ $NVIDIA_DOCKER_VERSION = "1" ]; then
  nvidia-docker run --rm \
    --net=host \
    --ipc=host \
    --privileged \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v $HOME/.Xauthority:/root/.Xauthority -e XAUTHORITY=/root/.Xauthority \
	-v $HOME/Projects/devs/simulation/v-rep:/extern/v-rep \
    -e ROS_HOSTNAME=$THIS_HOST \
    -it $IMAGE_NAME "$@"
else
  echo "[Warning] nvidia-docker not installed, running docker without Nvidia hardware acceleration / OpenGL support"
  docker run --rm \
    --net=host \
    --ipc=host \
    --privileged \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v $HOME/.Xauthority:/root/.Xauthority -e XAUTHORITY=/root/.Xauthority \
    -v $HOME/Projects/devs/simulation/v-rep:/extern/v-rep \
    -e ROS_HOSTNAME=$THIS_HOST \
    -it $IMAGE_NAME "$@"
fi
