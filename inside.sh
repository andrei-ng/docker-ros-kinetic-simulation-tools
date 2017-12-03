#! /bin/bash

# Re-mount the docker volumes mounted at runtime in the 'extern' volume
# to a 'data' folder inside the container user's HOME folder
sudo mkdir -p /home/$USER/data
# Do a recursive mount
sudo mount --rbind /extern $HOME/data

# Change owner from root
sudo chown $USER:$USER -R $HOME/data/

# Create V_REP enviroment variables
echo "export VREP_ROOT=$HOME/data/v-rep/v-rep-edu" >> $HOME/.bashrc
echo "export VREP_ROOT=$HOME/data/v-rep/v-rep-edu" >> $HOME/.zshrc

echo "Mounted external user data ..."

exec "$@"