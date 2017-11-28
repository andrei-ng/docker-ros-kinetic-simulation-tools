## Docker ROS Kinetic & V-REP

Use the [Dockerfile](./Dockerfile) and the [build](./build.sh) & [run](./build.sh) scripts to create and run a Docker container consisting of [ROS Kinetic](http://wiki.ros.org/kinetic) (full version) for Ubuntu Xenial with NVIDIA hardware acceleration, OpenGL support and shared X11 socket such that the [V-REP](http://www.coppeliarobotics.com/index.html) simulator can be ran from within the Docker container.

This image combines the build steps of the following two images
* [docker_ros_kinetic_cuda9](https://github.com/gandrein/docker_ros_kinetic_cuda9)
* [docker_customizing_users](https://github.com/gandrein/docker_customizing_users)

Please refer to those repositories for more details about the respective images and the build process.

### Purpose

This image was created in order to test the V-REP simulator with ROS Kinetic, straight from a Docker container.

### Requirements

This docker container has been build and tested on a machine running Ubuntu 16.04 with the following packages installed
* `docker` version `17.09.0-ce`
* [`nvidia-docker`](https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-1.0)) version `1.0`
* [V-REP PRO EDU V3.4.0 rev1](http://www.coppeliarobotics.com/downloads.html)

#### Dependencies
This Docker image uses as base the custom [docker_ros_kinetic_cuda9](https://github.com/gandrein/docker_ros_kinetic_cuda9) image available from [this repository](https://github.com/gandrein/docker_ros_kinetic_cuda9).

### Building the image

1. Make sure you have built the [docker_ros_kinetic_cuda9](https://github.com/gandrein/docker_ros_kinetic_cuda9) image on your local machine, as mentioned in the Dependencies section above. 
2. In a terminal run [./build.sh](./build.sh) to build a docker image with the name provided as the first argument and with a specified non-root user (`default = docker`) for the docker container.
	* If you have given a different name to the base image from step 1, make sure to change this line in the [Dockerfile](./Dockerfile)
		```
		FROM ros_kinetic_full_cuda9 
		```
		with the corresponding name.


### Running a container

In a terminal enter [./run.sh](./run.sh) with the image name from the previous step. This will run and remove the docker image upon exit (i.e., it is ran with the `--rm` flag).
```
./run.sh GIVEN_IMAGE_NAME
```

#### V-REP usage

Note that V-REP simulator is not installed nor copied in the Docker container. Rather, the host V-REP installation folder is volume mounted in the Docker container at runtime by adding the following line to the `nvidia-docker run` command (see the [run.sh](./run.sh) contents),
```
  -v $HOME/Projects/devs/simulation/v-rep:/extern/v-rep \
```
where you should replace the source path `$HOME/Projects/devs/simulation/v-rep` with your V-REP installation location. 

### Testing functionality

#### Test V-REP

When the Docker container is launched, a [terminator](https://gnometerminator.blogspot.nl/p/introduction.html) window opens. Navigate to either `/extern/v-rep` or to `$HOME/data/v-rep` and type 
```
./vrep.sh
``` 
The V-REP simulator GUI should be launched. 


#### Test ROS

While inside the container call `roscore`. The `ros master` should be launched. 
