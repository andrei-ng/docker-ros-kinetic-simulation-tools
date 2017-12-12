#! /bin/bash

# Re-mount the docker volumes mounted at runtime in the 'extern' volume
# to a 'data' folder inside the container user's HOME folder
sudo mkdir -p /home/$USER/data
# Do a recursive mount
sudo mount --rbind /extern $HOME/data
echo "Mounted external user data ..."

# Change owner from root
sudo chown $USER:$USER -R $HOME/data/

# Reminder of user to source the custom catkin_ws/devel/setup.zhs or setup.bash when building ROS packages
default_shell=$(echo $SHELL)
echo "Default shell is '$default_shell'"

if [[ $default_shell =~ .*zsh.* ]]; then
	export INFO_MSG="[INFO] remember to source custom setup.zsh script from catkin_ws/devel" 
	echo "$INFO_MSG"
	# source catkin_ws/devel/setup.zsh
	# echo "source $HOME/catkin_ws/devel/setup.zsh" >> $HOME/.zshrc

elif [[ $default_shell =~ .*bash.* ]]; then
	export INFO_MSG="[INFO] remember to source custom setup.zsh script from catkin_ws/devel" 
 	echo "$INFO_MSG"
 	# source $HOME/catkin_ws/devel/setup.bash
	# echo "source $HOME/catkin_ws/devel/setup.bash" >> $HOME/.bashrc
fi

# Create V_REP enviroment variables
echo "export VREP_ROOT=$HOME/v-rep" >> $HOME/.bashrc
echo "export VREP_ROOT=$HOME/v-rep" >> $HOME/.zshrc

exec "$@"