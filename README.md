# Cryptotux

Cryptotux is a Linux image preconfigured with tools for crypto development and education.

Cryptotux is currently supplied as .ova images that can be directly imported into Virtualbox (6.X+) and VMWare. It is particularly suited for workshops. It can also be installed directly on a server or Windows Subsystem for Linux.

Username is *bobby*, password is *bricodeur*.

![screenshot](screenshot.png)

## Install the easy visual way with VirtualBox
* Install [virtualbox](https://virtualbox.org) (and activate VT-x/AMD-V in the BIOS if needed)
* Download the latest *desktop* image on the [release page](https://github.com/cryptotuxorg/cryptotux/releases)
* Click on the file or in "↶ import appliance" in virtualbox
* Press "Start ➡️" on virtualbox 

Keyboard layout, and screen resolution, can be changed by clicking on the icons at the bottom. Left click the flag to go through default options: US, FR, ES, US Mac. Right click and then "keyboard layout handler" to add more options.

![keyboard](doc/images/keyboard.png)

### Server launch and connection
The server version is designed to allow you to launch nodes and tools in a contained environment while developping from your regular desktop. As above, [download](https://github.com/cryptotuxorg/cryptotux/releases) the latest "desktop" or "server" image. You can then connect with two methods:
* Open a terminal and type `ssh bobby@192.168.33.10` (password is bricodeur)
* Open a browser at http://192.168.33.10:3310/ 

For further options, see [ssh configuration](doc/ssh-configuration.md)

To build the image from scratch or contribute, see [contribute](contribute.md)

### Install on top of an existing configuration
You can install Cryptotux on top of an existing Ubuntu local install, Windows Subsystem for Linux or on a server by typing:
```bash
bash <(curl -sL https://cryptotux.org/install)
```
It has been tested on Ubuntu 20.04. You might have to install curl with `sudo apt install curl`. It should work on most Ubuntu based distribution and it can work on Debian 10 with minor changes (docker repository and adding current user to /etc/sudoers). Don't do this on a production machine.

For details on installing on Windows Subsystem for Linux, see [install on WSL](doc/install-on-Windows-WSL.md)


## Authors

Xavier Lavayssière ([:octocat:](https://github.com/Xalava) [🐦](https://twitter.com/XavierLava))

Alexandre Kurth ([:octocat:](https://github.com/kurthalex) [🐦](https://twitter.com/kurthalex))