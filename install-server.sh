#!/bin/bash -x

echo "##  INSTALL CRYPTOTUX 🐢 SERVER SCRIPT  ##"
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
    # If empty or null, use provided default
    [[ -z $release || $release = "null" && -n $2 ]] && release=$2
    echo $release
}

## Install common development tools
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y \
    curl git python3 vim python3-pip \
    jq  > /dev/null 2>&1 # Useful json parser
echo "export PATH=$HOME/.local/bin:\$PATH" >> ~/.bashrc

## WSL specific (alternatively uname -a)
if grep -q Microsoft /proc/version; then
    echo "Thanks for trying Cryptotux on Windows !"
    echo "Make sure to use WSL2 or read the documentation"
fi

## Add Virtualbox additions 
if [[ $(sudo  dmidecode  | grep -i product | grep -i virtualbox ) ]] ; then
    sudo apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils 
fi


## Install Rust programming language tooling (Used for Libra)
cd
if [ ! -x "$(command -v rustc)" ] ; then
    curl https://sh.rustup.rs -sSf > rustup.sh
    sh rustup.sh -y 
    echo "export PATH=$HOME/.cargo/bin:\$PATH" >> ~/.bashrc
    rm rustup.sh
else
    rustup update
fi
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
bitcoinCoreVersion=$(latest_release bitcoin/bitcoin 0.20.1) 
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
mkdir -p ~/.bitcoin
echo '
# Add to user agent
uacomment=TuTux
txindex=1

# Local network for testing
regtest=1

# Accept JSON-RPC commands
server=1
rest=1

# Define access
rpcuser=bobby
rpcpassword=bricodeur
rpcallowip=127.0.0.1

# NB: default ports on regtest are 18443 RPC and 18444 P2P
' > ~/.bitcoin/bitcoin.conf

## Install Ethereum development nodes
# bash <(curl https://get.parity.io -L) # Divested and switched to OpenEthereum
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install -y ethereum
# If it failed, install binaries directly
if [ ! -x "$(command -v geth)" ] ; then
    gethVersion=geth-alltools-linux-amd64-1.9.21-0287d548
    wget -q https://gethstore.blob.core.windows.net/builds/$gethVersion.tar.gz
    tar xzf $gethVersion.tar.gz
    sudo install -m 0755 -o root -g root -t /usr/local/bin $gethVersion/*
    rm -rf $gethVersion
    rm "$gethVersion.tar.gz"
fi

## Install IPFS
IPFSVersion=$(latest_release ipfs/go-ipfs 0.6.0) 
wget -q https://dist.ipfs.io/go-ipfs/v$IPFSVersion/go-ipfs_v"$IPFSVersion"_linux-amd64.tar.gz
tar xvfz go-ipfs_v"$IPFSVersion"_linux-amd64.tar.gz
rm go-ipfs_v"$IPFSVersion"_linux-amd64.tar.gz
cd go-ipfs
sudo ./install.sh
cd
rm -rf go-ipfs

## Install Go environment (Used for Tendermint, Cosmos, Hyperledger Fabric and Libra)
goVersion=1.15.2
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
sudo apt-get install -y --no-install-recommends default-jdk maven 

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
microVersion=$(latest_release zyedidia/micro 2.0.7) 
wget -q "https://github.com/zyedidia/micro/releases/download/v$microVersion/micro-$microVersion-linux64-static.tar.gz"
tar xzf "micro-$microVersion-linux64-static.tar.gz"
sudo install -m 0755 -o root -g root -t /usr/local/bin micro-$microVersion/micro
rm -rf micro-$microVersion/
rm "micro-$microVersion-linux64-static.tar.gz"

## Modern and easy encryption tool 
ageVersion=$(latest_release FiloSottile/age 1.0.0-beta4) 
wget -q "https://github.com/FiloSottile/age/releases/download/v$ageVersion/age-v$ageVersion-linux-amd64.tar.gz"
tar xzf "age-v$ageVersion-linux-amd64.tar.gz"
sudo install -m 0755 -o root -g root -t /usr/local/bin age-v$ageVersion/age
rm -rf age-v$ageVersion/
rm "age-v$ageVersion-linux-amd64.tar.gz"

## Modern terminal file manager (cool addition, but complex installation that might break in future releases)
cd
git clone https://github.com/sebastiencs/icons-in-terminal.git
cd icons-in-terminal
./install-autodetect.sh 
./install
cd 
rm -rf icons-in-terminal
# Old 3.0 version is available at sudo apt install nnn
cd 
nnnVersion=$(latest_release jarun/nnn 3.4) 
wget -q "https://github.com/jarun/nnn/releases/download/v$nnnVersion/nnn-v$nnnVersion.tar.gz"
tar xzf "nnn-v$nnnVersion.tar.gz"
cd nnn-$nnnVersion
sudo apt-get install -y pkg-config libncursesw5-dev libreadline-dev
sudo make strip install O_ICONS=1
cd
rm -rf nnn-$nnnVersion/
rm "nnn-v$nnnVersion.tar.gz"

## Web terminal
ttydVersion=$(latest_release tsl0922/ttyd 1.6.1) 
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

## Login indication and boot cosmetic for virtual environments
if [[ $(sudo  dmidecode  | grep -i product | grep -iE 'virtualbox|vmware' ) ]] ; then
    # Console login greeter
    echo "Cryptotux $CRYPTOTUX_VERSION - \\l

    User is \"bobby\", password is \"bricodeur\"
    " | sudo tee /etc/issue | sudo tee /etc/issue.net

    # Silent launch
    echo 'GRUB_DEFAULT=0
    GRUB_TIMEOUT=0
    GRUB_RECORDFAIL_TIMEOUT=0
    GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
    GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=0 splash "
    GRUB_CMDLINE_LINUX=""' |sudo tee /etc/default/grub.d/10-local-settings.cfg
    sudo rm /etc/default/grub.d/50-cloudimg-settings.cfg
    sudo update-grub

    # Plymouth and theme
    sudo apt-get install -y plymouth-label
    sudo mkdir  /usr/share/plymouth/themes/cryptotux-text/
    echo "[Plymouth Theme]
    Name=Cryptotux Text
    Description=Text mode theme 
    ModuleName=ubuntu-text

    [ubuntu-text]
    title=Cryptotux $CRYPTOTUX_VERSION      
    black=0x000000
    white=0x00FFFF
    brown=0x009DFD
    blue=0x00182C" | sudo tee /usr/share/plymouth/themes/cryptotux-text/cryptotux-text.plymouth

    sudo ln -sf /usr/share/plymouth/themes/cryptotux-text/cryptotux-text.plymouth /etc/alternatives/text.plymouth
    sudo ln -sf /usr/share/plymouth/themes/cryptotux-text/cryptotux-text.plymouth /etc/alternatives/default.plymouth

    sudo update-initramfs -u
fi

## Tutorials
# Suggestions welcomed
cd 
mkdir Tutorials
cd Tutorials

# Great tutorial on bitcoinjs by Bitcoin Studio
git clone https://github.com/bitcoin-studio/Bitcoin-Programming-with-BitcoinJS.git
# A simple Ethereum DApp example
git clone https://github.com/Xalava/elemental-dapp.git Ethereum-elemental-dapp
# Another Ethereum example. Tutorial at https://medium.com/@austin_48503/programming-decentralized-money-300bacec3a4f
git clone https://github.com/austintgriffith/scaffold-eth

## Configuration Preferences 
cd
# Retrieve configuration files from this repo
mkdir -p ~/Projects/
git clone https://github.com/cryptotuxorg/cryptotux ~/Projects/Cryptotux
# Use Vagrant shared folder if available for the latest version or the github imported version
[ -d "/vagrant/assets" ] && cryptopath="/vagrant" ||  cryptopath="/home/$USER/Projects/Cryptotux"
# Copy of the configuration local folder
cp -R "${cryptopath}/assets/.cryptotux" .
# Install scripts are added to this local folder. They are separated for development readability
cp -R "${cryptopath}/install/" .cryptotux/

# Reduces shutdown speed in case of service failure (Quick and dirty approach)
sudo sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=10s/g' /etc/systemd/system.conf

# Cryptotux commands
echo '
function cryptotux {
    if [ -e ~/.cryptotux/scripts/$1.sh ] ; then
        bash ~/.cryptotux/scripts/$1.sh 
    else 
        if [ -e ~/.cryptotux/install/$1.sh ] ; then
            bash ~/.cryptotux/install/$1.sh
        else
            bash ~/.cryptotux/install/help.sh
        fi
    fi
}
alias cx="cryptotux"
complete -W "$( { ls ~/.cryptotux/scripts/; ls ~/.cryptotux/install/; }| rev | cut -c 4- | rev )" cx cryptotux
' >> ~/.bashrc
echo "export CRYPTOTUX_VERSION=$CRYPTOTUX_VERSION" >>  ~/.bashrc

# Nice command line help for beginners
npm install -g tldr 
echo 'alias tldr="tldr -t ocean"' >> ~/.bashrc
/home/$USER/.npm-global/bin/tldr update



# Pure fun and style 
sudo apt-get install -y cowsay 
echo '[ ! -e ~/.cryptotux/greeted ] && cryptotux turtle && touch ~/.cryptotux/greeted' >> ~/.profile
sed -i -e 's/#force_color_prompt/force_color_prompt/g' ~/.bashrc
# Customised prompt (ocean themed)
# PS1='\n${debian_chroot:+($debian_chroot)}\[\033[00;36m\]\u\[\033[00;90m\]@\[\033[00;32m\]\h\[\033[00;90m\]:\[\033[00;36m\]\w\[\033[00;90m\]$\[\033[00m\] '
sed -i '/PS1/c\
PS1="\\n${debian_chroot:+($debian_chroot)}\\[\\033[00;36m\\]\\u\\[\\033[00;90m\\]@\\[\\033[00;32m\\]\\h\\[\\033[00;90m\\]:\\[\\033[00;36m\\]\\w\\[\\033[00;90m\\]$\\[\\033[00m\\] "
' ~/.bashrc

# Display cryptotux help at every connection
echo 'cryptotux help' >> ~/.profile

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
        ufw
    sudo apt-get purge -y \
        cloud-guest-utils \
        cloud-initramfs-copymods \
        cloud-initramfs-dyn-netconf \
        cloud-init \
        multipath-tools \
        packagekit \
        apparmor 
    sudo apt-get autoremove -y
    #Add current user to vbox group, a reboot might be necessary
    sudo usermod -aG vboxsf $USER
fi

echo "## END OF INSTALL SERVER SCRIPT  ##"