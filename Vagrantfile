# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/precise64"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "rtems-autobuild"
    vb.cpus = 4 # Higher is better
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.provision "shell", path: "setup-rtems.sh"

end
