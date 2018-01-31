FROM codookie/xenial:ros-kinetic-base-nvidia

MAINTAINER Andrei Gherghescu <gandrein@gmail.com>

LABEL Description="Customized ROS-Kinetic-Full-Desktop for VREP Simualtor with NVIDIA support for Ubuntu 16.04" Version="1.0"

# Arguments
ARG user=docker
ARG uid=1000
ARG shell=/bin/bash
ARG workspace="/home/${user}/catkin_ws"

# ------------------------------------------ Install required (&useful) packages --------------------------------------
# Also install packages as described in file  'ros_vrep_rosinterface_install_guide.txt'
# available in the v-rep_xxx_xxx/programming/ros_packages (V-REP installation folder)
# without the xsltproc package, building vrep_ros_interface from sources gives Python errors

RUN apt-get update -y && apt-get install --no-install-recommends -y \
 lsb-release apt-utils mesa-utils build-essential \
 software-properties-common locales x11-apps \
 git subversion \
 nano vim \
 zsh screen tree \
 sudo ssh synaptic \
 gnome-terminal terminator \
 wget curl unzip htop \
 gdb valgrind \
 libcanberra-gtk* \
 python-keybinder python-notify \
 python-tempita python-lxml default-jre xsltproc \
&& sudo -H pip2 install -U pip numpy && sudo -H pip3 install -U pip numpy \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get clean

# Configure timezone and locale
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

# Switch to user
USER ${user}

# Install and configure OhMyZSH
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true \
 && git clone https://github.com/sindresorhus/pure $HOME/.oh-my-zsh/custom/pure \
 && ln -s $HOME/.oh-my-zsh/custom/pure/pure.zsh-theme $HOME/.oh-my-zsh/custom/ \
 && ln -s $HOME/.oh-my-zsh/custom/pure/async.zsh $HOME/.oh-my-zsh/custom/ \
 && sed -i -e 's/robbyrussell/refined/g' $HOME/.zshrc

# ================== Configure packages required to build V-REP - ROS interface ==================
# Install & configure 'saxon' (not mandatory) but catkin build will issue warning otherwise
# Check the details in the V-REP installation guide file at 
# v-rep_xxx_xxx/programming/ros_packages/ros_vrep_rosinterface_install_guide.txt
RUN sudo mkdir -p $HOME/packages/downloads \
	&& sudo mkdir -p $HOME/packages/saxon/bin \
	&& sudo wget -P $HOME/packages/downloads http://downloads.sourceforge.net/project/saxon/Saxon-HE/9.7/SaxonHE9-7-0-8J.zip \
	&& sudo unzip $HOME/packages/downloads/SaxonHE9-7-0-8J.zip -d $HOME/packages/saxon \
	&& sudo chown -R ${user}:${user} /home/${user}/packages
# Make a binary script that is called by V-REP
RUN cd $HOME/packages/saxon && sudo echo -e '#!/bin/sh\njava -jar "`dirname "$0"`/../saxon9he.jar" "$@"' > bin/saxon
RUN sudo chmod a+x $HOME/packages/saxon/bin/saxon \
  && sudo rm -r $HOME/packages/downloads

# =============================== Configs ==========================================
# Update PATH env var with the location of saxon executable:
# and source ROS setup into .rc files
RUN echo 'export PATH="$PATH:$HOME/packages/saxon/bin"' >> ~/.bashrc \
 && echo 'export PATH="$PATH:$HOME/packages/saxon/bin"' >> ~/.zshrc \
 && echo "source /opt/ros/kinetic/setup.sh" >> $HOME/.bashrc \
 && echo "source /opt/ros/kinetic/setup.zsh" >> $HOME/.zshrc

# Configure ROS
RUN sudo rm -rf /etc/ros/rosdep/sources.list.d/* \
	&& sudo rosdep init && sudo rosdep fix-permissions && rosdep update 

# Copy custom files 
# NOTE: $HOME does not seem to work with the COPY directive
COPY entrypoint.sh /home/${user}/entrypoint.sh
# Copy Terminator configuration
RUN mkdir -p $HOME/.config/terminator/
COPY configs/terminator_config /home/${user}/.config/terminator/config
COPY configs/bash_aliases /home/${user}/.bash_aliases
# Add the bash aliases to zsh rc as well
RUN cat $HOME/.bash_aliases >> $HOME/.zshrc

RUN sudo chmod +x /home/${user}/entrypoint.sh \
 && sudo chown ${user}:${user} /home/${user}/entrypoint.sh \
  	/home/${user}/.config/terminator/config \
  	/home/${user}/.bash_aliases

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

# Using the "exec" form for the Entrypoint command
ENTRYPOINT ["./entrypoint.sh", "terminator"]
CMD ["-e", "echo $INFO_MSG && /usr/bin/zsh"]
