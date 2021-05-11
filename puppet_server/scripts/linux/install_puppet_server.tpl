#!/bin/bash

echo "Installing puppetserver"

wget https://apt.puppet.com/puppet7-release-bionic.deb
sudo dpkg -i puppet7-release-bionic.deb
sudo apt-get update
sudo apt-get install puppetserver -y

# Associating the ip with puppet
ip_address=$(hostname -I)
host_entry="$ip_address puppet"
echo "$host_entry" | sudo tee -a /etc/hosts

# Allowing certificate autosign for specified agents
echo "${certname}" | sudo tee -a /etc/puppetlabs/puppet/autosign.conf

sudo systemctl enable puppetserver.service
sudo systemctl start puppetserver

# Install r10k
sudo /opt/puppetlabs/puppet/bin/gem install r10k

sudo mkdir -p /etc/puppetlabs/r10k/ && sudo touch /etc/puppetlabs/r10k/r10k.yaml

# The location to use for storing cached Git repos
echo ":cachedir: '/var/cache/r10k'" | sudo tee -a /etc/puppetlabs/r10k/r10k.yaml

# A list of git repositories to create
echo ":sources:"  | sudo tee -a /etc/puppetlabs/r10k/r10k.yaml
  # This will clone the git repository and instantiate an environment per
  # branch in /etc/puppetlabs/code/environments
echo "  :my-org:"| sudo tee -a /etc/puppetlabs/r10k/r10k.yaml
echo "    remote: ${gitlab_control_repo}" | sudo tee -a /etc/puppetlabs/r10k/r10k.yaml
echo "    basedir: '/etc/puppetlabs/code/environments'" | sudo tee -a /etc/puppetlabs/r10k/r10k.yaml

# Install gitlab runner - need to register runner
curl -LJO "https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb"
dpkg -i gitlab-runner_amd64.deb

# Configuring gitlab runner with control repo in gitlab
sudo gitlab-runner register \
  --non-interactive \
  --url "https://gitlab.com/" \
  --registration-token ${registration_token} \
  --executor "docker" \
  --docker-image alpine:latest \
  --description "puppetsvr-runner" \
  --tag-list "puppetserver" \
  --run-untagged="false" \
  --locked="false" \
  --access-level="not_protected"

sudo gitlab-runner start