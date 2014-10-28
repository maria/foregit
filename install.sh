#!/bin/bash

echo "Instal cURL and RVM"
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y curl
curl -L https://get.rvm.io | bash -s stable
source /home/vagrant/.rvm/scripts/rvm

echo "Install ruby"
rvm use --install 2.0.0-p576
gem install rails -v 4.0.0 --no-ri --no-rdoc

echo "Install Foreman"
sudo wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
sudo dpkg -i puppetlabs-release-precise.deb

sudo echo "deb http://deb.theforeman.org/ precise 1.6" > /etc/apt/sources.list.d/foreman.list
sudo echo "deb http://deb.theforeman.org/ plugins 1.6" >> /etc/apt/sources.list.d/foreman.list
sudo wget -q http://deb.theforeman.org/pubkey.gpg -O- | apt-key add -
sudo apt-get update
sudo apt-get install -y foreman-installer
sudo foreman-installer
