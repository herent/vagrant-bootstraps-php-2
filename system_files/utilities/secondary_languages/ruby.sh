#!/usr/bin/env bash

# Installs and configures ruby. This file should only be run inside of boostrap.sh where it's 
# sourced. If being called from other places, it will need to be by sourcing within a shell that
# has loaded the config.yml variables properly

# https://gist.githubusercontent.com/blacktm/8302741/raw/a5140c3b0eb95bf46a44f5f1a30a50416061c4fb/install_ruby_rpi.sh

# Think this is where I got the final one that worked
# http://stackoverflow.com/questions/29132891/vagrant-virtualbox-vm-provisioning-rbenv-installs-successfully-but-subsequent-u

# -----------------------------------------------------------------------
# Installs Ruby 2.2 using rbenv/ruby-build on the Raspberry Pi (Raspbian)
#
# Run from the web:
#   bash <(curl -s raw_script_url_here)
# -----------------------------------------------------------------------

# Might want to have a flag that asks the user if they actually want to re-install

#if [ ! -d /home/vagrant/.rbenv ]
#    then
#    git clone git://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv
#    else 
    # sudo rm -Rf /home/vagrant/.rbenv
    # sudo rm -Rf /root/.rbenv
#fi
whoami
PATH=$(echo "$PATH" | awk -v RS=':' -v ORS=":" '!a[$1]++{if (NR > 1) printf ORS; printf $a[$1]}')
echo "******************* CLEARED PATH"
echo $PATH
if [ ! -d /home/vagrant/.rbenv ]
    then
# Check out rbenv into /home/vagrant/.rbenv
    git clone https://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv
fi
#chmod 777 -Rf /home/vagrant/.rbenv
# Add /home/vagrant/.rbenv/bin to $PATH, enable shims and autocompletion
read -d '' String <<"EOF"
# rbenv
export PATH="/home/vagrant/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
EOF
# # For new shells
echo -e "\n${String}\n" >> /home/vagrant/.bashrc

# For current shell
eval "${String}"
# echo "---"
echo "${String}"
echo "${PATH}"
# echo "---"
# #exit

if [ ! -d /home/vagrant/.rbenv/plugins/ruby-build ]
    then
    git clone https://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build
fi

#chmod 777 -Rf /home/vagrant/.rbenv
# echo "About to change to the build directory"
cd /home/vagrant/.rbenv/plugins/ruby-build
# pwd
# whoami
# #sudo su - vagrant
echo "Hitting install"
sudo ./install.sh
echo 'export PATH="/home/vagrant/.rbenv/plugins/ruby-build/bin:$PATH"' >> /home/vagrant/.bashrc
echo 'export PATH="/home/vagrant/.rbenv/plugins/ruby-build/bin:$PATH"'
#echo $SHELL
# #echo "------------EXEC SHELL"
#exec $SHELL
# #echo "------------PAST SHELL"

git clone https://github.com/sstephenson/rbenv-gem-rehash.git /home/vagrant/.rbenv/plugins/rbenv-gem-rehash
# echo "------------PAST Rehash clone"
# # Install Ruby 2.2.3, don't generate RDoc to save lots of time
# echo "I AM ::::: " 
# whoami
# echo "CWD ::::: " 
# pwd

# echo "------------Install 2.2.3"
CONFIGURE_OPTS="--disable-install-doc --enable-shared" /home/vagrant/.rbenv/bin/rbenv install 2.2.3 --verbose
# echo "------------Past Install"

# # Set Ruby 2.2.3 as the global default
echo "+++++++=====Setting Global"
sudo /home/vagrant/.rbenv/bin/rbenv global 2.2.3
echo "+++++++=====Past Set Global"
# fi ## End check for .rbenv

# Don't install docs for gems (saves lots of time)
echo -e "gem: --no-document --no-ri --no-rdoc" > /home/vagrant/.gemrc
sudo gem install bundler
echo "+++++++=====Past Bundler"
# reload the ruby environment
sudo /home/vagrant/.rbenv/bin/rbenv rehash
echo "+++++++=====Past Rehash"
#sudo chmod 777 -Rf /home/vagrant/.rbenv
echo "+++++++=====Installing Ruby-Dev"
sudo apt-get install -y ruby-dev
echo "+++++++=====Past Ruby Dev"