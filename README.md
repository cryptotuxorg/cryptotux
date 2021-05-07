# Cryptotux

Cryptotux is a Linux image preconfigured with tools for cryptoassets, blockchains and Distributed Ledger Technologies. It has been conceived to be an educational tool and a development environment.

Cryptotux is currently supplied as .ova images that can be directly imported into Virtualbox (6.X+) and VMWare. This allows to jump-start workshops directly to code or to test new nodes in an isolated manner. It can also be directly installed on a server or on Windows Subsystem for Linux. 

Username is *bobby*, password is *bricodeur*.

![screenshot](screenshot.png)

## Install the easy visual way with VirtualBox
* Download the latest *desktop* or *server* image on the [release page](https://github.com/cryptotuxorg/cryptotux/releases)
* Install [VirtualBox](https://virtualbox.org) (activate VT-x/AMD-V in the BIOS if needed)
* Click on "↶ import appliance" in VirtualBox and select the file
* Press "Start ➡️" in VirtualBox 

For the desktop version, keyboard layout and screen resolution can be changed with the icons at the bottom-right corner. Left-click the flag to go through default options. Right-click and "keyboard layout handler" to add more options.

![keyboard](doc/images/keyboard.png)

## Usage and connection
You can now interact with the virtual machine : 
* Directly via VirtualBox using the desktop or server environment. 
* Connect via SSH typing `ssh bobby@192.168.33.10` in a terminal. For further options, see [SSH configuration](doc/ssh-configuration.md).
* Open a browser at http://192.168.33.10:3310/.

## Install on top of an existing configuration
You can install Cryptotux on top of an existing Ubuntu local install, Windows Subsystem for Linux or on a server by typing:
```bash
wget -qO - https://raw.githubusercontent.com/cryptotuxorg/cryptotux/master/install-server.sh | bash
```
It has been tested on Ubuntu 20.04. Don't do this on a production machine. For details on Windows Subsystem for Linux, see [install on WSL](doc/install-on-Windows-WSL.md).

## Development
Cryptotux is build with Packer, Ansible and Vagrant. To build the image and to contribute, see [contribute](contribute.md)

## Authors

Xavier Lavayssière ([:octocat:](https://github.com/Xalava) [🐦](https://twitter.com/XavierLava))

Alexandre Kurth ([:octocat:](https://github.com/kurthalex) [🐦](https://twitter.com/kurthalex))