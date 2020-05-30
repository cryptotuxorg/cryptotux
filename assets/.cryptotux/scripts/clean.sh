#!/bin/bash -x
echo ">>> Cleaning Script <<<"
echo ">> Warning : Script designed for light image release, might be harsh for usual maintenance"
sudo apt-get autoclean -y; 
sudo apt-get -y clean; 
sudo apt-get -y --purge autoremove;
# bleachbit -c --preset  
rm -rf ~/.cache/thumbnails/*
sudo rm -rf /var/log/*
sudo rm -rf /home/*/.local/share/Trash/*
sudo rm -rf /root/.local/share/Trash/*
sudo find /tmp -type f -atime +1 -delete

dd if=/dev/zero of=/var/tmp/bigemptyfile bs=4096k
rm /var/tmp/bigemptyfile

rm .cryptotux/greeted
rm ~/.bash_history

echo ">>> Cleaning done <<<"