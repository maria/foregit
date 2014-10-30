# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.network "private_network", ip: "10.2.0.2"
  config.vm.host_name = "foregit.foreman.local"
  config.vm.box = "precise64"

  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Share code
  config.vm.synced_folder(".", "/home/vagrant/foregit")

  config.vm.provider "virtualbox" do |v|

    # Set VM memory
    v.customize ["modifyvm", :id, "--memory", 1024]
    v.customize ["modifyvm", :id, "--cpus", 2]
  end

  config.vm.provision "shell", path: "install.sh"

end
