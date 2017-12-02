#!/usr/bin/env bash

# Check args
if [ "$#" -ne 1 ]; then
  echo "usage: ./build.sh IMAGE_NAME"
  exit 1
elif [ $1 = "ros_kinetic_full_cuda9" ]; then
  # Check if base image exists locally
  ans=$(docker image inspect ros_kinetic_full_cuda9 >/dev/null 2>&1 && echo yes || echo)
  if [ $ans = "yes" ]; then
  	echo "A base image with name '$1' exists locally ... "
  	echo "Consider choosing a different name than the 'typical' ($1) base image name ..."
  	exit 1
  fi
fi

# Set custom arguments
dUSER=docker
dSHELL=/usr/bin/zsh

# Build the docker image
docker build\
  --build-arg user=$dUSER\
  --build-arg uid=$UID\
  --build-arg shell=$dSHELL\
  --build-arg workspace="/home/$dUSER/data/ROS/catkin_ws"\
  -t $1 .