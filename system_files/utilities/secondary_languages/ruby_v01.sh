#!/usr/bin/env bash

# Installs and configures ruby. This file should only be run inside of boostrap.sh where it's 
# sourced. If being called from other places, it will need to be by sourcing within a shell that
# has loaded the config.yml variables properly




# Instructions modified from here:
# https://gorails.com/setup/ubuntu/14.04
# The main difference is putting in the full path to the vagrant user's home folder because I don't
# know what user this is going to be running as during provisioning

# latest stable version of ruby

#if [ ! -d ~/.rbenv ]
#    then
#    git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
#    else 
    sudo rm -Rf ~/.rbenv
    git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
#fi

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL

git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL

cd ~/.rbenv/plugins/ruby-build
sudo ./install.sh

git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash

rbenv install 2.2.3
rbenv global 2.2.3
ruby -v

chown -Rf 777 ~/.rbenv

echo "gem: --no-ri --no-rdoc" > ~/.gemrc
gem install bundler
 
if [ "${config_optional_items_ruby_rails}" = "true" ]
    then
    gem install rails -v 4.2.4
fi

# reload the ruby environment
rbenv rehash