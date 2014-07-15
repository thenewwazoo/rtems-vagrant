# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"

  config.vm.network "private_network",  type: "dhcp"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "rtems-autobuild"
    vb.cpus = 4 # Higher is better
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.provision "shell", path: "setup-rtems.sh"
  config.vm.provision :file, source: 'build-rtems.sh', destination: '/home/vagrant/build-rtems.sh'

end
