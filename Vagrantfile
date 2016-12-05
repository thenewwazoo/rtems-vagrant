# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "dummy"
  config.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV["AWS_ACCESS_KEY_ID"]
    aws.secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]

    aws.ami = "ami-3d2cce5d"
    aws.instance_type = "m4.2xlarge"
    aws.security_groups = ["default",]
    aws.region = "us-west-2"

    aws.keypair_name = "aws"
    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = ENV["HOME"] + "/.ssh/aws"

    aws.block_device_mapping = [{ 'DeviceName' => '/dev/sda1', 'Ebs.VolumeSize' => 50 }]

    aws.tags = {
      'Name' => 'rtems-vagrant'
    }

  end

#  config.vm.provider "virtualbox" do |vb|
#    vb.name = "rtems-autobuild"
#    vb.cpus = 4 # Higher is better
#    vb.customize ["modifyvm", :id, "--memory", "2048"]
#  end

#  config.vm.provision "shell", path: "setup-rtems.sh"

end
