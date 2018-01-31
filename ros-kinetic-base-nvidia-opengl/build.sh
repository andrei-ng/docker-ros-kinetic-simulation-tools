#!/usr/bin/env bash

# Check args
if [ "$#" -ne 1 ]; then
  echo "usage: ./build.sh IMAGE_NAME"
  exit 1
fi

# Build the docker image
docker build -t $IMAGE_NAME .
