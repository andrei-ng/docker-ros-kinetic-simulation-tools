# This Dockerfile creates a custom image based on the locally created
# `ros_kinetic_full_cuda9` image
# For more details on generating the above custom image, see the Dockerfile in 
# the repository available here 
# https://github.com/gandrein/docker_ros_kinetic_cuda9

FROM ros_kinetic_full_cuda9 

MAINTAINER Andrei Gherghescu <gandrein@gmail.com>

LABEL Description="Customized ROS-Kinetic-Full-Desktop with CUDA 9 support for Ubuntu 16.04" Version="1.0"

# Arguments
ARG user=docker
ARG uid=1000
ARG shell=/bin/bash
ARG workspace="/home/${user}/catkin_ws"

# ------------------------------------------ Install required (&useful) packages --------------------------------------
RUN apt-get update && apt-get install -y \
lsb-release \
mesa-utils \
git \
subversion \
nano \
terminator \
gnome-terminal \
wget \
curl \
htop \
python3-pip python-pip  \
software-properties-common python-software-properties \
gdb valgrind \
zsh screen tree \
sudo ssh synaptic vim \
python-rosdep python-rosinstall \
x11-apps build-essential \
libcanberra-gtk*

# Install python pip(s)
RUN sudo -H pip2 install -U pip numpy && sudo -H pip3 install -U pip numpy

# Configure timezone and locale
RUN sudo apt-get clean && sudo apt-get update -y && sudo apt-get install -y locales
RUN sudo locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# Crete and add user
RUN useradd -ms ${shell} ${user}
ENV USER=${user}

RUN export uid=${uid} gid=${uid}

RUN \
  echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}" && \
  chmod 0440 "/etc/sudoers.d/${user}"
  RUN chown ${uid}:${uid} -R "/home/${user}"

# Switch to user
USER ${user}

# Install and configure OhMyZSH
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
# RUN chsh -s /usr/bin/zsh ${user}
RUN git clone https://github.com/sindresorhus/pure $HOME/.oh-my-zsh/custom/pure
RUN ln -s $HOME/.oh-my-zsh/custom/pure/pure.zsh-theme $HOME/.oh-my-zsh/custom/
RUN ln -s $HOME/.oh-my-zsh/custom/pure/async.zsh $HOME/.oh-my-zsh/custom/
RUN sed -i -e 's/robbyrussell/refined/g' $HOME/.zshrc

# ================== Install packages required to build V-REP - ROS interface ==================
# Install packages as described in file  'ros_vrep_rosinterface_install_guide.txt'
# available in the v-rep_xxx_xxx/programming/ros_packages (V-REP installation folder)
RUN sudo apt-get install -y python-tempita \
	python-lxml default-jre \
	xsltproc
# without the last one (xsltproc), building vrep_ros_interface from sources gives Python errors

# Install & configure 'saxon' (not mandatory) but catkin build will issue warning otherwise
# Check the details in the V-REP installation guide file at 
# v-rep_xxx_xxx/programming/ros_packages/ros_vrep_rosinterface_install_guide.txt
RUN sudo mkdir -p $HOME/packages/downloads
RUN sudo mkdir -p $HOME/packages/saxon/bin
RUN ls $HOME/packages
RUN sudo wget -P $HOME/packages/downloads http://downloads.sourceforge.net/project/saxon/Saxon-HE/9.7/SaxonHE9-7-0-8J.zip
RUN sudo unzip $HOME/packages/downloads/SaxonHE9-7-0-8J.zip -d $HOME/packages/saxon
# Make user the owner of the copied files 
RUN sudo chown -R ${user}:${user} /home/${user}/packages
# Make a binary script that is called by V-REP
RUN cd $HOME/packages/saxon && sudo echo -e '#!/bin/sh\njava -jar "`dirname "$0"`/../saxon9he.jar" "$@"' > bin/saxon
RUN sudo chmod a+x $HOME/packages/saxon/bin/saxon

# Remove the saxon downloads folder 
RUN sudo rm -r $HOME/packages/downloads

# Update PATH env var with the location of saxon executable:
RUN echo 'export PATH="$PATH:$HOME/packages/saxon/bin"' >> ~/.bashrc
RUN echo 'export PATH="$PATH:$HOME/packages/saxon/bin"' >> ~/.zshrc

# =============================== Configs ==========================================
# Source ROS setup into .rc files
RUN echo "source /opt/ros/kinetic/setup.sh" >> $HOME/.bashrc
RUN echo "source /opt/ros/kinetic/setup.zsh" >> $HOME/.zshrc

# Configure ROS
RUN sudo rm -rf /etc/ros/rosdep/sources.list.d/*
RUN sudo rosdep init && sudo rosdep fix-permissions && rosdep update 

# Copy custom files 
# NOTE: $HOME does not seem to work with the COPY directive
# Copy Terminator configuration
RUN mkdir -p $HOME/.config/terminator/
COPY config_files/terminator_config /home/${user}/.config/terminator/config

COPY config_files/bash_aliases /home/${user}/.bash_aliases
# Add the bash aliases to zsh rc as well
RUN cat $HOME/.bash_aliases >> $HOME/.zshrc

COPY entrypoint.sh /home/${user}/entrypoint.sh
RUN sudo chmod +x /home/${user}/entrypoint.sh

# Make user the owner of the copied files 
RUN sudo chown -R ${user}:${user} /home/${user}

# Change the bash prompt in the docker container
#RUN echo 'export PS1="[\u@vrep-docker]~\w# "' >> /etc/.profile
#ENV PS1 '[\u@vrep-docker]\w#'
#RUN echo 'PS1="\[$(tput setaf 3)$(tput bold)[\]\u@ros-docker$:\\w]#\[$(tput sgr0) \]"' >> root/.bashrc

# ================== Final environment configs ==================
# Create a mount point to bind host data to
VOLUME /extern

# Make SSH available
EXPOSE 22

# This is required for sharing Xauthority
ENV QT_X11_NO_MITSHM=1

# Create CATKIN workspace folder and ENV variable
RUN mkdir -p home/${user}/catkin_ws
ENV CATKIN_TOPLEVEL_WS=home/${user}/catkin_ws

# Switch to user's HOME folder
WORKDIR /home/${user}

# In the newly loaded container sometimes you can't do `apt install <package>
# unless you do a `apt update` first.  So run `apt update` as last step
# NOTE: bash auto-completion may have to be enabled manually from /etc/bash.bashrc
RUN sudo apt-get update -y

# Using the "exec" form for the Entrypoint command
ENTRYPOINT ["./entrypoint.sh", "terminator"]
CMD ["-e", "echo $INFO_MSG && /usr/bin/zsh"]
