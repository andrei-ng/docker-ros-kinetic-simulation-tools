## NVIDIA Docker: Simulation Environments with ROS Kinetic

This repository contains Dockerfile(s) for building Docker Images with [ROS Kinetic](http://wiki.ros.org/kinetic) (full version) with different Simulation Tools for Ubuntu Xenial targeted at NVIDIA platforms (with NVIDIA hardware acceleration, OpenGL support and shared X11 socket). 

The images are used for testing ROS Kinetic with:
* [V-REP](http://www.coppeliarobotics.com/index.html) (DONE)
* [Gazebo 7](http://gazebosim.org/blog/gazebo7) (TODO - already in base)
* [Gazebo 8](http://gazebosim.org/blog/gazebo8) (TODO)
* [Gazebo 9](http://gazebosim.org/blog/gazebo9) (TODO)
---

### Contents
1. [Requirements](#1-requirements)
2. [Building images](#2-building-the-image)
3. [Running a container](#3-running-the-container)
4. [Simulation tools containers](#4-simulation-tools-containers)

### 1. Requirements

The docker containers have been build and tested on a machine running Ubuntu 16.04 with the following packages installed
* `docker >= 17.09.0-ce`
* `GNU Make >= 4.1`
* [`nvidia-docker`](https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-1.0)) version `1.0`
* [V-REP PRO EDU V3.4.0 rev1](http://www.coppeliarobotics.com/downloads.html)

### 2. Building Docker images

The [Makefile](./Makefile) contained in the repository allows you to create docker images for the simulation tool of your choice using as a base image either
* an image with ROS-Kinetic and NVIDIA Docker support 
* an image with ROS-Kinetic and NVIDIA CUDA support. 

In a terminal type `make` followed by a `<TAB>` to see the available auto-complete options. 
```
make <TAB>
```

If you wish to change the names given to the Docker images the recommended way is to give a new TAG to the image by using the 
```
docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
```
command, after you have build it with the `make` instruction. 

You could also change the names in the `Makefile`. However, make sure you do not break the dependencies between coupled images. 

#### Base images
All Docker images with embedded simulation tools use the `ros-kinetic-base-nvidia` as base image which has support for Nvidia-docker and OpenGL, please refer to this [README](./ros-kinetic-base-nvidia-opengl/README.md) for more details.

If you need the images for Machine Learning and Computer Vision development, you can switch all the simulation tools Docker images to depend on `ros-kinetic-base-nvidia-cuda`. For more details about this image, please refer to this [README](./ros-kinetic-base-nvidia-cudnn/README.md).

E.g, for the V-REP Docker image you can switch to the above base image by replacing the `Makefile`'s dependency on the first line below to `ros-kinetic-base-nvidia-cuda`
```
ros-kinetic-vrep: ros-kinetic-base-nvidia ## Build ROS-Kinetic Xenial Docker Image for VREP simulator (with custom ROS development enviroment)
	cd ros-kinetic-vrep; ./build.sh codookie/xenial:ros-kinetic-vrep
	@printf "\n\033[92mDocker Image: codookie/xenial:ros-kinetic-vrep\033[0m\n"
```

### 3. Running the container

Navigate to any of the subfolders and enter in a terminal [./run_docker.sh](./ros-kinetic-vrep/run_docker.sh) with the image name from the previous build step, e.g.,
```
./run_docker.sh codookie/xenial:ros-kinetic-vrep
```


### 4. Simulation tools containers

For more information about the build process and on how to use each individual simulation tool's Docker container, please read the associated READMEs
* [V-REP](./ros-kinetic-vrep/README.md)
* [Gazebo 7](./ros-kinetic-gazebo7/README.md)
* [Gazebo 8](./ros-kinetic-gazebo8/README.md)
* [Gazebo 9](./ros-kinetic-gazebo9/README.md)