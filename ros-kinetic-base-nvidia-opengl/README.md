## Docker ROS Kinetic with OpenGL and NVIDIA card support

Use this [Dockerfile](./Dockerfile) to create a Docker image containing ROS Kinetic (full version) for Ubuntu Xenial with a shared X11 and support for OpenGL and NVIDIA hardware acceleration. 

Based on
* [jbohren/rosdocked](https://github.com/jbohren/rosdocked)
* [turlucode/ros-docker-gui](https://github.com/turlucode/ros-docker-gui/)

### Requirements

This docker image has been build and tested on a machine running Ubuntu 16.04 with the following packages installed
* `docker` version `17.09.0-ce`
* [`nvidia-docker`](https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-1.0)) version `1.0`

#### NVIDIA Hardware acceleration

For details on how to install the `nvidia-docker1` see the official [nvidia-docker 1.0](https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-1.0)) repository.

### Building the image

Run [./build.sh](./build.sh). This will create the image with the name provided.
```
./build.sh GIVEN_IMAGE_NAME
```

### Running a container

Run [./run_docker.sh](./run_docker.sh) with the chosen name from the step above. This will run and remove the docker image upon exit (i.e., it is ran with the `--rm` flag).

The script checks for the version of `nvidia-docker` and calls `docker run` differently based on version.

```
./run.sh GIVEN_IMAGE_NAME
```

The image shares the X11 unix socket with the host and its network interface.

### Testing functionality

#### Test ROS

While inside the container call `roscore`. The `ros master` should be launched. 

#### Test NVIDIA-Docker

To test the NVIDIA HW acceleration inside the ROS-Kinetic container started with [./run_docker.sh](./run_docker.sh), call `nvidia-smi` from a container's terminal
```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 387.12                 Driver Version: 387.12                    |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  Quadro M2000M       Off  | 00000000:01:00.0  On |                  N/A |
| N/A   43C    P5    N/A /  N/A |    792MiB /  4042MiB |     34%      Default |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
+-----------------------------------------------------------------------------+
```

#### NVIDIA-Docker OpenGL support

Try to run `glxgears` in the Docker container. If the _glxgears_ pop-up window does not appear and you encounter 
```
libGL error: No matching fbConfigs or visuals found
libGL error: failed to load driver: swrast
X Error of failed request:  BadValue (integer parameter out of range for operation)
  Major opcode of failed request:  154 (GLX)
  Minor opcode of failed request:  3 (X_GLXCreateContext)
  Value in failed request:  0x0
  Serial number of failed request:  35
  Current serial number in output stream:  37
```
then either you have not installed `nvidia-docker` properly or there is something wrong with the packages of your container.
