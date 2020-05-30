#!/bin/bash

mkdir ~/Projects/
cd ~/Projects/
git clone https://github.com/libra/libra.git 
cd libra
git checkout testnet
yes | ./scripts/dev_setup.sh
./scripts/cli/start_cli_testnet.sh
libraAlias="alias libra=~/Projects/libra//scripts/cli/start_cli_testnet.sh"
$libraAlias
echo $libraAlias >> ~/.bashrc
echo -e '\033[1mLibra installed\033[0m'
libra
