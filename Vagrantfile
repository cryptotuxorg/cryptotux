# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu/bionic64"
  config.vm.hostname = "cryptotux"

  # #Default Ethereum ports
  # config.vm.network "forwarded_port", guest: 30303, host: 30303
  # config.vm.network "forwarded_port", guest: 8545, host: 8545

  # #Regtest Bitcoin ports
  # config.vm.network "forwarded_port", guest: 18443, host: 18443

  # #Common IPFS ports (hell!)
  # config.vm.network "forwarded_port", guest: 4001, host: 4001
  # config.vm.network "forwarded_port", guest: 4002, host: 4002
  # config.vm.network "forwarded_port", guest: 5001, host: 5001
  # config.vm.network "forwarded_port", guest: 8080, host: 8080
  # config.vm.network "forwarded_port", guest: 8081, host: 8081

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  
  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"
  
  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  
  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.
  
  config.vm.provision :shell, :path => "install-base.sh" 

  config.vm.define "cryptotux-server", primary: true do |server|
    server.vm.network "private_network", ip: "192.168.33.10"
  end

  config.vm.define "cryptotux-desktop", autostart: false do |desktop|
    desktop.vm.network "private_network", ip: "192.168.33.11"
    desktop.vm.provision "shell", inline: <<-SHELL
      su -c "source /vagrant/install-desktop.sh" bobby
    SHELL
  end

  if ARGV[0] == "ssh"
    config.ssh.username = 'bobby'
  end
end
