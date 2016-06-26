#!/usr/bin/env bash

clear
PATH=$(echo "$PATH" | awk -v RS=':' -v ORS=":" '!a[$1]++{if (NR > 1) printf ORS; printf $a[$1]}')
echo $PATH

# prevents a lot of warnings during provisioning from showing up
# just here so that people don't get worried thinking something's broken
export DEBIAN_FRONTEND=noninteractive

# include utilities
. /home/vagrant/system_files/utilities/parse_yaml.sh
. /home/vagrant/system_files/utilities/create_database.sh


# read yaml file
eval $(parse_yaml /home/vagrant/system_files/config.yml "config_")

# create project folder, skip if it exists
sudo mkdir -p "/var/www/html/${config_project_folder}"
# then make sure it's readable on the host OS, since in osx, we have to run as root

sudo chmod -f 777 "/var/www/html/${config_project_folder}"

# Rather than trying to parse and update all the configs, 
# edit them in the outer git repo and copy from here
sudo mkdir -p "/home/vagrant/system_files"

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

sudo    apt-get install nfs-kernel-server
sudo    apt-get install nfs-common  

# Install git
/home/vagrant/system_files/utilities/git/setup.sh


# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password ${config_db_admin_password}"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${config_db_admin_password}"
sudo apt-get -y install mysql-server mysql-client libmysqlclient-dev

# install apache
sudo apt-get install -y apache2 

# php main items
# sudo apt-get install -y php5
# sudo apt-get install -y php5-cli
# sudo apt-get install -y php5-dev
# #sudo apt-get install -y php5-fpm
# sudo apt-get install -y php5-mysql
# sudo apt-get install -y php-pear

# # php optional items
# #sudo apt-get install -y php-apc
# #sudo apt-get install -y php5-cgi
# sudo apt-get install -y php5-curl
# sudo apt-get install -y php5-gd
# sudo apt-get install -y php5-intl
# #sudo apt-get install -y php5-imap
# sudo apt-get install -y php5-imagick
# sudo apt-get install -y php5-mcrypt
# #sudo apt-get install -y php5-memcache
# #sudo apt-get install -y php5-ming
# #sudo apt-get install -y php5-ps
# #sudo apt-get install -y php5-pspell
# #sudo apt-get install -y php5-recode
# #sudo apt-get install -y php5-snmp
# #sudo apt-get install -y php5-sqlite
# #sudo apt-get install -y php5-tidy
# #sudo apt-get install -y php5-xmlrpc
# #sudo apt-get install -y php5-xsl

# Everything in one command for speed. Comment out and then use the bits lower down if you need to configure differently. 
sudo apt-get install -y php5 php5-cli php5-dev php5-mysql php-pear php5-curl php5-gds php5-intl php5-imagick php5-mycrypt 

# apache modules
# see http://httpd.apache.org/docs/2.4/mod/
# note, these are simply the modules that are installed in the ubuntu 14.04.03 box

# #sudo a2enmod access_compat
# #sudo a2enmod actions
# #sudo a2enmod alias
# #sudo a2enmod allowmethods
# #sudo a2enmod asis
# #sudo a2enmod auth_basic
# #sudo a2enmod auth_digest
# #sudo a2enmod auth_form
# #sudo a2enmod authn_anon
# #sudo a2enmod authn_core
# #sudo a2enmod authn_dbd
# #sudo a2enmod authn_dbm
# #sudo a2enmod authn_file
# #sudo a2enmod authn_socache
# #sudo a2enmod authnz_ldap
# #sudo a2enmod authz_core
# #sudo a2enmod authz_dbd
# #sudo a2enmod authz_dbm
# #sudo a2enmod authz_groupfile
# #sudo a2enmod authz_host
# #sudo a2enmod authz_owner
# #sudo a2enmod authz_user
# sudo a2enmod autoindex
# #sudo a2enmod buffer
# #sudo a2enmod cache
# #sudo a2enmod cache_disk
# #sudo a2enmod cache_socache
# #sudo a2enmod cgi
# #sudo a2enmod cgid
# #sudo a2enmod charset_lite
# #sudo a2enmod data
# #sudo a2enmod dav
# #sudo a2enmod dav_fs
# #sudo a2enmod dav_lock
# #sudo a2enmod dbd
# #sudo a2enmod deflate
# #sudo a2enmod dialup
# #sudo a2enmod dir
# #sudo a2enmod dump_io
# # honestly, avoid this next one until echo escaping is figured out
# #sudo a2enmod echo
# #sudo a2enmod env
# #sudo a2enmod expires
# #sudo a2enmod ext_filter
# #sudo a2enmod file_cache
# #sudo a2enmod filter
# #sudo a2enmod headers
# #sudo a2enmod heartbeat
# #sudo a2enmod heartmonitor
# #sudo a2enmod include
# #sudo a2enmod info
# #sudo a2enmod lbmethod_bybusyness
# #sudo a2enmod lbmethod_byrequests
# #sudo a2enmod lbmethod_bytraffic
# #sudo a2enmod lbmethod_heartbeat
# #sudo a2enmod ldap
# #sudo a2enmod log_debug
# #sudo a2enmod log_forensic
# #sudo a2enmod lua
# #sudo a2enmod macro
# sudo a2enmod mime
# sudo a2enmod mime_magic
# #sudo a2enmod mpm_event
# #sudo a2enmod mpm_worker
# #sudo a2enmod negotiation
# sudo a2enmod php5
# #sudo a2enmod proxy
# #sudo a2enmod proxy_ajp
# #sudo a2enmod proxy_balancer
# #sudo a2enmod proxy_connect
# #sudo a2enmod proxy_express
# #sudo a2enmod proxy_fcgi
# #sudo a2enmod proxy_fdpass
# #sudo a2enmod proxy_ftp
# #sudo a2enmod proxy_html
# #sudo a2enmod proxy_http
# #sudo a2enmod proxy_scgi
# #sudo a2enmod proxy_wstunnel
# #sudo a2enmod ratelimit
# #sudo a2enmod reflector
# #sudo a2enmod remoteip
# #sudo a2enmod reqtimeout
# #sudo a2enmod request
# sudo a2enmod rewrite
# #sudo a2enmod sed
# #sudo a2enmod session
# #sudo a2enmod session_cookie
# #sudo a2enmod session_crypto
# #sudo a2enmod session_dbd
# #sudo a2enmod setenvif
# #sudo a2enmod slotmem_plain
# #sudo a2enmod slotmem_shm
# #sudo a2enmod socache_dbm
# #sudo a2enmod socache_memcache
# #sudo a2enmod socache_shmcb
# #sudo a2enmod speling
# sudo a2enmod ssl
# #sudo a2enmod status
# #sudo a2enmod substitute
# #sudo a2enmod suexec
# #sudo a2enmod unique_id
# #sudo a2enmod userdir
# #sudo a2enmod usertrack
# #sudo a2enmod vhost_alias
# #sudo a2enmod xml2enc


# Everything in one command for speed. Comment out and then use the bits lower down if you need to configure differently. 
sudo a2enmod autoindex mime mime_magic php5 rewrite ssl

# xdebug
sudo apt-get install php5-xdebug
XDEBUG_SETTINGS=$(cat <<EOF
[xdebug]
zend_extension = /usr/lib/php5/20121212/xdebug.so
xdebug.default_enable=1
xdebug.remote_autostart=0
xdebug.remote_connect_back=1
xdebug.remote_enable=1
xdebug.remote_handler=dbgp
xdebug.remote_port=9000
EOF
)
sudo echo "${XDEBUG_SETTINGS}" | sudo tee /etc/php5/mods-available/xdebug.ini
sudo ln -sf /etc/php5/mods-available/xdebug.ini /etc/php5/apache2/conf.d/20-xdebug.ini
sudo ln -sf /etc/php5/mods-available/xdebug.ini /etc/php5/cli/conf.d/20-xdebug.ini
# # install Composer
sudo curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

sudo cp -f /home/vagrant/system_files/apache2/envvars /etc/apache2/

# setup hosts file
if [ "${config_vhost_use_custom_hostfile}" = "true" ]
    then
    # We just want to copy the file from ~/system_files/apache/custom_hostfile.conf
    sudo cp -f /home/vagrant/system_files/apache2/custom_hostfile.conf /etc/apache2/sites-available/000-default.conf
else
# We are going to just build with default options
    if [ "${config_vhost_use_subfolder}" = "true" ] 
        then
            web_root="/var/www/html/${config_project_folder}/${config_vhost_subfolder_name}"
        else 
            web_root="/var/www/html/${config_project_folder}"
    fi
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "${web_root}"
    <Directory "${web_root}">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
sudo echo "${VHOST}" | sudo tee /etc/apache2/sites-available/000-default.conf
fi


# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
# this needs to be after apache and php are installed
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password ${config_db_admin_password}"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password ${config_db_admin_password}"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password ${config_db_admin_password}"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin

# check if we have a custom user to add
if [ "${config_db_create_project_user}" = "true" ]
    then
    user="${config_db_project_user_name}"
    pass="${config_db_project_user_pass}"
    if [ "${config_db_use_custom_database_name}" = "true" ]
        then 
        dbname="${config_db_custom_database_name}"
        else
        dbname="${config_db_project_user_name}"
    fi
    create_database "${dbname}" "${user}" "${pass}" "${config_db_admin_password}"
    if [ "${config_db_import_base_database}" = "true" ]
        mysql -u "${user}" -p"${pass}" "${dbname}" <  "/home/vagrant/databases/${config_db_base_database_name}"
    fi
fi

# extra stuff / incidentals
# #sudo apt-get -y install autoconf
# #sudo apt-get -y install bison
# sudo apt-get -y install build-essential
# sudo apt-get -y install curl
# #sudo apt-get -y install libreadline-dev
# #sudo apt-get -y install libssl-dev
# #sudo apt-get -y install libreadline6-dev
# #sudo apt-get -y install libyaml-dev
# #sudo apt-get -y install sqlite3
# #sudo apt-get -y install libsqlite3-dev
# #sudo apt-get -y install libxml2-dev
# #sudo apt-get -y install libxslt1-dev
# #sudo apt-get -y install libcurl4-openssl-dev
# #sudo apt-get -y install libffi-dev
# sudo apt-get -y install imagemagick
# sudo apt-get -y install pv
# #sudo apt-get -y install zlib1g-dev
# #sudo apt-get -y install libncurses5-dev


# Everything in one command for speed. Comment out and then use the bits lower down if you need to configure differently. 
sudo apt-get install -y build-essential curl imagemagick pv 

# Secondary languages
# python
sudo chmod -Rf 777 /home/vagrant/system_files/utilities
cd /home/vagrant/system_files/utilities/secondary_languages
sudo ./python.sh
# nodejs
cd /home/vagrant/system_files/utilities/secondary_languages
sudo ./nodejs.sh
# ruby
cd /home/vagrant/system_files/utilities/secondary_languages
sudo ./ruby.sh

if [ "${config_optional_items_ruby_rails}" = "true" ]
    then
    gem install rails -v 4.2.4
fi
# CSS preprocessors
# sass
if [ "${config_optional_items_sass}" = "true" ]
    then
. /home/vagrant/system_files/utilities/css_preprocessors/sass.sh
fi
# less
# echo "+++++++=====Before LESS"
if [ "${config_optional_items_less}" = "true" ]
    then
. /home/vagrant/system_files/utilities/css_preprocessors/less.sh
fi
# now to move our masters to the correct places
sudo cp /home/vagrant/system_files/php5/apache2/php.ini /etc/php5/apache2/php.ini
sudo cp /home/vagrant/system_files/php5/cli/php.ini /etc/php5/cli/php.ini
sudo cp /home/vagrant/system_files/ssh/* /home/vagrant/.ssh/

# restart apache
sudo service apache2 restart