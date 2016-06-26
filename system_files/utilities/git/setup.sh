#!/usr/bin/env bash

#function pause(){
#   read -p "$*"
#}

# Installs and configures git. This file should only be run inside of boostrap.sh where it's 
# sourced. If being called from other places, it will need to be by sourcing within a shell that
# has loaded the config.yml variables properly

. /home/vagrant/system_files/utilities/parse_yaml.sh
eval $(parse_yaml /home/vagrant/system_files/config.yml "config_")

# install git
sudo apt-get -y install git git-core
# setup git user info
git config --global color.ui true
git config --global user.name "${config_git_user}"
git config --global user.email "${config_git_email}"

# Now to generate a key for github. It will be unique to this machine, and is only run on the
# first vagrant up. Delete the file /system_files/id_rsa_pub_for_github.txt to regenerate
if [ ! -f /home/vagrant/system_files/utilities/git/id_rsa_pub_for_github.txt ]
    then
    ssh-keygen -t rsa -N "" -f /home/vagrant/.ssh/id_rsa -C "${config_git_email}" -q
    cp /home/vagrant/.ssh/id_rsa.pub /home/vagrant/system_files/utilities/git/id_rsa_pub_for_github.txt
fi

# grab the repo for this vagrant box, but only if it hasn't been cloned yet 
# note - this might cause some issues if the repo is private and the rsa hasn't 
# been added yet. In that case, you can just set it to not auto checkout in the config 
# the first time the box is provisioned
if [ ! -d "/var/www/html/${config_project_folder}/.git" ] && [ "${config_git_auto_checkout}" = "true" ]
    then
    git clone --progress "${config_git_repo}" "/var/www/html/${config_project_folder}"
fi