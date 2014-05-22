# How to set up your development environment

## Create a virtual box

  I prefer having a virtual box for each project I'm working on. This way the setup is independent per project,
and I can restore a working environment easily without affecting other projects.

  I use [Vagrant](http://www.vagrantup.com/) because is easy to install and configure. 
You can create a Vagrant box following [my tutorial](https://github.com/marianitadn/vagrant).


## Clone Foreman

- Clone the project repo on your localhost

- Sync the directory with Vagrant, by editing the Vagrantfile:
 
```
 # Share code                                                                  
 config.vm.synced_folder("~/foreman/", "/home/vagrant/foreman")
```

! You have to restart Vagrant to have access to it -- `vagrant reload`.


## Install Ruby

Foreman and Foregit are written in Ruby/Rails, so it's understandble why you need this.

#### Install [RVM](http://rvm.io/)


  - Install cURL: 
    - Debian (Ubuntu): ```sudo apt-get install curl```
    - Red Hat: ```yum install curl```

  - Install RVM                       

     - Download and install: ```curl -L https://get.rvm.io | bash -s stable```
     - Make it available for all users: ```source /etc/profile```


  - Check installation
   
    - Type: ```type rvm | head -n 1```
    - You should see: ```rvm is a function```
    

#### Install Ruby

  - Install a specific version of Ruby, you can add a newer or older version: ```rvm install 2.0.0```
  - Ensure your version is used by default (you can install more versions): ```rvm use 2.0.0 --default```


#### Install Rails

You should check your project Gemfile to see what version you need.
`gem` is preinstalled viw RVM, and it's a package manager for Ruby libraries.

   - Install Rails: ```gem install rails -v 4.0.0```

## Install smart-proxy

#### Install

- Debian (Ubuntu): ```sudo apt-get install foreman-proxy```
- Red Hat: ```yum localinstall http://yum.theforeman.org/releases/1.5/el6/x86_64/foreman-release.rpm```

#### Star daemon

``` bin/smart-proxy.rb```

## Install libvirt

#### Install:
  
   - Debian (Ubuntu): ```sudo apt-get install libvirt-bin```
   - Red Hat: ```yum -y install libvirt```

#### Change default network configuration
   
  - Debian (Ubuntu): ```vim /var/lib/libvirt/network/default.xml```
   - Red Hat: ?

Rewrite it with:

```xml
<network>
 <name>default</name>
 <uuid>16b7b280-7462-428c-a65c-5753b84c7545</uuid>
 <forward mode='nat'/>
 <bridge name='virbr0' stp='on' delay='0' />
 <domain name="local.lan"/>
 <mac address='52:54:00:a6:01:5d'/>
 <ip address='192.168.122.1' netmask='255.255.255.0'>
   <tftp root='/var/tftproot' />
   <dhcp>
     <range start='192.168.122.2' end='192.168.122.254' />
     <bootp file='pxelinux.0' />
   </dhcp>
 </ip>
</network>

```

#### Configure libvirt (TFTP)

  - Debian (Ubuntu):

```
mkdir -p /var/tftproot/{boot,pxelinux.cfg}
sudo apt-get install syslinux
cp /usr/lib/syslinux/{pxelinux.0,menu.c32,chain.c32} /var/tftproot
sudo chown -R foreman-proxy /var/tftproot/
```

  - Red Hat:

```
mkdir -p /var/tftproot/{boot,pxelinux.cfg}
  yum -y install syslinux
cp /usr/share/syslinux/{pxelinux.0,menu.c32,chain.c32} /var/tftproot
chown -R foreman-proxy:nobody /var/tftproot
find /var/tftproot/ -type d | xargs chmod g+s
```

#### Change Foreman proxy settings

Add in `foreman/config/settings.yml`:
 
```yml
:tftp: true
:tftproot: /var/tftproot
:tftp_servername: 192.168.122.1
:dns: true
:dns_provider: virsh
:dhcp: true
:dhcp_vendor: virsh
:virsh_network: default
```

## Install Foreman

#### Download

For Ubuntu 12.04 (the default flavor for my Vagrant setup):

```
echo "deb http://deb.theforeman.org/ precise 1.5" > /etc/apt/sources.list.d/foreman.list
echo "deb http://deb.theforeman.org/ plugins 1.5" >> /etc/apt/sources.list.d/foreman.list
wget -q http://deb.theforeman.org/foreman.asc -O- | apt-key add -
apt-get update && apt-get install foreman-installer
```


#### Set up FQDN on Vagrant

- Add to `/etc/hosts` in Vagrant your hostname definition

```
127.0.1.1       foreman-dev.myhost.local foreman-dev
```

! The `hostname` in your Vagrantfile has to be `foreman-dev` in this case. You can select another hostname, just be sure to update it accordingly.

- Check FQDN
   - Type: ```$ hostname -f```
   - You should see: ```foreman-dev.myhost.local```
   
   
#### Install 

```
$ foreman-installer
```

#### Check installation

- Add to your local `/etc/hosts` file the line, to redirect calls to Vagrant FQDN to your Vagrant IP address:

```
foreman-dev.myhost.local   10.0.0.2
```

! The IP is set in your Vagrantfile, please ensure they match.


- Access in your browser:

```
https://foreman-dev
```

### Play :).
