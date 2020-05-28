#!/bin/bash -x

echo "##  INSTALL SERVER SCRIPT  ##"
# This script installs common development tools and major blockchain networks nodes
# The script can be run on a fresh ubuntu server install as a user
# Each section, except the last one, is relatively independant from the context
# Contributions are welcome

export DEBIAN_FRONTEND=noninteractive

## Install common development tools
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install -y curl git python3 vim python3-pip # Most likely already there
sudo apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils # Virtualbox interaction
sudo apt-get install -y jq # Useful json parser

## Install Rust programming language tooling
cd
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
# For development
# cp "/vagrant/dataShare/bitcoin-$bitcoinCoreVersion-x86_64-linux-gnu.tar.gz" .
tar xzf "bitcoin-$bitcoinCoreVersion-x86_64-linux-gnu.tar.gz"
sudo install -m 0755 -o root -g root -t /usr/local/bin bitcoin-$bitcoinCoreVersion/bin/*
wget "https://raw.githubusercontent.com/bitcoin/bitcoin/master/share/pixmaps/bitcoin128.png"
install -m 0644 -D -t /usr/share/pixmaps/bitcoin128.png
rm -rf bitcoin-$bitcoinCoreVersion/
rm "bitcoin-$bitcoinCoreVersion-x86_64-linux-gnu.tar.gz"

## Install Ethereum development nodes
# bash <(curl https://get.parity.io -L) # Divested and switched to OpenEthereum
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
goVersion=1.14.3
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
# In prod to have an homogenous retrieval
# cryptopath="Tutorials/cryptotux"
# During development to have the lastest versions
cryptopath="/vagrant"
cp -R "${cryptopath}/assets/.config" .
cp -R "${cryptopath}/assets/.bitcoin" .
cp -R "${cryptopath}/assets/.cryptotux" .
cp -R "${cryptopath}/assets/.local" .
cp -R "${cryptopath}/assets/.themes" .

cp "${cryptopath}/install-desktop.sh" .cryptotux/scripts/

# Reduces shutdown speed in case of service failure
sudo sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=10s/g' /etc/systemd/system.conf

# Cryptotux commands
echo '
alias cryptotux-update="source ~/.cryptotux/scripts/update.sh"
alias cryptotux-clean="source ~/.cryptotux/scripts/clean.sh"
alias cryptotux-versions="source ~/.cryptotux/scripts/versions.sh"
alias cryptotux-desktop="bash ~/.cryptotux/scripts/install-desktop.sh"' >> ~/.bashrc

#Nice command line help for beginners
npm install -g tldr 
echo 'alias tldr="tldr -t ocean"' >> ~/.bashrc
/home/bobby/.npm-global/bin/tldr update

sudo apt-get install -y cowsay 
echo '(echo "Welcome to Cryptotux !"; )| cowsay -f turtle ' >> ~/.bashrc
sed -i -e 's/#force_color_prompt/force_color_prompt/g' ~/.bashrc

## Optimization attempt (potential break, security issues and dependencies)
#  apparmor > necessary for docker anyway
sudo apt-get purge -y \
  snapd \
  cloud-init \
  multipath-tools \
  packagekit \
  apport \
  cloud-guest-utils \
  cloud-initramfs-copymods \
  cloud-initramfs-dyn-netconf \
  ubuntu-release-upgrader-core \
  update-manager-core \
  ufw \
  unattended-upgrades \
  apparmor
sudo apt-get autoremove -y

sudo service docker stop
sudo service containerd stop
sudo service rsyslogd stop

## Last update
sudo apt-get update && sudo apt-get upgrade -y
sudo usermod -aG vboxsf bobby
echo "## END OF INSTALL SERVER SCRIPT  ##"