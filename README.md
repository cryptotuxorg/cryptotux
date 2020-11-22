# Cryptotux

Cryptotux is a Linux image preconfigured with tools for cryptoassets, blockchains and Distributed Ledger Technologies (DLT). It has been conceived to be an educational tool primarely and as a development environment.

Cryptotux is currently supplied as .ova images that can be directly imported into Virtualbox (6.X+) and VMWare. This allows to jumpstart workshops direclty to code or to test new nodes in an isolated manner. It can also be directly installed on a server or on Windows Subsystem for Linux.

Username is *bobby*, password is *bricodeur*.

![screenshot](screenshot.png)

## Install the easy visual way with VirtualBox
* Install [VirtualBox](https://virtualbox.org) (and activate VT-x/AMD-V in the BIOS if needed)
* Download the latest *desktop* image on the [release page](https://github.com/cryptotuxorg/cryptotux/releases)
* Click on the file or in "↶ import appliance" in VirtualBox
* Press "Start ➡️" on VirtualBox 

Keyboard layout, and screen resolution, can be changed by clicking on the icons at the bottom. Left-click the flag to go through default options: US, FR, ES, US Mac. Right-click and then "keyboard layout handler" to add more options.

![keyboard](doc/images/keyboard.png)

## Server launch and connection
The server version is designed to allow you to launch nodes and tools in a contained environment while developing from your regular desktop. As above, [download](https://github.com/cryptotuxorg/cryptotux/releases) the latest "desktop" or "server" image. You can then connect with the following methods:
* Open a terminal and type `ssh bobby@192.168.33.10` (password is bricodeur). You will benefit from your terminal application
* Open a browser at http://192.168.33.10:3310/ 
* Interact via VirtualBox

For further options, see [ssh configuration](doc/ssh-configuration.md)

To build the image from scratch or contribute, see [contribute](contribute.md)

## Install on top of an existing configuration
You can install Cryptotux on top of an existing Ubuntu local install, Windows Subsystem for Linux or on a server by typing:
```bash
bash <(curl -sL https://cryptotux.org/install)
```
It has been tested on Ubuntu 20.04. You might have to install curl with `sudo apt install curl`. It should work on most Ubuntu-based distributions and it can work on Debian 10 with minor changes (docker repository and adding current user to /etc/sudoers). Don't do this on a production machine.

For details on installing on Windows Subsystem for Linux, see [install on WSL](doc/install-on-Windows-WSL.md)


## Authors

Xavier Lavayssière ([:octocat:](https://github.com/Xalava) [🐦](https://twitter.com/XavierLava))

Alexandre Kurth ([:octocat:](https://github.com/kurthalex) [🐦](https://twitter.com/kurthalex))