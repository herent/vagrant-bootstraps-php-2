# vagrant-lamp-bootstrap

This package is put together as a simple way to quickly launch customized local php development 
environments using vagrant and virtualbox.  

### Features

* Easily configurable LAMP stack, with project files for the vhost mapped to the outer directory
* The project's working files are ignored by this repo, allowing one server setup to be used across multiple
  actual development projects simply by changing a config variable for git repo
* Automatically sets up a git user. Optionally automatically checkout a specified github URL to the
  project directory. 
* xDebug
* phpMyAdmin
* Ruby
* Nodejs

### Quick Start

1. Clone repo to your local machine.
2. Duplicate [config_sample.yml](/system_files/config_sample.yml) in place.
3. Rename new file config.yml.
3. Customise the new config.yml as needed.
4. Run vagrant up.
5. Add a hosts entry pointing at 192.168.33.112 (or whatever it was changed to in config.yml.)
6. Begin devlopment. The public html folder from the VM will be mapped as "working_files" in the
   root folder. This folder will be ignored by the vagrant repo, so development files don't get mixed up 
   with the virtual machine configuration.

### Basic Configuration

See comments in [config_sample.yml](/system_files/config_sample.yml) for full details. 

**Notes:**
* The project folder shouldn't be changed unless .gitignore is updated to match
* IP address should be unique to each local vagrant box. 
* Updating the values for the project database will not wipe out old values when provisioning. 
  So if the database name changes, the user will have access to both repos. If the user changes, they will not have access to the old databases, but the original user will still be there.
* Changing the ip_address doesn't update when simply running vagrant provision on a running machine

### Advanced Configuration

Beyond the basic config file, there are several other items that can be tweaked to customize the machine.  

#### Modifying the packages installed

Inside of [bootstrap.sh](/system_files/bootstrap.sh) are a whole lot of php and apache modules that are 
commented out. Simply change the commenting to match what you need explicitly. 

If extra packages that aren't listed need to be installed, simply add a sudo apt-get install as needed.
It's recommended these are kept to a single item per install on most machines, for ease of reading and
debugging. However, if the setup is known and people won't be changing it, they can be consolidated. Just
make sure that the order things are added doesn't interfere with the entire flow of the document.

#### Customize php.ini files

Within [/system_files/php5/](/system_files/php5/) there are folders containing some opinionated (and probably insecure) php.ini files that match my usual dev needs. These are copied to the correct locations in 
/etc/php5/ on each provision.

If there are specific settings that you need, simply modify these files.

#### Customize apache config

Like the php.ini customizations, it's possible to use a file for the apache config instead of automatically
generating it. If use_custom_hostfile is set to true in the config.yml, then the 
[custom_hostfile.conf](/system_files/apache2/custom_hostfile.conf) will be copied to the right place 
in the vm to be used as the default. 

This will only copy that one file, so if you have multiple vhosts that need to be set up, they will all need to
be written together. Improper configuration here can prevent the site from being accessible in your local
browser. 

### Limitations

This isn't for production in any way, shape, or form. The apache and php configs are probably not going to 
be right for everyone. The machine created will probably need to be further customized by the end user, as some things like css preprocessors aren't there. 

It doesn't really do multiple virtual hosts very easily. No support for replicating environments with a custom caching server, proxies, etc. 

But honestly, if someone needs those more complicated features, another solution like puppet or protobox is
going to work a lot better. If the goal is just an easily configured box that can be reused for multiple
projects on local machines, then it's perfect. That's the intended use.

### TODO / Roadmap

* Different branches for popular CMS platforms
* Support different git cloning formats
* Post bootstrap bash script for further customizations without modifying the core script as much
* Enable SASS and LESS if in config file, maybe include Compass or Bootstrap
* Automatically import a database on first install, or simply if the database it's loading into doesn't exist
* Nginx support
* Clean up which php and apache modules are turned on by default, I'm not that knowledgeable on best practices
* Extend comments in source code, and maybe add some more detailed output to the shell when launching the box
* Similar repos for python and ruby stacks
* Support for databases besides just mySQL
* Allow choosing how different optional items are installed, IE boostrap using ruby, node, composer, or bower
* Support other VMs besides Ubuntu 14.04

### Credits

The basis for this project came from [Chris @panique](https://github.com/panique). 
Their [original repo](https://github.com/panique/vagrant-lamp-bootstrap) and 
[blog post](http://www.dev-metal.com/super-simple-vagrant-lamp-stack-bootstrap-installable-one-command/) 
were invaluable in learning how everything fit together using Vagrant and creating a jumping off point. 