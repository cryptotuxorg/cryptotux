# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/focal64"
  config.vm.hostname = "cryptotux"
  ## Resize image (https://askubuntu.com/questions/317338/how-can-i-increase-disk-size-on-a-vagrant-vm)
  unless Vagrant.has_plugin?("vagrant-disksize")
    raise  Vagrant::Errors::VagrantError.new, "Please install missing plugin: $ vagrant plugin install vagrant-disksize"
  end
  config.disksize.size = '40GB'

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
  # By default, current folder is shared with /vagrant
  # config.vm.synced_folder "./dataShare", "/dataShare/", create: true

  # Potential bugfix for ssh connection and speeds up building during development
  # https://github.com/hashicorp/vagrant/issues/9834
  # However activating it requires the password at vagrant ssh
  config.ssh.insert_key = false
  
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    # vb.gui = true
    
    # Customize the amount of memory on the VM:
    vb.memory = "2048" # Useful for large node operations or desktop
    vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional', '--bioslogodisplaytime', 0] 
    # Driver that might be more suited for resizing, but it seems less reliable
    # vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
    # Bugfix https://bugs.launchpad.net/cloud-images/+bug/1829625
    vb.customize ["modifyvm", :id, "--uartmode1", "file", File::NULL]
  end
  
  # Install basic configuration
  # Creates bobby user and launch install-server.sh as bobby
  config.vm.provision "shell",
    inline: "/bin/bash -eux /vagrant/install-config.sh"
  # config.vm.provision :shell, :path => "install-base.sh" 
  
  config.vm.network "private_network", ip: "192.168.33.10"
  
  # Cryptotux server 
  config.vm.define "default", primary: true do |server|
    # The image will be available locally at this address
    # You can access web servers and API by typing it with the right port
    # server.vm.network "private_network", ip: "192.168.33.10"
    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    # config.vm.network "public_network"
  end

  config.vm.define "desktop", autostart: false do |desktop|
    # The desktop version is accessible from the host at the following IP address
    # desktop.vm.network "private_network", ip: "192.168.33.11"
    desktop.vm.provision "shell", inline: <<-SHELL
      su -c "source /vagrant/install/desktop.sh" bobby
    SHELL
  end

  # Enable ssh forward agent
  config.ssh.forward_agent = true
  # Convenient, less secure, password based ssh connection
  # config.ssh.keys_only = false ## seems to be source of failure and not necessary
  if ARGV[0] == "ssh"
    config.ssh.username = 'bobby'
    config.ssh.password = 'bricodeur'
  end
end
