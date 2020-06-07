#!/bin/bash

echo export GO111MODULE=on >> ~/.bash_profile
mkdir -p $GOPATH/src/github.com/tendermint
cd $GOPATH/src/github.com/tendermint
git clone https://github.com/tendermint/tendermint.git
cd tendermint
make tools
make install
echo -e '\033[1mTendermint is ready to be used.\033[0m'
echo "Version : $(tendermint version)"

