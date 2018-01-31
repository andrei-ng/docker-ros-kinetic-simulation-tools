FROM nvidia/cuda:9.0-devel-ubuntu16.04

MAINTAINER Andrei Gherghescu <gandrein@gmail.com>

LABEL Description="ROS-Kinetic-Full-Desktop with CUDA 9 support for Ubuntu 16.04" Version="1.0"

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

CMD ["/bin/bash"]


