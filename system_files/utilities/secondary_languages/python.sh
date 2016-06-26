#!/usr/bin/env bash

# Installs and configures python. This file should only be run inside of boostrap.sh where it's 
# sourced. If being called from other places, it will need to be by sourcing within a shell that
# has loaded the config.yml variables properly

# python should already be installed, but whatever
sudo apt-get -y install python python-software-properties