# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 2.3.0"

# Environmental Variables:
ENV['HOSTNAME'] = "minislate-vm.test"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Check for vagrant-vbguest plugin:
  if !Vagrant.has_plugin?('vagrant-vbguest')
    puts 'ERROR: vagrant-vbguest plugin required.'
    puts 'To install run `vagrant plugin install vagrant-vbguest`'
    abort
  else
    # (Not ideal) Extra steps necessary for the Rocky 8.5 guest OS and vbguest installation
    #
    # See https://github.com/dotless-de/vagrant-vbguest/issues/423).
    config.vbguest.installer_options = {
      allow_kernel_upgrade: true,
      auto_reboot: true
    }
    config.vbguest.installer_hooks[:before_install] = [
      "dnf -y install bzip2 elfutils-libelf-devel gcc kernel kernel-devel kernel-headers libX11 libXext libXmu libXt make perl tar",
      "sleep 2"
    ]
  end

  # Configure the VirtualBox guest host:
  config.vm.define ENV['HOSTNAME'] do |node|

    # Specify the Vagrant Box, version, and update check:
    node.vm.box = "rockylinux/8"
    node.vm.box_version = "5.0.0"
    node.vm.box_check_update = "false"

    # Customize the hostname:
    node.vm.hostname = ENV['HOSTNAME']

#     # Customize the forwarded ports:
#     node.vm.network "forwarded_port", guest: "5050", host: "5050"

    # VirtualBox Provider
    node.vm.provider "virtualbox" do |vb|
      # Customize the number of CPUs on the VM:
      vb.cpus = 2

      # Customize the amount of memory on the VM:
      vb.memory = 4096

      # Customize the name that appears in the VirtualBox GUI:
      vb.name = ENV['HOSTNAME']
    end

    # Run a script to provision the box:
    config.vm.provision "shell", inline: <<-SHELL
      setenforce 0
      yum install -y yum-utils
      yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
      yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      systemctl enable --now docker
      yum install -y python3
      alternatives --set python /usr/bin/python3
    SHELL

  end

end
