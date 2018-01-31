#!/usr/bin/env bash

# Check args
if [ "$#" -ne 1 ]; then
  echo "usage: ./build.sh IMAGE_NAME"
  exit 1
fi

IMAGE_NAME=$1

# Set custom arguments
dUSER=docker
dSHELL=/usr/bin/zsh

# Copy custom config files
cp -r ../configs configs

# Build the docker image
docker build \
  --build-arg user=$dUSER\
  --build-arg uid=$UID\
  --build-arg shell=$dSHELL\
  -t $IMAGE_NAME .

# Clean up
# Remove configs folder
rm -rf configs
