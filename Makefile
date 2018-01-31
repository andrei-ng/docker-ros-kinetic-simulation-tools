.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[0-9a-zA-Z_-]+:.*?## / {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# DOCKER TASKS
ros-kinetic-base-nvidia: ## Build ROS-Kinetic Xenial Docker Image | (with NVIDIA & OpenGL support)
	docker build -t codookie/xenial:ros-kinetic-base-nvidia ros-kinetic-base-nvidia-opengl 
	@printf "\n\033[92mDocker Image: codookie/xenial:ros-kinetic-base-nvidia\033[0m\n"
ros-kinetic-base-nvidia-cuda: ## Build ROS-Kinetic Xenial Docker Image  (with NVIDIA CUDA and cuDNN support)
	docker build -t codookie/xenial:ros-kinetic-base-nvidia-cuda ros-kinetic-base-nvidia-cudnn 
	@printf "\n\033[92mDocker Image: codookie/xenial:ros-kinetic-base-nvidia-cuda\033[0m\n"
ros-kinetic-vrep: ros-kinetic-base-nvidia ## Build ROS-Kinetic Xenial Docker Image custom ROS development enviroment (with V-REP)
	cd ros-kinetic-vrep; ./build.sh codookie/xenial:ros-kinetic-vrep
	@printf "\n\033[92mDocker Image: codookie/xenial:ros-kinetic-vrep\033[0m\n"
ros-kinetic-gazebo7: ros-kinetic-base-nvidia ## Build ROS-Kinetic Xenial Docker Image custom ROS development enviroment (with Gazebo7)
	cd ros-kinetic-gazebo7; ./build.sh codookie/xenial:ros-kinetic-gazebo7
	@printf "\n\033[92mDocker Image: codookie/xenial:ros-kinetic-gazebo7\033[0m\n"
ros-kinetic-gazebo8: ros-kinetic-base-nvidia ## Build ROS-Kinetic Xenial Docker Image custom ROS development enviroment (with Gazebo8)
	cd ros-kinetic-gazebo8; ./build.sh codookie/xenial:ros-kinetic-gazebo8
	@printf "\n\033[92mDocker Image: codookie/xenial:ros-kinetic-gazebo8\033[0m\n"
ros-kinetic-gazebo9: ros-kinetic-base-nvidia ## Build ROS-Kinetic Xenial Docker Image custom ROS development enviroment (with Gazebo9)
	cd ros-kinetic-gazebo9; ./build.sh codookie/xenial:ros-kinetic-gazebo9
	@printf "\n\033[92mDocker Image: codookie/xenial:ros-kinetic-gazebo9\0033[0m\n"
