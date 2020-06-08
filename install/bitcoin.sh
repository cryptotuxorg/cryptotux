#!/bin/bash -x

### Bitcoin ###
# Assumes node with regtest configuration from main script

B="\033[1m"
N="\033[0m"

## Install Bitcoin source code
mkdir -p ~/Projects/
git clone https://github.com/bitcoin/bitcoin ~/Projects/Bitcoin
echo -e "Bitcoin source code available at $B ~/Projects/Bitcoin$N"

## Electrum wallet
# TODO : automated release version
electrumVersion=3.3.8
sudo apt-get install -y --no-install-recommends python3-pyqt5 python3-setuptools python3-pip
wget -q https://download.electrum.org/$electrumVersion/Electrum-$electrumVersion.tar.gz
# Signature verification
gpg --keyserver keys.gnupg.net --recv-keys 6694D8DE7BE8EE5631BED9502BD5824B7F9470E6
wget -q https://download.electrum.org/$electrumVersion/Electrum-$electrumVersion.tar.gz.asc
gpg --status-fd 1 --verify Electrum-$electrumVersion.tar.gz.asc Electrum-$electrumVersion.tar.gz 2>/dev/null | grep -q 'GOODSIG' || echo -e "$B Error in Electrum signature$N"
# Install
python3 -m pip install --user Electrum-$electrumVersion.tar.gz
echo "export PATH=$PATH:$HOME/.local/bin" >> ~/.bashrc
source ~/.bashrc
rm Electrum-$electrumVersion*
echo -e ">  Electrum added, available via $B electrum$N and graphically"

## Bitcoin local network tutorial
cd  ~/.bitcoin/
# Create Alice node
mkdir -p nodeAlice/
cp ~/.bitcoin/bitcoin.conf nodeAlice/bitcoin.conf
echo '
[regtest]
bind=127.0.0.1
port=18441
rpcbind=127.0.0.1
rpcport=18401

connect=127.0.0.1:18442
connect=127.0.0.1:18444

' >> nodeAlice/bitcoin.conf
sed -i 's/uacomment.*/uacomment=Alice/g' nodeAlice/bitcoin.conf

# Create Bob node
mkdir -p nodeBob/
cp ~/.bitcoin/bitcoin.conf nodeBob/bitcoin.conf
echo '
[regtest]
bind=127.0.0.1
port=18442
rpcbind=127.0.0.1
rpcport=18402

connect=127.0.0.1:18441
connect=127.0.0.1:18444
' >> nodeBob/bitcoin.conf
sed -i 's/uacomment.*/uacomment=Bob/g' nodeBob/bitcoin.conf

# Configure aliases
echo '
export AliceDir="$HOME/.bitcoin/nodeAlice";
export BobDir="$HOME/.bitcoin/nodeBob";
alias bitcoind-Alice="bitcoind -datadir=$AliceDir";
alias bitcoin-cli-Alice="bitcoin-cli -datadir=$BobDir";
alias bitcoind-Bob="bitcoind -datadir=$BobDir";
alias bitcoin-cli-Bob="bitcoin-cli -datadir=$BobDir";
' >> ~/.bashrc
source ~/.bashrc

echo -e "> Nodes$B Alice$N and$B Bob$N have been preconfigured, using respectively ports 8331 and 8332"
echo -e "  You can launch node Alice using $B bitcoind-Alice$N and connect with $B bitcoin-cli-Alice$N (connecting via 8321)"
echo -e "  similarly with Bob. Add \`-daemon\` to regain control of the console"
echo -e "  Both should with the original node \"Tux\" launched with $B bitcoind$N "