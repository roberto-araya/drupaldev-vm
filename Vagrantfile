# -*- mode: ruby -*-
# vi: set ft=ruby :


require_relative 'lib/vagrant'

playbook = "provisioning/playbook.yml"
config_file = "config.yml"
vconfig = load_config([config_file])

Vagrant.configure("2") do |config|
    config.vm.define vconfig['vagrant_machine_name']
    config.vm.box = vconfig['vagrant_box']
    config.vm.box_version = "1.0.0"

    config.vm.hostname = vconfig['vagrant_hostname']
    
    # Run Ansible from the Vagrant VM
    config.vm.provision "ansible_local" do |ansible|
        ansible.playbook = playbook
    end
    
    config.vm.provider :virtualbox do |v, override|
        v.gui = true
        v.customize ["modifyvm", :id, "--memory", 4096]
        v.customize ["modifyvm", :id, "--cpus", 2]
        v.customize ["modifyvm", :id, "--vram", "256"]
        v.customize ["setextradata", "global", "GUI/MaxGuestResolution", "any"]
        v.customize ["setextradata", :id, "CustomVideoMode1", "1024x768x32"]
        v.customize ["modifyvm", :id, "--ioapic", "on"]
        v.customize ["modifyvm", :id, "--rtcuseutc", "on"]
        v.customize ["modifyvm", :id, "--accelerate3d", "on"]
        v.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    end
end
