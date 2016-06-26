#!/usr/bin/env bash

# Installs and configures nodejs. This file should only be run inside of boostrap.sh where it's 
# sourced. If being called from other places, it will need to be by sourcing within a shell that
# has loaded the config.yml variables properly

if [ "${config_optional_items_less}" = "true" ]
    then
    sudo npm install -g less

    if [ "${config_optional_items_less_bootstrap}" = "true" ]
        then
        sudo npm install -s bootstrap
        #sudo gem install less-rails-bootstrap
    fi
fi