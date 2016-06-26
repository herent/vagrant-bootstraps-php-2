#!/usr/bin/env bash

# Installs and configures nodejs. This file should only be run inside of boostrap.sh where it's 
# sourced. If being called from other places, it will need to be by sourcing within a shell that
# has loaded the config.yml variables properly

# install node v5x
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
sudo apt-get install -y nodejs

# instructions from the ruby install
#sudo add-apt-repository ppa:chris-lea/node.js
#sudo apt-get update
#sudo apt-get install nodejs