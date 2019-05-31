#!/bin/bash -x

echo "##  INSTALL SERVER SCRIPT  ##"
# This script installs common development tools and major blockchain networks nodes
# The script can be run on a fresh ubuntu server install as a user
# Each section, except the last one, is relatively independant from the context
# Contributions are welcome

export DEBIAN_FRONTEND=noninteractive

## Install common development tools
sudo apt-get update
sudo apt-get install -y curl git python3 vim python3-pip # Most likely already there
sudo apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils 
cd
curl https://sh.rustup.rs -sSf > rustup.sh
sh rustup.sh -y 
echo "export PATH=$HOME/.cargo/bin:\$PATH" >> ~/.bashrc
rm rustup.sh

## Node.js + installing packages locally
cd 
nodeVersion=10.x
curl -sL https://deb.nodesource.com/setup_"$nodeVersion" -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt-get install -y nodejs
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo "export PATH=~/.npm-global/bin:\$PATH" >> ~/.bashrc
rm nodesource_setup.sh
source ~/.bashrc

## Install bitcoin development related tools
sudo add-apt-repository ppa:bitcoin/bitcoin
sudo apt-get install -y bitcoind

## Install Ethereum development nodes
bash <(curl https://get.parity.io -L)
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install -y ethereum

## Install IPFS
IPFSVersion=0.4.20
wget https://dist.ipfs.io/go-ipfs/v$IPFSVersion/go-ipfs_v"$IPFSVersion"_linux-amd64.tar.gz
tar xvfz go-ipfs_v"$IPFSVersion"_linux-amd64.tar.gz
rm go-ipfs_v"$IPFSVersion"_linux-amd64.tar.gz
cd go-ipfs
sudo ./install.sh
cd
rm -rf go-ipfs

## Install Go environment (for tendermint ...)
goVersion=1.12.4
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
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo usermod -a -G docker $USER

## Tutorials
cd 
mkdir Tutorials
cd Tutorials

git clone https://github.com/bitcoin-studio/Bitcoin-Programming-with-BitcoinJS.git
git clone https://github.com/Xalava/elemental-dapp.git
git clone https://github.com/cosmos/sdk-application-tutorial.git
git clone https://github.com/cryptotuxorg/cryptotux

## Configuration Preferences
cd 
cp -R /vagrant/assets/.config/ .
cp -R /vagrant/assets/.bitcoin/ .
cp -R /vagrant/scripts/ .

echo '
alias update-pkg="sudo apt-get update && sudo apt-get upgrade -y"
alias update-all="bash ~/scripts/update.sh"
alias update-clean="bash ~/scripts/clean.sh"' >> ~/.bashrc
npm install -g tldr
sudo apt-get install -y cowsay 
echo '(echo "Welcome to Cryptotux !"; )| cowsay -f turtle ' >> ~/.bashrc
sed -i -e 's/#force_color_prompt/force_color_prompt/g' ~/.bashrc
