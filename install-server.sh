#!/bin/bash -x

echo "##  INSTALL SERVER SCRIPT  ##"
# This script installs common development tools and major blockchain networks nodes
# The script can be run on a fresh ubuntu server install as a user
# Each section, except the last one, is relatively independant from the context
# Contributions are welcome

export DEBIAN_FRONTEND=noninteractive

## Install common development tools
sudo apt-get update && sudo apt upgrade
sudo apt-get install -y curl git python3 vim python3-pip # Most likely already there
sudo apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils # Virtualbox interaction
sudo apt-get install -y jq #useful json parser
cd

## Install Rust programming language tooling
curl https://sh.rustup.rs -sSf > rustup.sh
sh rustup.sh -y 
echo "export PATH=$HOME/.cargo/bin:\$PATH" >> ~/.bashrc
rm rustup.sh

## Node.js and configuration for installing global packages in userspace
cd 
nodeVersion=14.x
curl -sL https://deb.nodesource.com/setup_"$nodeVersion" -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt-get install -y nodejs
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo "export PATH=~/.npm-global/bin:\$PATH" >> ~/.bashrc
rm nodesource_setup.sh
source ~/.bashrc

## Install bitcoin development related tools
# PPA option (deprecated)
    # sudo add-apt-repository ppa:bitcoin/bitcoin
    # sudo apt-get install -y bitcoind
# snap option. But snap 🤷
    # snap install bitcoin
# Direct download
bitcoinCoreVersion=0.19.1 
wget "https://bitcoincore.org/bin/bitcoin-core-$bitcoinCoreVersion/bitcoin-$bitcoinCoreVersion-x86_64-linux-gnu.tar.gz"
tar xzf "bitcoin-$bitcoinCoreVersion-x86_64-linux-gnu.tar.gz"
sudo install -m 0755 -o root -g root -t /usr/local/bin bitcoin-$bitcoinCoreVersion/bin/*
rm -rf bitcoin-$bitcoinCoreVersion/
## TODO: Check gui dependencies

## Install Ethereum development nodes
bash <(curl https://get.parity.io -L)
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install -y ethereum

## Install IPFS
IPFSVersion=0.5.0
wget https://dist.ipfs.io/go-ipfs/v$IPFSVersion/go-ipfs_v"$IPFSVersion"_linux-amd64.tar.gz
tar xvfz go-ipfs_v"$IPFSVersion"_linux-amd64.tar.gz
rm go-ipfs_v"$IPFSVersion"_linux-amd64.tar.gz
cd go-ipfs
sudo ./install.sh
cd
rm -rf go-ipfs

## Install Go environment (for tendermint ...)
goVersion=1.14.2
wget https://dl.google.com/go/go"$goVersion".linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go"$goVersion".linux-amd64.tar.gz 
rm go"$goVersion".linux-amd64.tar.gz

echo "export GOROOT=/usr/local/go" >> ~/.bashrc
echo "export GOPATH=\$HOME/go" >> ~/.bashrc
echo "export PATH=\$GOPATH/bin:\$GOROOT/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc

## Docker tooling
sudo apt-get install -y ca-certificates \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0-rc4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo usermod -a -G docker $USER

## Tutorials
# Suggestions welcomed
cd 
mkdir Tutorials
cd Tutorials

# Great tutorial on bitcoinjs by Bitcoin Studio
git clone https://github.com/bitcoin-studio/Bitcoin-Programming-with-BitcoinJS.git
# A simple Ethereum DApp example
git clone https://github.com/Xalava/elemental-dapp.git
# Cosmos SDK tutorial
git clone https://github.com/cosmos/sdk-application-tutorial.git
# This virtual machine (it is also a portable way to get assets for further configuration)
git clone https://github.com/cryptotuxorg/cryptotux


## Configuration Preferences
cd 
cp -R Tutorials/cryptotux/assets/.config/ .
cp -R Tutorials/cryptotux/assets/.bitcoin/ .
cp -R Tutorials/cryptotux/assets/scripts/ .

echo '
alias update-pkg="sudo apt-get update && sudo apt-get upgrade -y"
alias update-all="bash ~/scripts/update.sh"
alias update-clean="bash ~/scripts/clean.sh"' >> ~/.bashrc
npm install -g tldr #Nice command line help for beginners
tldr update
sudo apt-get install -y cowsay 
echo '(echo "Welcome to Cryptotux !"; )| cowsay -f turtle ' >> ~/.bashrc
sed -i -e 's/#force_color_prompt/force_color_prompt/g' ~/.bashrc
