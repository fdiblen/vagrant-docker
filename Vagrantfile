# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'
ENV['VAGRANT_NO_PARALLEL'] = 'yes'


$ssh_script = <<-SCRIPT
cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
SCRIPT


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|


  ####################################################
  # Server 1
  ####################################################
  config.vm.define "server1" do |server1|

    server1.vm.provider :docker do |docker, override|
      override.vm.box = nil

      # server1.vm.synced_folder ".", "/code", docker_consistency: "cached"
      server1.vm.synced_folder ".", "/code", docker_consistency: "delegated"

      # docker.pull_images "ubuntu:20.04"
      # docker.image = "ubuntu:20.04"
      docker.build_dir="."
      docker.dockerfile = "Dockerfile"
      docker.build_args = ['--tag', 'fdiblen/server1:latest']
      docker.name = "server1"


      docker.create_args = [
        "--detach",
        "--interactive",
        "--tty",
        "--memory", "2g",
        "--volume", "/sys/fs/cgroup:/sys/fs/cgroup:ro",
        "--env", "DOCKER_CONTAINER_NAME=server1"
      ]
      # for arm machines add "--platform=linux/arm64"


      docker.ports = [
        "8080:8080",
        "3000:3000"
      ]

      docker.env = {
        :SSH_USER => 'vagrant',
        :SSH_SUDO => 'ALL=(ALL) NOPASSWD:ALL',
        :LANG     => 'en_US.UTF-8',
        :LANGUAGE => 'en_US:en',
        :LC_ALL   => 'en_US.UTF-8',
        :SSH_INHERIT_ENVIRONMENT => 'true'
      }


      docker.force_host_vm = false
      docker.vagrant_vagrantfile = __FILE__

      # docker.link "server2:server2"
      docker.volumes = ["/var/www:/var/www"]

      docker.has_ssh = true
      # override.ssh.insert_key = true
      # override.ssh.username = "vagrant"
      # override.ssh.password = "vagrant"

      docker.remains_running = true
      docker.privileged = true

      server1.trigger.after :up do |trigger|
        trigger.info = "Run ssh_script"
        trigger.run_remote = {inline: $ssh_script}
      end

    end

  end


  ####################################################
  # Server 2
  ####################################################
  config.vm.define "server2" do |server2|

    server2.vm.provider :docker do |docker, override|
      override.vm.box = nil

      # server2.vm.synced_folder ".", "/code", docker_consistency: "cached"
      server2.vm.synced_folder ".", "/code", docker_consistency: "delegated"

      # docker.pull_images "ubuntu:20.04"
      # docker.image = "ubuntu:20.04"
      docker.build_dir="."
      docker.dockerfile = "Dockerfile"
      docker.build_args = ['--tag', 'fdiblen/server2:latest']
      docker.name = "server2"

      docker.create_args = [
        "--detach",
        "--interactive",
        "--tty",
        "--memory", "2g",
        "--volume", "/sys/fs/cgroup:/sys/fs/cgroup:ro",
        "--volumes-from=server1",
        "--env", "DOCKER_CONTAINER_NAME=server2"
      ]
      # for arm machines add "--platform=linux/arm64"

      docker.ports = [
        "8081:8081",
        "3001:3001"
      ]

      docker.env = {
        :SSH_USER => 'vagrant',
        :SSH_SUDO => 'ALL=(ALL) NOPASSWD:ALL',
        :LANG     => 'en_US.UTF-8',
        :LANGUAGE => 'en_US:en',
        :LC_ALL   => 'en_US.UTF-8',
        :SSH_INHERIT_ENVIRONMENT => 'true',
        :DOCKER_CONTAINER_NAME => 'server2',
        "DOCKER_CONTAINER_NAME":"server2"
      }

      docker.force_host_vm = false
      docker.vagrant_vagrantfile = __FILE__

      docker.link "server1:server1"
      # docker.volumes = ["/var/www:/var/www"]

      docker.has_ssh = true
      # override.ssh.insert_key = true
      # override.ssh.username = "vagrant"
      # override.ssh.password = "vagrant"

      docker.remains_running = true
      docker.privileged = true

    end

    server2.trigger.after :up do |trigger|
      trigger.info = "Run ssh_script"
      trigger.run_remote = {inline: $ssh_script}
    end

  end


end
