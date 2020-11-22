#!/bin/bash 

### Ethereum ###
#!/bin/bash
if "$DEBUG"; then
    echo "Ethereum script launched with S@"
    # Debug is set in the launching install-base script by default.
    # This will display every line. Otherwise only explicit outputs are visible
    set -x
else
    exec > /dev/null
fi

## geth node 

if [ "$1" = "base" ] || [ "$1" = "full" ]; then
    # bash <(curl https://get.parity.io -L) # Divested and switched to OpenEthereum
    sudo add-apt-repository -y ppa:ethereum/ethereum
    sudo apt-get update
    sudo apt-get install -y ethereum
    # If it failed, install binaries directly
    if [ ! -x "$(command -v geth)" ] ; then
        # TODO maybe automate the next line 
        gethVersion=geth-alltools-linux-amd64-1.9.24-cc05b050
        wget -q https://gethstore.blob.core.windows.net/builds/$gethVersion.tar.gz
        tar xzf $gethVersion.tar.gz
        sudo install -m 0755 -o root -g root -t /usr/local/bin $gethVersion/*
        rm -rf $gethVersion
        rm "$gethVersion.tar.gz"
    fi
    # Helper to start a project with hardhat
    echo '
    start_eth_project () {
        if [[ -z $1  ]] ; then
            project="newProject"
        else
            project=$1
        fi
        mkdir $project
        cd $project 
        npm init
        npm install --save-dev @nomiclabs/hardhat
        npx hardhat
    }
    ' >> ~/.bashrc

    if [ "$1" = "base" ]; then
        return 1 
    fi
fi

## Development environment
npm install -g truffle
npm install -g ganache-cli
# npm install --global @openzeppelin/cli DEPRECATED

## Hyperledger Besu 
besuVersion=$(latest_release hyperledger/besu 20.10.1) 
sudo apt-get install -y unzip # Installed in main script normally
mkdir -p ~/Projects
cd ~/Projects
wget -q https://dl.bintray.com/hyperledger-org/besu-repo/besu-$besuVersion.zip
unzip -q besu-$besuVersion.zip
rm besu-$besuVersion.zip

## Ethereum 2.0 
# Install Lighthouse
sudo apt-get install cmake libssl-dev -y
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
