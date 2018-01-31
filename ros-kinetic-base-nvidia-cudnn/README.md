## Docker ROS Kinetic with NVIDIA CUDA support

Use this [Dockerfile](./Dockerfile) to create a Docker image containing ROS Kinetic (full version) for Ubuntu Xenial with NVIDIA cuDNN support and shared X11. 

Based on
* [jbohren/rosdocked](https://github.com/jbohren/rosdocked)
* [turlucode/ros-docker-gui](https://github.com/turlucode/ros-docker-gui/)

### Requirements

This docker image has been build and tested on a machine running Ubuntu 16.04 with the following packages installed
* `docker` version `17.09.0-ce`
* [`nvidia-docker`](https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-1.0)) version `1.0`

and
* `docker` version `17.09.0-ce`
* [`nvidia-docker`](https://github.com/NVIDIA/nvidia-docker/wiki/About-version-2.0) version `2.0`

Use the first option if you need OpenGL support and the second if you don't. See next section.

#### NVIDIA Hardware acceleration

For details on how to install the `nvidia-docker2` see the official [nvidia-docker](https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-2.0)) repository.

**Note** that `nvidia-docker2` does not have OpenGL support as mentioned in [issue #534](https://github.com/NVIDIA/nvidia-docker/issues/534). See also the [Troubleshooting](#no-opengl-support-troubleshooting) section. 

If you need or want OpenGL support simply use `nvidia-docker1` instead.  Install following the [official instructions](https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-1.0)) or alternatively follow the installation steps at [turlucode/ros-docker-gui](https://github.com/turlucode/ros-docker-gui/). 

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

Alternatively, in a terminal, you can directly run
* Version 2.0:
	```
	docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi
	```
* Version 1.0:
	```
	nvidia-docker run --rm nvidia/cuda nvidia-smi
	```
as described [here](https://github.com/NVIDIA/nvidia-docker/wiki/Usage) and [here](https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-1.0)).

#### NVIDIA-docker OpenGL support

According to the comments on the _nvidia-docker_'s repository ([issue #534](https://github.com/NVIDIA/nvidia-docker/issues/534)), `nvidia-docker2` has not support for OpenGL, while `nvidia-docker1` has. Therefore, when trying to run `glxgears` you might encounter 
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

If this is the case for you too you most likely won't be able to run any GUIs. **If you figure out how to fix this, please leave a comment in this repository.**

If you do need OpenGL support, use `nvidia-docker1` as mentioned above.