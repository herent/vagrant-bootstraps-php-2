# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

# Load config file
config_vars = YAML::load_file(File.join(__dir__, '/system_files/config.yml'))
host_project_path = "./" + config_vars['project']['folder'] + "/"
vm_project_path = "/var/www/html/" + config_vars['project']['folder'] + "/"

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty64"

  # A little extra for virtualbox users
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--ioapic", "on"]
    v.name = config_vars['project']['name']
  end

  # Create a private network, which allows host-only access to the machine using a specific IP.
  # Add this IP to your hosts file with whatever domain name you'd like to use to access the machine
  #config.vm.network "private_network", ip: config_vars['network']['ip_address']
  config.vm.network "public_network", ip: config_vars['network']['ip_address'], bridge:[
    "en0: Wi-Fi (AirPort)", 
    "en1: Thunderbolt 1", 
    "en2: Thunderbolt 2"
  ]
  config.vm.network "forwarded_port", guest: 80, host: 80
  # Share an additional folder to the guest VM. The first argument is the path on the host to the actual folder.
  # The second argument is the path on the guest to mount the folder.
  config.vm.synced_folder "./system_files", "/home/vagrant/system_files", create: true
  config.vm.synced_folder host_project_path, vm_project_path, create: true  
  config.vm.synced_folder "./databases", "/home/vagrant/databases", create: true

  # Define the bootstrap file: A (shell) script that runs after first setup of your box (= provisioning)
  config.vm.provision :shell, privileged: false, path: "./system_files/bootstrap.sh"

end
