#!/bin/bash -x

### Ethereum ###
# geth node have been already installed by the server script

## Development environment
npm install -g truffle
npm install -g ganache-cli
npm install --global @openzeppelin/cli
echo '
#start_eth_project () {
    if [[ -z $1  ]] ; then
        project="newProject"
    else
        project=$1
    fi
    mkdir $project
    cd $project 
    npm init
    npm install --save-dev @nomiclabs/buidler
    npx buidler
}
' > ~/.bashrc

## Hyperledger Besu 
besuVersion=$(latest_release hyperledger/besu 20.10.1) 
mkdir -p ~/Projects
cd ~/Projects
wget -q https://dl.bintray.com/hyperledger-org/besu-repo/besu-$besuVersion.zip
unzip -q besu-$besuVersion.zip
rm besu-$besuVersion.zip

## Ethereum 2.0 
# Install Lighthouse
sudo apt install cmake libssl-dev
mkdir -p ~/Projects
cd ~/Projects
git clone https://github.com/sigp/lighthouse.git
cd lighthouse
make
cd

# Install Prysm 
cd ~/Projects
git clone https://github.com/prysmaticlabs/prysm 
cd ./prysm
./prysm.sh validator accounts create –keystore-path=$HOME/validator
# Launch with 
# ./prysm.sh beacon-chain
# ./prysm.sh validator –keystore-path=$HOME/validator
cd

# Generate validators keys
cd ~/Projects
git clone https://github.com/ethereum/eth2.0-deposit-cli.git
cd eth2.0-deposit-cli
sudo ./deposit.sh install
# Launch with 
# ./deposit.sh --num_validators 5 --chain medalla
cd

echo -e '\033[1mEthereum dev installed\033[0m'
