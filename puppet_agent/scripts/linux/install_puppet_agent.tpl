#!/bin/bash

# Installs puppet on ubuntu 18.04 VM 
echo "Installing puppet"

wget https://apt.puppet.com/puppet7-release-bionic.deb
sudo dpkg -i puppet7-release-bionic.deb
sudo apt-get update
sudo apt-get install puppet-agent -y

# Adding puppet to sudo path
sudo sed -i 's/bin".*/bin:\/opt\/puppetlabs\/bin"/' /etc/sudoers

# Defining certname that is whitelisted by server
sudo puppet config set certname ${certname}

# Pointing puppet to the server
echo "${server_ip} puppet" | sudo tee -a /etc/hosts

sudo puppet ssl bootstrap

# Starting the puppet service
sudo puppet resource service puppet ensure=running enable=true