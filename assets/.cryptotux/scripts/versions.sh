#!/bin/bash -x
echo -e "\n>>> Software Versions <<<"

echo -e "\n System"
vv=$(lsb_release -d)
echo ${vv#"Description:"}
echo "Kernel" $(uname -r)
echo "Cryptotux $CRYPTOTUX_VERSION"
echo -e "\n Languages"
# python -V # deprecated
gcc --version | head -n 1 
python3 -V
go version
rustc --version 
echo "node" $(node --version)
echo "npm" $(npm --version)

echo -e "\n Tooling"
docker --version
echo "geth" $(geth version | sed -n 2p)
bitcoind --version | head -n 1
# Optionnal installs
[ -x "$(command -v tendermint)" ] && tendermint version

echo -e "\n>>> done <<<\n"