#!/usr/bin/env bash

# Installs and configures nodejs. This file should only be run inside of boostrap.sh where it's 
# sourced. If being called from other places, it will need to be by sourcing within a shell that
# has loaded the config.yml variables properly

# Source tutorials on how to install:
# https://github.com/sass/sassc/blob/master/docs/building/unix-instructions.md
# https://github.com/sass/libsass/blob/master/docs/setup-environment.md
# http://www.werstnet.com/blog/speeding-up-sass/
# http://crocodillon.com/blog/how-to-install-sassc-and-libsass-on-ubuntu
echo "In sass.sh"
cd /usr/local/lib/
pwd
sudo git clone https://github.com/sass/libsass.git --branch 3.3.2 --depth 1
cd ./libsass
#sudo echo "SASS_LIBSASS_PATH=${pwd}" >> /etc/environment
# Flush the changes…
source /etc/environment
# get the dependencies needed
echo "bootstrap libsass"
sudo ./script/bootstrap
# and now to build it
echo "make libsass"
sudo make
# library is made, now it's time to install the actual executable
echo "make sassc"
cd ./sassc
sudo make install

# And make sure that it's in the bin folder for easy execution
# #### I don't think that we need this, the link is created during install
#echo "link sassc"
#cd /usr/local/bin/
#sudo ln -s ../lib/sassc/bin/sassc ./sassc

# Now install any frameworks that we need
# Bourbon 
echo "Bourbon Options"
if [ "${config_optional_items_sass_bourbon}" = "true" ]
    then
    echo "install bourbon"
    sudo gem install bourbon

    if [ "${config_optional_items_sass_bourbon_neat}" = "true" ]
        then
        echo "install neat"
        sudo gem install neat
    fi

    if [ "${config_optional_items_sass_bourbon_bitters}" = "true" ]
        then
        echo "install bitters"
        sudo gem install bitters
    fi
fi

# Compass 
echo "Compass"
if [ "${config_optional_items_sass_compass}" = "true" ]
    then
    sudo gem install compass

    if [ "${config_optional_items_sass_compass_susy}" = "true" ]
        then
        echo "susy"
        sudo gem install susy
    fi
fi

# Bootstrap 
if [ "${config_optional_items_sass_bootstrap}" = "true" ]
    then
    echo "sass bootstrap"
    sudo gem install bootstrap-sass
    echo "grunt-cli"
    sudo npm install -g grunt-cli
    echo "grunt init"
    sudo npm install -g grunt-init
fi
