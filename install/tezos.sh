#!/bin/bash

### Tezos ###
# Assumes base docker install from the main script

tezosHome="$HOME/Projects/tezos"
mkdir -p $tezosHome
cd $tezosHome
wget -O carthagenet.sh https://gitlab.com/tezos/tezos/raw/latest-release/scripts/tezos-docker-manager.sh
chmod +x carthagenet.sh
tezosAlias="alias tezos=$tezosHome/carthagenet.sh"
$tezosAlias
echo $tezosAlias >> ~/.bashrc
$tezosHome/carthagenet.sh start
cd
echo -e '\033[1mNode is launched and syncing to Tezos testnet \e[92mCarthagenet\e[39m \033[0m'
echo "Next steps:"
echo "- Claim some testnest tezzies on https://faucet.tzalpha.net/"
echo -e "-$C tezos client$N to connect to the node (tezos-client in the documentation)"
echo -e "-$C tezos node stop$N to stop the node"