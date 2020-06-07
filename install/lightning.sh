#!/bin/bash -x

### Lightning ###
# Assumes Bitcoin node and regtest configuration from main script

B="\033[1m"
N="\033[0m"

## Base configuration based on bitcoin.conf provided with Cryptotux
echo '
zmqpubrawblock=tcp://127.0.0.1:28332
zmqpubrawtx=tcp://127.0.0.1:28333
addresstype=p2sh-segwit
' >> ~/.bitcoin/bitcoin.conf

## Install eclair
# TODO:global function of latest release and include tag
sudo apt-get install unzip
eclairVersion="0.4"
eclairTag="69c538e"
wget -q https://github.com/ACINQ/eclair/releases/download/v$eclairVersion/eclair-node-$eclairVersion-$eclairTag-bin.zip
unzip eclair-node-$eclairVersion-$eclairTag-bin.zip
sudo install -m 0755 -o root -g root -t /usr/local/bin/ eclair-node-$eclairVersion-$eclairTag/bin/*
sudo install -m 0755 -o root -g root -t /usr/local/lib/ eclair-node-$eclairVersion-$eclairTag/lib/*
mkdir -p .eclair

echo '
# Bitcoin daemon related configuration
eclair.chain=regtest
eclair.bitcoind.rpcport=18443
eclair.bitcoind.rpcuser=bobby
eclair.bitcoind.rpcpassword=bricodeur
eclair.bitcoind.zmqblock="tcp://127.0.0.1:28332"
eclair.bitcoind.zmqtx="tcp://127.0.0.1:28333"

# Eclair node configuration
eclair.node-color=69c538
eclair.api.enabled=true
eclair.api.password="bricodeur"
' > ~/.eclair/eclair.conf
# Create Aliases
echo 'alias eclair-node="eclair-node.sh";
' >> ~/.bashrc
source .bashrc
echo -e " > Eclair Lightning node installed and available at $B eclair-node$N and $B eclair-cli$N"
rm eclair-node-$eclairVersion-$eclairTag-bin.zip
rm -rf eclair-node-$eclairVersion-$eclairTag

## Install lnd 
go get -u github.com/golang/dep/cmd/dep
go get -d github.com/lightningnetwork/lnd
cd $GOPATH/src/github.com/lightningnetwork/lnd
make && make install
make check
mkdir -p ~/.lnd/
echo '''
[Bitcoin]

bitcoin.active=1
bitcoin.regtest=1
bitcoin.node=bitcoind

[Bitcoind]

bitcoind.rpchost=localhost
bitcoind.rpcuser=bobby
bitcoind.rpcpass=bricodeur
bitcoind.zmqpubrawblock=tcp://127.0.0.1:28332
bitcoind.zmqpubrawtx=tcp://127.0.0.1:28333
''' > ~/.lnd/lnd.conf
echo -e "> lnd Lightning node installed"
echo -e "   Launch in different terminals$B bitcoind$N ,$B lnd$N, and$B lndcli (create|getinfo|connect...)$N"
echo -e "   Options are preconfigured in ~/.lnd equivalent to lnd --bitcoin.active --bitcoin.testnet --debuglevel=debug --bitcoin.node=bitcoind --bitcoind.rpcuser=bobby --bitcoind.rpcpass=bricodeur --bitcoind.zmqpubrawblock=tcp://127.0.0.1:28332 --bitcoind.zmqpubrawtx=tcp://127.0.0.1:28333"


## Create two nodes for testing, Lena and Naori
cd  ~/.lnd/
# Create Lena node
mkdir -p nodeLena/
echo '''
; Lena Node
[Application Options]
listen=0.0.0.0:9731
rpclisten=localhost:10011
restlisten=0.0.0.0:8081
''' > nodeLena/lnd.conf
cat ~/.lnd/lnd.conf >> nodeLena/lnd.conf
# Create Naori
mkdir -p nodeNaori/
cat ~/.lnd/lnd.conf >> nodeNaori/lnd.conf
echo '''
; Naori Node
[Application Options]
listen=0.0.0.0:9732
rpclisten=localhost:10012
restlisten=0.0.0.0:8082
''' > nodeNaori/lnd.conf
cat ~/.lnd/lnd.conf >> nodeNaori/lnd.conf
# Create Aliases
echo 'export LenaDir="$HOME/.lnd/nodeLena";
export NaoriDir="$HOME/.lnd/nodeNaori";
alias lnd-Lena="lnd --lnddir=$LenaDir";
alias lncli-Lena="lncli -n regtest --lnddir=$LenaDir --rpcserver=localhost:10011";
alias lnd-Naori="lnd --lnddir=$NaoriDir";
alias lncli-Naori="lncli -n regtest --lnddir=$NaoriDir --rpcserver=localhost:10012";
' >> ~/.bashrc
source ~/.bashrc
echo -e "> Tutorial installed"
echo -e "   Two nodes$B Lena$N and$B Naori$N (lnd-Lena, lncli-Lena, lnd-Naori and lncli-Naori)have been preconfigured"
echo -e "   check .lnd/ folder and this tutorial https://github.com/lightningnetwork/lnd/tree/master/docker"
# TODO add better configuration and walktrough
