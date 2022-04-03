# -*- mode: ruby -*-
# vi: set ft=ruby :

HOME_ON_VM = "/home/vagrant".freeze

ENV["LC_ALL"] = "C.UTF-8"

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.ssh.forward_agent = true

  # Fix for: "stdin: is not a tty"
  # https://github.com/mitchellh/vagrant/issues/1673#issuecomment-28288042
  config.ssh.shell = %(bash -c "BASH_ENV=/etc/profile exec bash")

  config.vm.network :private_network, ip: "192.168.56.10", hostsupdater: "skip"

  config.vm.network "forwarded_port", guest: 8900, host: 8900 # solana WS

  main_hostname = "solana.bootcamp.local"
  config.vm.hostname = main_hostname

  config.vm.post_up_message = <<-EOF
#{main_hostname} is ready
EOF

  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
  else
    fail Vagrant::Errors::VagrantError.new, "vagrant-hostmanager missing, please install the plugin with this command:\nvagrant plugin install vagrant-hostmanager"
  end

  if ! Vagrant.has_plugin?("vagrant-bindfs")
    fail Vagrant::Errors::VagrantError.new, "vagrant-bindfs missing, please install the plugin with this command:\nvagrant plugin install vagrant-bindfs"
  end

  ## Disable root (default) shared folder
  config.vm.synced_folder ".", "/vagrant", disabled: true, id: "root"

  # Add shared folders
  # -- scripts
  config.vm.synced_folder "./scripts", "/var/nfs/vagrant-nfs-scripts", type: :nfs
  config.bindfs.bind_folder "/var/nfs/vagrant-nfs-scripts", File.join(HOME_ON_VM, "scripts")
  # -- project
  config.vm.synced_folder "./", "/var/nfs/vagrant-nfs-project", type: :nfs
  config.bindfs.bind_folder "/var/nfs/vagrant-nfs-project", File.join(HOME_ON_VM, "project")
  # -- solana
  config.vm.synced_folder "./solana", "/var/nfs/vagrant-nfs-solana", type: :nfs
  # config.bindfs.bind_folder "/var/nfs/vagrant-nfs-solana", File.join(HOME_ON_VM, ".config/solana"), o: :nonempty, perms: 'u=rwX:g=rwX:o=rD'
  config.bindfs.bind_folder "/var/nfs/vagrant-nfs-solana", File.join(HOME_ON_VM, ".config/solana"), o: :nonempty

  config.vm.provider "virtualbox" do |vb|
    vb.name = config.vm.hostname
    vb.customize ["modifyvm", :id, "--cpus", 2]
    vb.customize ["modifyvm", :id, "--memory", 8192]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--uartmode1", "disconnected"]

    # Fix for slow external network connections
    vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--nictype2", "virtio"]

    # Time sync
    vb.customize ["modifyvm", :id, "--rtcuseutc", "on"]
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-interval", 10000]
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-min-adjust", 100]
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-on-restore", 1]
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000]
  end

  # Provisioning
  $script = <<-SCRIPT
  set -euo pipefail

  # chown vagrant:vagrant #{HOME_ON_VM}

  echo "[info] Run script ..."
  bash #{HOME_ON_VM}/scripts/setup.sh
  SCRIPT

  config.vm.provision "shell", inline: $script, privileged: false
end
