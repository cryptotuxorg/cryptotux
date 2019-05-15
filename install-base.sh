#!/bin/bash -x
export DEBIAN_FRONTEND=noninteractive #Prevent from accessing stdin, doesn't seem efficient

echo "##  BASE SCRIPT  ##"

## Create user bobby
adduser --quiet --disabled-password --shell /bin/bash --home /home/bobby --gecos "" bobby
usermod -aG sudo bobby
echo "bobby:bricodeur" | sudo chpasswd
cp -pr /home/vagrant/.ssh /home/bobby/
chown -R bobby:bobby /home/bobby/.ssh
echo '%sudo   ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers

su -c "source /vagrant/install-server.sh" bobby
