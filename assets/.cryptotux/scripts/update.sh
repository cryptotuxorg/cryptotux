#!/bin/bash -x
echo ">>> Update Script <<<"
echo ">> Update repositories"
sudo apt update && sudo apt upgrade -y
echo ">> Update other tooling"
#bash <(curl https://get.parity.io -L); # deprecated
npm update -g
echo ">> Update local git repositories"
cd /home/bobby/Tutorials
for i in */.git; do ( echo "> $i ";cd $i/..; git pull;); done;
# TODO : update tooling based on the new versions in cryptotux 
cd 
echo ">> Update done "
