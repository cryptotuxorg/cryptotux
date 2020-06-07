#!/bin/bash -x

echo "##  INSTALL SERVER SCRIPT  ##"
# This script installs common development tools and major blockchain networks nodes
# The script can be run on a fresh ubuntu server install as a user, and will potentially work on any debian installation
# Each section, denoted with  ##, is relatively independant from the context
# Contributions are welcome

export DEBIAN_FRONTEND=noninteractive
export CRYPTOTUX_VERSION=0.7

## Common functions
latest_release () {
    # Retrieve latest release name from github
    release=$(curl --silent "https://api.github.com/repos/$1/releases/latest" | jq -r .tag_name )
    # If first char is "v", remove it
    [[ $(echo $release | cut -c 1) = "v" ]] && release=$(echo $release | cut -c 2-)
    # If empty or null ("ull"), use provided default
    [[ -z $release || $release = "ull" && -n $2 ]] && release=$2
    echo $release
}

## Install common development tools
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y \
    curl git python3 vim python3-pip \
    jq  > /dev/null 2>&1 # Useful json parser

if [[ $(sudo  dmidecode  | grep -i product | grep -i virtualbox ) ]] ; then
    # Add Virtualbox additions 
    sudo apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils 
fi


## Install Rust programming language tooling (Used for Libra)
cd
curl https://sh.rustup.rs -sSf > rustup.sh
sh rustup.sh -y 
echo "export PATH=$HOME/.cargo/bin:\$PATH" >> ~/.bashrc
rm rustup.sh

## Node.js,npm and yarn and configuration for installing global packages in userspace (Used for tooling, especially in Ethereum)
cd 
nodeVersion=14.x # We force future LTS version
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
curl -sL https://deb.nodesource.com/setup_"$nodeVersion" -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt-get install -y nodejs yarn
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo "export PATH=~/.npm-global/bin:~/.config/yarn/global:\$PATH" >> ~/.bashrc
rm nodesource_setup.sh
source ~/.bashrc

## Install bitcoin development related tools
# 1/ PPA option (deprecated):
    # sudo add-apt-repository ppa:bitcoin/bitcoin
    # sudo apt-get install -y bitcoind
# 2/ snap option. But snap 🤷:
    # snap install bitcoin
# 3/ Direct download:
# Check for the latest release on github, otherwise use the latest known version
bitcoinCoreVersion=$(latest_release bitcoin/bitcoin 0.20.0) 
# Download bitcoin core from the serveur or the local dataShare folder
if [[ -e "/vagrant/dataShare/bitcoin-$bitcoinCoreVersion-x86_64-linux-gnu.tar.gz" ]] ; then
    # During development, import from a folder "dataShare" if available
	cp "/vagrant/dataShare/bitcoin-$bitcoinCoreVersion-x86_64-linux-gnu.tar.gz" .
else
    # Import from bitcoincore servers. It might be slow
	wget -q "https://bitcoincore.org/bin/bitcoin-core-$bitcoinCoreVersion/bitcoin-$bitcoinCoreVersion-x86_64-linux-gnu.tar.gz"
    # If shared folder is available, save for later
    [[ -e "/vagrant/dataShare/" ]] && sudo cp bitcoin-$bitcoinCoreVersion-x86_64-linux-gnu.tar.gz /vagrant/dataShare/
fi
tar xzf "bitcoin-$bitcoinCoreVersion-x86_64-linux-gnu.tar.gz"
# TODO: add verification
sudo install -m 0755 -o root -g root -t /usr/local/bin bitcoin-$bitcoinCoreVersion/bin/*
wget -q "https://raw.githubusercontent.com/bitcoin/bitcoin/master/share/pixmaps/bitcoin128.png"
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
    wget -q https://gethstore.blob.core.windows.net/builds/$gethVersion.tar.gz
    tar xzf $gethVersion.tar.gz
    sudo install -m 0755 -o root -g root -t /usr/local/bin $gethVersion/*
    rm -rf $gethVersion
    rm "$gethVersion.tar.gz"
fi

## Install IPFS
IPFSVersion=$(latest_release ipfs/go-ipfs 0.5.1) 
wget -q https://dist.ipfs.io/go-ipfs/v$IPFSVersion/go-ipfs_v"$IPFSVersion"_linux-amd64.tar.gz
tar xvfz go-ipfs_v"$IPFSVersion"_linux-amd64.tar.gz
rm go-ipfs_v"$IPFSVersion"_linux-amd64.tar.gz
cd go-ipfs
sudo ./install.sh
cd
rm -rf go-ipfs

## Install Go environment (Used for Tendermint, Cosmos, Hyperledger Fabrci and Libra)
goVersion=1.14.4
if [[ -e /vagrant/dataShare/go"$goVersion".linux-amd64.tar.gz ]] ; then
    # During development, import from a folder "dataShare" if available
	cp /vagrant/dataShare/go"$goVersion".linux-amd64.tar.gz .
else
    # Import from google servers.
	wget -q https://dl.google.com/go/go"$goVersion".linux-amd64.tar.gz
    # If shared folder is available, save for later
    [[ -e "/vagrant/dataShare/" ]] && sudo cp go"$goVersion".linux-amd64.tar.gz /vagrant/dataShare/
fi

sudo tar -C /usr/local -xzf go"$goVersion".linux-amd64.tar.gz 
rm go"$goVersion".linux-amd64.tar.gz

echo "export GOROOT=/usr/local/go" >> ~/.bashrc
echo "export GOPATH=\$HOME/go" >> ~/.bashrc
echo "export PATH=\$GOPATH/bin:\$GOROOT/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc

## Java environment (used in Corda)
sudo apt-get install -y default-jdk maven 

## Docker tooling (Used in Hyperledger Fabric and Quorum )
dockerComposeVersion=$(latest_release docker/compose)
sudo apt-get install -y \
    apt-transport-https\
    ca-certificates \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo curl -L "https://github.com/docker/compose/releases/download/$dockerComposeVersion/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo usermod -a -G docker $USER

## A modern command line text editor 
microVersion=$(latest_release zyedidia/micro 2.0.4) 
wget -q "https://github.com/zyedidia/micro/releases/download/v$microVersion/micro-$microVersion-linux64-static.tar.gz"
tar xzf "micro-$microVersion-linux64-static.tar.gz"
sudo install -m 0755 -o root -g root -t /usr/local/bin micro-$microVersion/micro
rm -rf micro-$microVersion/
rm "micro-$microVersion-linux64-static.tar.gz"

## Web terminal
ttydVersion=$(latest_release tsl0922/ttyd 1.6.0) 
wget -q https://github.com/tsl0922/ttyd/releases/download/$ttydVersion/ttyd_linux.x86_64 -O ttyd
chmod +x ttyd
sudo mv ttyd /usr/local/bin
# -E do not seem to transfert the current user to 'sh' but this shit does
sudo USER=$USER sh -c 'echo "[Unit]
Description=Web based command line

[Service]
User=$USER
ExecStart=/usr/local/bin/ttyd -p 3310 -u $USER bash
WorkingDirectory=/home/$USER/

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/ttyd.service'
sudo systemctl daemon-reload
sudo systemctl enable ttyd
sudo service ttyd start

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
mkdir -p ~/Projects/
git clone https://github.com/cryptotuxorg/cryptotux ~/Projects/Cryptotux
# Use Vagrant shared folder if available for the latest version or the github imported version
[ -d "/vagrant/assets" ] && cryptopath="/vagrant" ||  cryptopath="/home/$USER/Projects/Cryptotux"
cp -R "${cryptopath}/assets/.bitcoin" .
cp -R "${cryptopath}/assets/.cryptotux" .
cp "${cryptopath}/install-desktop.sh" .cryptotux/scripts/

# Reduces shutdown speed in case of service failure (Quick and dirty approach)
sudo sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=10s/g' /etc/systemd/system.conf

# Cryptotux commands
echo '
function cryptotux {
    [ -e ~/.cryptotux/scripts/$1.sh ] && bash ~/.cryptotux/scripts/$1.sh || cat ~/.cryptotux/welcome.txt
}
alias cx="cryptotux"
complete -W "$( echo $(ls .cryptotux/scripts/ | rev | cut -c 4- | rev))" cx cryptotux
' >> ~/.bashrc

#Nice command line help for beginners
npm install -g tldr 
echo 'alias tldr="tldr -t ocean"' >> ~/.bashrc
/home/$USER/.npm-global/bin/tldr update

sudo apt-get install -y cowsay 
echo '(echo "Welcome to Cryptotux !"; )| /usr/games/cowsay -f turtle ' >> ~/.profile
sed -i -e 's/#force_color_prompt/force_color_prompt/g' ~/.bashrc
echo '[ ! -e ~/.cryptotux/greeted ] && cryptotux help && touch  ~/.cryptotux/greeted' >> ~/.profile
# Simplify ssh display
sudo chmod -x /etc/update-motd.d/*
sudo sh -c 'echo "echo" >> /etc/update-motd.d/50-landscape-sysinfo'
sudo chmod +x /etc/update-motd.d/50-landscape-sysinfo

## Optimization (potential security and dependencies issues)
# In a virtual environement, remove packages that are cloud and security oriented
# Prior approach : if [ -d "/vagrant/assets" ] 
if [[ $(sudo  dmidecode  | grep -i product | grep -iE 'virtualbox|vmware' ) ]] ; then
sudo apt-get purge -y \
  snapd \
  apport \
  ubuntu-release-upgrader-core \
  update-manager-core \
  unattended-upgrades \
  ufw \
  cloud-guest-utils \
  cloud-initramfs-copymods \
  cloud-initramfs-dyn-netconf \
  cloud-init \
  multipath-tools \
  packagekit \
  apparmor 
fi

## Last update
sudo apt-get update && sudo apt-get upgrade -y 
sudo apt-get autoremove -y
sudo usermod -aG vboxsf $USER # A reboot might be necessary 
echo "## END OF INSTALL SERVER SCRIPT  ##"