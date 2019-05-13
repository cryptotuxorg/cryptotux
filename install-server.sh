## Create user bobby
sudo adduser --quiet --disabled-password --shell /bin/bash --home /home/bobby --gecos "" bobby
echo "bobby:bricodeur" | sudo chpasswd
sudo -u bobby -i

## Install common development tools
sudo apt install -y curl git python3 vim 
curl https://sh.rustup.rs -sSfy | sh

## Node.js + installing packages locally
curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt-get install -y nodejs
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo "export PATH=~/.npm-global/bin:$PATH" >> ~/.bashrc
rm nodesource_setup.sh

## Install bitcoin development related tools
sudo add-apt-repository ppa:bitcoin/bitcoin
sudo apt install -y bitcoind
mkdir ~/.bitcoin
cd ~/.bitcoin 
wget https://raw.githubusercontent.com/bitcoin-studio/Bitcoin-Programming-with-BitcoinJS/master/code/bitcoin.conf

## Install Ethereum development nodes
bash <(curl https://get.parity.io -L)
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install -y ethereum

## Install Go environment (for tendermint ...)
wget https://dl.google.com/go/go1.12.4.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.12.4.linux-amd64.tar.gz 

echo "export GOROOT=/usr/local/go" >> ~/.bashrc
echo "export GOPATH=$HOME/go" >> ~/.bashrc
echo "export PATH=$GOPATH/bin:$GOROOT/bin:$PATH" >> ~/.bashrc
source ~/.bashrc

## Docker tooling
sudo apt install ca-certificates \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo usermod -a -G docker $USER

## Tutorials
mkdir Tutorials
cd Tutorials

git clone https://github.com/bitcoin-studio/Bitcoin-Programming-with-BitcoinJS.git
git clone https://github.com/Xalava/elemental-dapp.git
git clone https://github.com/cosmos/sdk-application-tutorial.git

## Configuration Preferences
cd
git clone https://github.com/cryptotuxorg/cryptotux
cp -R cryptotux/assets/.config/ .
echo '
alias update-pkg="sudo apt update && sudo apt upgrade -y"
alias update-all="bash ~/cryptotux/update.sh' >> ~/.bashrc
npm install -g tldr
sudo apt install -y cowsay 
echo '(echo "Welcome to Cryptotux !"; )| cowsay -f turtle ' >> ~/.bashrc