.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[0-9a-zA-Z_-]+:.*?## / {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# DOCKER TASKS
ros-kinetic-base-nvidia: ## Build ROS-Kinetic Xenial Docker Image | (with NVIDIA & OpenGL support)
	docker build -t codookie/xenial:ros-kinetic-base-nvidia ros-kinetic-base-nvidia-opengl 
	@printf "\n\033[92mDocker Image: codookie/xenial:ros-kinetic-base-nvidia\033[0m\n"
ros-kinetic-base-nvidia-cuda: ## Build ROS-Kinetic Xenial Docker Image | (with NVIDIA CUDA and cuDNN support)
	docker build -t codookie/xenial:ros-kinetic-base-nvidia-cuda ros-kinetic-base-nvidia-cudnn 
	@printf "\n\033[92mDocker Image: codookie/xenial:ros-kinetic-base-nvidia-cuda\033[0m\n"
ros-kinetic-vrep: ros-kinetic-base-nvidia ## Build ROS-Kinetic Xenial Docker with V-REP
	cd ros-kinetic-vrep; ./build.sh codookie/xenial:ros-kinetic-vrep
	@printf "\n\033[92mDocker Image: codookie/xenial:ros-kinetic-vrep\033[0m\n"

# TODO add the gazebos :) from the separate repos