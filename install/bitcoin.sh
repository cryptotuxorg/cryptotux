#!/bin/bash

### Bitcoin ###

if [ "$1" = "base" ] || [ "$1" = "full" ]; then
    ## Base installation, called from the main script

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
    sudo mv bitcoin128.png /usr/share/pixmaps/
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

    # Copay (I haven't found an alternative install)
    sudo snap install bitpay

    # Vanitygen 
    sudo snap install vanitygen

    # Vanitygen plus (seems better, but requires work to get it right)
    # mkdir -p ~/Projects
    # cd ~/Projects
    # wget https://github.com/exploitagency/vanitygen-plus/releases/download/PLUS1.53/linux-binary.tar.gz
    # rm linux-binary.tar.gz
    # mv linux-binary vanitygen
    
    if [ "$1" = "base" ]; then
        # Return to main script if only base was invoked
        return 1 
    fi
fi

## Install Bitcoin source code
mkdir -p ~/Projects/
git clone https://github.com/bitcoin/bitcoin ~/Projects/bitcoin
echo -e "Bitcoin source code available at $B ~/Projects/bitcoin$N"

## Electrum wallet
# TODO : automated release version
electrumVersion=4.0.7
sudo apt-get install -y --no-install-recommends python3-pyqt5 python3-setuptools python3-pip
wget -q https://download.electrum.org/$electrumVersion/Electrum-$electrumVersion.tar.gz
# Signature verification
gpg --keyserver keys.gnupg.net --recv-keys 6694D8DE7BE8EE5631BED9502BD5824B7F9470E6
wget -q https://download.electrum.org/$electrumVersion/Electrum-$electrumVersion.tar.gz.asc
gpg --status-fd 1 --verify Electrum-$electrumVersion.tar.gz.asc Electrum-$electrumVersion.tar.gz 2>/dev/null | grep -q 'GOODSIG' || echo -e "$B Error in Electrum signature$N"
# Install
python3 -m pip install --user Electrum-$electrumVersion.tar.gz
# alternate 
# wget https://download.electrum.org/$electrumVersion/electrum-$electrumVersion-x86_64.AppImage -O ~/.local/bin/electrum
# chmod +x ~/.local/bin/electrum
echo "export PATH=$PATH:$HOME/.local/bin" >> ~/.bashrc
source ~/.bashrc
rm Electrum-$electrumVersion*
echo -e "\nElectrum added, available via$C electrum$N and graphically"

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

echo -e "\nNodes$B Alice$N and$B Bob$N have been preconfigured, using respectively ports 8331 and 8332"
echo -e "  You can launch node Alice using$C bitcoind-Alice$N and connect with$C bitcoin-cli-Alice$N (connecting via 8321)"
echo -e "  similarly with Bob. Add \`-daemon\` to regain control of the console"
echo -e "  Both should connect with the node$B Tux$N launched with$C bitcoind$N "