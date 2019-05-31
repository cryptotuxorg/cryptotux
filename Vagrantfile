# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/bionic64"
  config.vm.hostname = "cryptotux"

  # # Port forwarding option
  # # Default Ethereum ports
  # config.vm.network "forwarded_port", guest: 30303, host: 30303
  # config.vm.network "forwarded_port", guest: 8545, host: 8545

  # # Regtest Bitcoin ports
  # config.vm.network "forwarded_port", guest: 18443, host: 18443

  # # Common IPFS ports 
  # config.vm.network "forwarded_port", guest: 4001, host: 4001
  # config.vm.network "forwarded_port", guest: 4002, host: 4002
  # config.vm.network "forwarded_port", guest: 5001, host: 5001
  # config.vm.network "forwarded_port", guest: 8080, host: 8080
  # config.vm.network "forwarded_port", guest: 8081, host: 8081

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false
 
  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "./dataShare", "/dataShare/", create: true
  
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    # vb.gui = true
    
    # Customize the amount of memory on the VM:
    # vb.memory = "1024"
    vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional', '--bioslogodisplaytime', 0] 
  end
  
  # Install basic configuration
  # Creates bobby user and launch install-server.sh as bobby
  config.vm.provision :shell, :path => "install-base.sh" 
  
  # Cryptotux server 
  config.vm.define "cryptotux-server", primary: true do |server|
    # The image will be available locally at this address
    # You can access web servers and API by typing it with the right port
    server.vm.network "private_network", ip: "192.168.33.10"
    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    # config.vm.network "public_network"
  end

  config.vm.define "cryptotux-desktop", autostart: false do |desktop|
    # The desktop version is accessible from the host at the following IP address
    desktop.vm.network "private_network", ip: "192.168.33.11"
    desktop.vm.provision "shell", inline: <<-SHELL
      su -c "source /vagrant/install-desktop.sh" bobby
    SHELL
  end
  config.ssh.keys_only = false

  if ARGV[0] == "ssh"
    config.ssh.username = 'bobby'
    config.ssh.password = 'bricodeur'
  end
end
