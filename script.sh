## Clean and simplify 
sudo apt purge apparmor ufw
sudo apt purge cups-daemon whoopsie pulseaudio-utils
sudo apt purge ubuntu-release-upgrader-gtk update-manager update-notifier synaptic leafpad pavucontrol
sudo apt purge fonts-noto-cjk abiword abiword-common gnumeric audacious bluez
sudo apt purge xfburn guvcview sylpheed pidgin simple-scan xpad gnome mpv
sudo apt purge hunspell* pidgin-data humanity-icon-theme gnumeric-common qttranslations5-l10n  libsane1 hplib-data
sudo apt purge audacious-plugins audacious-plugins-data ffmpegthumbnailer galculator gnome-icon-theme gstreamer1.0-nice gstreamer1.0-plugins-bad gstreamer1.0-plugins-good libabiword-3.0 libmplex2-2.1-0 libfarstream-0.2-5 fcitx-data fcitx-modules
sudo apt purge adwaita-icon-theme cups cups-bsd cups-client cups-common cups-ppdc fonts-noto-color-emoji fonts-tibetan-machine gconf2-common geoclue-2.0 geoip-database gsfonts gucharmap iio-sensor-proxy libgoffice-0.10-10 libgoffice-0.10-10-common libpresage-data libpresage1v5 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 lubuntu-gtk-core lxlauncher printer-driver-gutenprint printer-driver-hpcups printer-driver-splix  xfce4-power-manager xfce4-power-manager-data xfce4-power-manager-plugins pulseaudio
sudo apt purge samba-libs

## Install development tools
sudo apt install curl git python3 vim emacs
curl https://sh.rustup.rs -sSf | sh

## Visual code
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install code

## Node.js + installing packages locally
curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt-get install -y nodejs
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo "export PATH=~/.npm-global/bin:$PATH" >> ~/.bashrc
rm nodesource_setup.sh
source .bashrc

## Install bitcoin development related tools
sudo add-apt-repository ppa:bitcoin/bitcoin
sudo apt install bitcoind bitcoin-qt
mkdir .bitcoin
cd .bitcoin 
wget https://raw.githubusercontent.com/bitcoin-studio/Bitcoin-Programming-with-BitcoinJS/master/code/bitcoin.conf

# Install Ethereum development nodes
bash <(curl https://get.parity.io -L)
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install ethereum
npm install -g ganache-cli

## Install Go environment (tendermint...)
wget https://dl.google.com/go/go1.12.4.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.12.4.linux-amd64.tar.gz 

echo "export GOROOT=/usr/local/go" >> ~/.bashrc
echo "export GOPATH=$HOME/go" >> ~/.bashrc
echo "export PATH=$GOPATH/bin:$GOROOT/bin:$PATH" >> ~/.bashrc
source ~/.bashrc

#Docker tooling
sudo apt install ca-certificates \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo usermod -a -G docker bobby

#Tutorials
mkdir Tutorials
cd Tutorials

git clone https://github.com/bitcoin-studio/Bitcoin-Programming-with-BitcoinJS.git
git clone https://github.com/Xalava/elemental-dapp.git
git clone https://github.com/cosmos/sdk-application-tutorial.git

# Config Preferences
echo '
alias update-pkg="sudo apt update && sudo apt upgrade -y"
alias update-all="bash ~/.update.sh' >> ~/.bashrc
npm install -g tldr

