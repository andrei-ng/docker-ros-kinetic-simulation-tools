FROM ubuntu:xenial

MAINTAINER Andrei Gherghescu <gandrein@gmail.com>

LABEL Description="ROS-Kinetic-Full-Desktop for Ubuntu 16.04 with Nvidia-Docker" Version="1.0"

# Add key for ROS-Kinetic Desktop Full Image
# https://github.com/osrf/docker_images/blob/5399f380af0a7735405a4b6a07c6c40b867563bd/ros/kinetic/ubuntu/xenial/desktop-full/Dockerfile
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

# ------------------------------------------ Install packages --------------------------------------
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
 software-properties-common python-software-properties \
 lsb-release mesa-utils build-essential \
 python-rosdep python-rosinstall \
 python3-pip python-pip \
 ros-kinetic-desktop-full \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get clean \
&& pip install catkin_tools

# Configure ROS
RUN rosdep init && rosdep fix-permissions && rosdep update
RUN echo "source /opt/ros/kinetic/setup.bash" >> /root/.bashrc

# nvidia-docker hooks
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

CMD ["/bin/bash"]


