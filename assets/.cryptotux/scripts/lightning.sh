#!/bin/bash
mkdir -p ~/Projects/
cd ~/Projects/
git clone https://github.com/bitcoin/bitcoin.git Bitcoin

go get -u github.com/golang/dep/cmd/dep
go get -d github.com/lightningnetwork/lnd
cd $GOPATH/src/github.com/lightningnetwork/lnd
make && make install
make check
# TODO add better configuration and walktrough
echo -e '\033[1mBitcoin source and Lightning node installed\033[0m'
echo -e 'launch \033[1mbitcoind \033[0min one terminal and in another one'
echo -e '\033[1mlnd --bitcoin.active --bitcoin.testnet --debuglevel=debug --bitcoin.node=bitcoind --bitcoind.rpcuser=bobby --bitcoind.rpcpass=bricodeur --bitcoind.zmqpubrawblock=tcp://127.0.0.1:28332 --bitcoind.zmqpubrawtx=tcp://127.0.0.1:28333\033[0m'