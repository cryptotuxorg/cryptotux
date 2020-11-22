# Contribute
We aim to provide a useful tool and meaningful project as a collaborative effort. The first objective is to offer a standard distribution for education and development. Suggestions, remarks, partnerships and pull requests are welcome. 

* [Suggested issues](https://github.com/cryptotuxorg/cryptotux/projects/1)
* [To fork](https://github.com/cryptotuxorg/cryptotux/fork)

There are two sets of installation scripts:

* install*.sh are bash installation scripts. They can be applied to a local install, a server, WSL or a vagrant box
   - install-base.sh configures a Vagrant box or a server to add a regular user
   - **install-server.sh** is the key script installing basic development tools, common configuration and a Bitcoin node
   - install/ contains scripts that will be applicable once launched, including the desktop
* flavours/ contains Ansible playbooks (in provisioning/) and several flavours of cryptotux

Provided ova images are built from the vagrantfile using bash scripts.

## To build images from scratch

* Install [vagrant](https://www.vagrantup.com/downloads.html) and virtualbox. 
* To build and run the server version `vagrant up`
* To connect to the server : `vagrant ssh`

And voilà !

To build and run the desktop version `vagrant up desktop` or run the command `cryptotux desktop` within the default virtual machine. This desktop build is meant for educational purposes.

For the ansible version, move to the desired flavour and type `vagrant up`. See [readme](flavours/README.md)

## Styling

Bash scripts follow approxamitavely some conventions suggested in this [guide](https://google.github.io/styleguide/shellguide.html)