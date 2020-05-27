# Cryptotux

Cryptotux is a Linux image preconfigured with tools for crypto development and education.

Cryptotux is currently supplied as .ova images that can be directly imported into Virtualbox (6.X+). 
It is particularly suited for workshops. Username is *bobby*, password is *bricodeur*.

Download -> http://cryptotux.org/

![screenshot](screenshot.png)

## How to use it? 

### The easy visual way
* Install [virtualbox](https://virtualbox.org)
* Download the latest "desktop ova image" on [cryptotux.org](https://cryptotux.org)
* Click on the file or in "import appliance" in virtualbox
* Press "Start ➡️" on virtualbox 

Keyboard layout can be changed by clicking on the icon at the bottom. Left click to go through default options: US, FR, ES, US Mac. Right click and then "keyboard layout handler" to add more options.

![keyboard](images/keyboard.png)

### The server launch
To launch only nodes or tooling you can use the server version.
* Install [virtualbox](https://virtualbox.org)
* Download the latest "server ova image" on [cryptotux.org](https://cryptotux.org)
* Click on the file or in "import appliance ↶" in virtualbox
* Connect via ssh `ssh bobby@192.168.33.10 -o IdentitiesOnly=yes` <!-- or have a preview by opening a browser at http://192.168.33.10:3030 -->

For ease you can also sync a local folder, let's call it 'remote', and the internal user folder of the machine with `sshfs -o IdentitiesOnly=yes bobby@192.168.33.10:/home/bobby ~/remote`

Optionnaly, you can add cryptotux as known hosts (on Unix systems `echo '192.168.33.10 cryptotux' | sudo tee -a /etc/hosts`, you will then be able to connect with `ssh bobby@cryptotux`) or the following lines to the ssh config file, usually located on Unix systems at `~/.ssh/config`:
```
Host cryptotux
   HostName 192.168.33.10
   User bobby
   IdentitiesOnly yes
```
## To build from scratch

* Install [vagrant](https://www.vagrantup.com/downloads.html) and virtualbox. 
* To build and run the server version `vagrant up`
* To connect to the server : `vagrant ssh`

And voilà !

* To build and run the desktop version `vagrant up desktop` 
* Or run the command `cryptotux-desktop` within the default virtual machine, and reboot `sudo reboot`
⚠️ desktop automated build is experimental

## Contribution
We aim to provide a useful tool and meaningful project as a collaborative effort. The first objective is to offer a standard distribution for education and development. Suggestions, remarks, partnerships and pull requests are welcome. 

* [Suggested issues](https://github.com/cryptotuxorg/cryptotux/projects/1)
* [To fork](https://github.com/cryptotuxorg/cryptotux/fork)

There are two sets of installation scripts:

* install-*.sh are bash installation scripts. They can be applied to a local install or a vagrant box
* flavours/ contains Ansible playbooks and several flavours of cryptotux


## Authors

Xavier Lavayssière (@xavierlava)

