#!/usr/bin/env bash

# Check args
if [ "$#" -lt 1 ]; then
  echo "usage: ./run.sh IMAGE_NAME"
  return 1
fi

set -e

IMAGE_NAME=$1 && shift 1

# Run the container with NVIDIA Graphics acceleration, shared network interface, shared X11
nvidia-docker run --rm\
  --net=host \
  --ipc=host \
  --privileged \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  -v $HOME/.Xauthority:/root/.Xauthority -e XAUTHORITY=/root/.Xauthority \
  -v $HOME/Projects/devs/simulation/v-rep:/extern/v-rep \
  -e ROS_HOSTNAME=andrei-lp7510ub \
  -it $IMAGE_NAME "$@"