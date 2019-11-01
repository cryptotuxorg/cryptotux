#!/bin/bash -x
export DEBIAN_FRONTEND=noninteractive #Prevent from accessing stdin, doesn't seem effective

echo "##  BASE SCRIPT  ##"
# This scripts creates an user bobby with full access

## Create user bobby
adduser --quiet --disabled-password --shell /bin/bash --home /home/bobby --gecos "" bobby
usermod -aG sudo bobby
echo "bobby:bricodeur" | sudo chpasswd
cp -pr /home/vagrant/.ssh /home/bobby/
chown -R bobby:bobby /home/bobby/
chown -R bobby:bobby /dataShare/
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config    
service ssh reload
echo '%sudo   ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers

## Launching the main installation script as user bobby
su -c "source /vagrant/scripts/install-server.sh" bobby
