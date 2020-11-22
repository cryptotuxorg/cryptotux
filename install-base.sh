#!/bin/bash 
set -x

export DEBIAN_FRONTEND=noninteractive #Prevents script from accessing stdin

echo "##  BASE SCRIPT  ##"
# This script, specific to vagrant, creates a user with full access and accessible admin rights

## Creation of user bobby, password bricodeur
adduser --quiet --disabled-password --shell /bin/bash --home /home/bobby --gecos "" bobby
usermod -aG sudo bobby
echo "bobby:bricodeur" | sudo chpasswd
cp -pr /home/vagrant/.ssh /home/bobby/
chown -R bobby:bobby /home/bobby/

## Potential Shared Folder
# mkdir /home/bobby/Shared
# chown -R bobby:bobby /home/bobby/Shared

## Convenience (don't do this at home) 
# Allow ssh password authentification
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config    
service ssh reload
# Remove password prompt for sudo
echo '%sudo   ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers

# Launching the main installation script as user bobby
DEBUG=true su -c "bash -x /vagrant/install-server.sh" bobby
