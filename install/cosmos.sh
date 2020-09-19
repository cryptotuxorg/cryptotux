#!/bin/bash -x

### Cosmos ###

# Github utility
sudo apt install hub git make -y
# adding github key (useful once github user is connected)
ssh-keyscan github.com >> ~/.ssh/known_hosts

# Cosmos SDK tutorial
cd
mkdir -p Tutorials
cd Tutorials
git clone https://github.com/cosmos/scaffold.git Cosmos-scaffold && cd Cosmos-scaffold && make
cd /home/$USER/Tutorials
git clone https://github.com/cosmos/sdk-tutorials.git Cosmos-sdk-tutorials

echo -e "$B\nCosmos installed.$N Cosmos tutorials available in ~/Tutorials"
echo "See https://docs.cosmos.network"