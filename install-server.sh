#!/bin/bash -x

echo "##  INSTALL SERVER SCRIPT  ##"
# This script installs common development tools and major blockchain networks nodes
# The script can be run on a fresh ubuntu server install as a user, and will potentially work on any debian installation
# Each section, denoted with  ##, is relatively independant from the context
# Contributions are welcome

export DEBIAN_FRONTEND=noninteractive

## Install common development tools
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install -y curl git python3 vim python3-pip # Most likely already there
sudo apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils # Virtualbox interaction
sudo apt-get install -y jq # Useful json parser

## Install Rust programming language tooling (Used for Libra)
cd
curl https://sh.rustup.rs -sSf > rustup.sh
sh rustup.sh -y 
echo "export PATH=$HOME/.cargo/bin:\$PATH" >> ~/.bashrc
rm rustup.sh

## Node.js and configuration for installing global packages in userspace (Used for tooling, especially in Ethereum)
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
if [-e "/vagrant/dataShare/bitcoin-$bitcoinCoreVersion-x86_64-linux-gnu.tar.gz"]
then
    # During development, import from a folder "dataShare" if available
	cp "/vagrant/dataShare/bitcoin-$bitcoinCoreVersion-x86_64-linux-gnu.tar.gz" .
else
    # Import from bitcoincore servers. It might be slow
	wget "https://bitcoincore.org/bin/bitcoin-core-$bitcoinCoreVersion/bitcoin-$bitcoinCoreVersion-x86_64-linux-gnu.tar.gz"

fi
tar xzf "bitcoin-$bitcoinCoreVersion-x86_64-linux-gnu.tar.gz"
sudo install -m 0755 -o root -g root -t /usr/local/bin bitcoin-$bitcoinCoreVersion/bin/*
wget "https://raw.githubusercontent.com/bitcoin/bitcoin/master/share/pixmaps/bitcoin128.png"
sudo cp bitcoin128.png /usr/share/pixmaps/
rm bitcoin128.png
rm -rf bitcoin-$bitcoinCoreVersion/
rm "bitcoin-$bitcoinCoreVersion-x86_64-linux-gnu.tar.gz"

## Install Ethereum development nodes
# bash <(curl https://get.parity.io -L) # Divested and switched to OpenEthereum
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install -y ethereum
# If it failed, install binaries directly
if [ ! -x "$(command -v geth)" ] ; then
    gethVersion=geth-alltools-linux-amd64-1.9.14-6d74d1e5
    wget https://gethstore.blob.core.windows.net/builds/$gethVersion.tar.gz
    tar xzf $gethVersion.tar.gz
    sudo install -m 0755 -o root -g root -t /usr/local/bin $gethVersion/*
    rm -rf $gethVersion
    rm "$gethVersion.tar.gz"
fi

## Install IPFS
IPFSVersion=0.5.0
wget https://dist.ipfs.io/go-ipfs/v$IPFSVersion/go-ipfs_v"$IPFSVersion"_linux-amd64.tar.gz
tar xvfz go-ipfs_v"$IPFSVersion"_linux-amd64.tar.gz
rm go-ipfs_v"$IPFSVersion"_linux-amd64.tar.gz
cd go-ipfs
sudo ./install.sh
cd
rm -rf go-ipfs

## Install Go environment (Used for Tendermint, Cosmos, Hyperledger Fabrci and Libra)
goVersion=1.14.3
wget https://dl.google.com/go/go"$goVersion".linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go"$goVersion".linux-amd64.tar.gz 
rm go"$goVersion".linux-amd64.tar.gz

echo "export GOROOT=/usr/local/go" >> ~/.bashrc
echo "export GOPATH=\$HOME/go" >> ~/.bashrc
echo "export PATH=\$GOPATH/bin:\$GOROOT/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc

## Java environment (used in Corda)
sudo apt-get install -y default-jdk maven 

## Docker tooling (Used in Hyperledger Fabric and Quorum )
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

## A modern command line text editor 
microVersion=2.0.4 
wget "https://github.com/zyedidia/micro/releases/download/v$microVersion/micro-$microVersion-linux64-static.tar.gz"
tar xzf "micro-$microVersion-linux64-static.tar.gz"
sudo install -m 0755 -o root -g root -t /usr/local/bin micro-$microVersion/micro
rm -rf micro-$microVersion/
rm "micro-$microVersion-linux64-static.tar.gz"

## Tutorials
# Suggestions welcomed
cd 
mkdir Tutorials
cd Tutorials

# Great tutorial on bitcoinjs by Bitcoin Studio
git clone https://github.com/bitcoin-studio/Bitcoin-Programming-with-BitcoinJS.git
# A simple Ethereum DApp example
git clone https://github.com/Xalava/elemental-dapp.git Ethereum-elemental-dapp
# Cosmos SDK tutorial
git clone https://github.com/cosmos/sdk-application-tutorial.git Cosmos-sdk-tutorial


## Configuration Preferences 
cd
# Retrieve configuration files from this repo
git clone https://github.com/cryptotuxorg/cryptotux ~/Cryptotux-repository
# Use Vagrant shared folder if available for the latest version or the github imported version
[ -d "/vagrant/assets" ] && cryptopath="/vagrant" ||  cryptopath="/home/$USER/Cryptotux-repository"
cp -R "${cryptopath}/assets/.bitcoin" .
cp -R "${cryptopath}/assets/.cryptotux" .
cp "${cryptopath}/install-desktop.sh" .cryptotux/scripts/

# Reduces shutdown speed in case of service failure (Quick and dirty approach)
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

## Optimization attempt (potential security and dependencies issues)
# Check if it is a local build, otherwise do nothign
if [ -d "/vagrant/assets" ] 
then
sudo apt-get purge -y \
  snapd \
  apport \
  ubuntu-release-upgrader-core \
  update-manager-core \
  unattended-upgrades \

sudo service docker stop
sudo service containerd stop
sudo service rsyslogd stop
fi

## Last update
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove -y
sudo usermod -aG vboxsf bobby # A reboot might be necessary 
echo "## END OF INSTALL SERVER SCRIPT  ##"