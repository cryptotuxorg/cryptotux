#!/bin/bash 
# This script, specific to docker, creates a user with full access and accessible admin rights

# Launch options
# set -x # display every command
export DEBIAN_FRONTEND=noninteractive #Prevents script from accessing stdin
echo "##  CONFIG SCRIPT  ##"

## Creation of default user
CUSTOMUSER=bobby
CUSTOMPASS=bricodeur
# We create a new one instead of modifying the existing one.
apt-get update && apt-get -y install sudo ssh
adduser --quiet --disabled-password --shell /bin/bash --home /home/$CUSTOMUSER --gecos "" $CUSTOMUSER
usermod -aG sudo $CUSTOMUSER
echo "$CUSTOMUSER:$CUSTOMPASS" | sudo chpasswd
# cp -pr /home/vagrant/.ssh /home/$CUSTOMUSER/
chown -R $CUSTOMUSER:$CUSTOMUSER /home/$CUSTOMUSER/

## Potential Shared Folder
# mkdir /home/$CUSTOMUSER/Shared
# chown -R $CUSTOMUSER:$CUSTOMUSER /home/$CUSTOMUSER/Shared

## Convenience (don't do this at home) 
# Allow ssh password authentification
# sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config    
# service ssh reload
# Remove password prompt for sudo
echo '%sudo   ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers
echo "$CUSTOMUSER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$CUSTOMUSER

# Launching the main installation script as user $CUSTOMUSER
# DEBUG=true su -c "bash -x /vagrant/install-server.sh" $CUSTOMUSER
