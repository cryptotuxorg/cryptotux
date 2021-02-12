# Changelog
## 0.8.1 > 12 Feb 2021
- [Bitcoin] added copay
- [Ethereum] added hyperledger besu
- [Ethereum] removed openzeppelin cli
- [Internal] renaming base script
- [Internal] moved install logic to network scripts

## 0.8.0 > 21 Sept 2020
- [server] start_eth_project to create a base project in Ethereum
- [server] ethereum.sh script, to install lighthouse, Prysm and a more complete dev environment
- [server] Prettier welcome and install messages
- [server] corda.sh script 
- [server] added age, a crypto utility 
- [server] added nnn, a console file explorer

## 0.7.0 > 17 June 2020
#### Users
- [server] added bitcoin and lightning two node tutorial configuration
- [server] cosmos script
#### Internal
- cleaner `cryptotux`/`cx` command
- install folder with scripts
- Windows Subsystem for Linux install command and testing

## 0.6.2 > 7 June 2020
#### Users
- [server] yarn added
- [desktop] visual code extensions added
#### Internal
- install script can be launched by any user
- automatic GitHub release version when available
- explicit commands during build

## 0.6.1 > 30 May 2020
#### Users
- [server] Addition of micro, a command line text editor
- [server] Added web terminal 
- [desktop] Default mimetypes for convenience 
- [server] Welcome message with available commands
#### Internal
- install-server.sh can now be safely executed on a server independently of Vagrant
- Better script portability 
- Additional scripts to install lightning, tendermint, Libra and Tezos (carthagenet)
## 0.6.0 > 27 May 2020
#### Users
- Extended to 40GB max sized harddrive. Allows testnets launch
- new command `cryptotux-versions` to display installed versions of key softwares
- Updated syntax for `cryptotux-update` and `cryptotux-clean`
#### Internal
- Automated desktop version configuration
- Switched Bitcoin-core from PPA to direct download (recommended safest way)

## 0.5.4 > 5 apr 2020
- Version bumps

## 0.5.3 > 16 jan 2020
- purge apport
- added lxrandr
- added IBM visual code plugin
- Bookmarks:
	- added bitcoin whitepaper, bitcoin studio
	- removed ethfiddle
- larger hard drive max size (7 to 20GB)

## 0.5.2 > 01 nov 2019
- Version bump: node, go
- added jq

## 0.5.1 > 08 oct 2019
- Tiny updates I'm too lazy to describe

## 0.5.0 > 31 may 2019
- Fully scripted desktop 
- including java, sublime-text, artwork
- Smaller images
- added ssh password access 

## 0.4.6 > 9 may 2019
- added brave browser
- removed secondary npm packages
- lighter image

## 0.4.5 > 14 apr 2019
- added emacs
- updated go
- cosmos sdk

## 0.4.4 > 10 apr 2019
- docker tooling
- added rust & vim
- better update script 

## 0.4.3 > 9 apr 2019
- Visual code added
- updates

## 0.4.2 > 8 apr 2019
- fortune, tldr added

## 0.4.1 > 22 jan 2019
- bitcoin binaries & config
- tutorials

## 0.3 > 22 dec 2018
- Added bleachit
- Custom update scripts
- bookmarks

## 0.2
- Added parity
- Branding
- upload optimization

## 0.1.0
- Ligher image and OS
- added IPFS

## 0.0.4 > 27-Sep-2018
- Installed
	- Ganache-cli
	- Chainpoint-cli   
- Significantly lighter image

## 0.0.3 > 25-Sep-2018
- Solidity addon for Visual Code
- curl
- metamask for firefox
- node with user domain global folder (.npm-global)

## 0.0.2 > 13-Jun-2018 
- Ethereum ppa and libraries
- libssl1.0-dev

## 0.0.1 > Jun-2018
- Utilities
	build-essential libtool autotools-dev automake pkg-config libssl1.0-dev libevent-dev bsdmainutils python3 software-properties-common
	libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
	libminiupnpc-dev libzmq3-dev
	libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler  
- Bitcoin libraries
	libdb4.8-dev libdb4.8++-dev
- Virtualbox addons