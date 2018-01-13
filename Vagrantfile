# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.
  chef_server = ENV['CHEF_SERVER']
  chef_server ||= 'manage.chef.io'

  config.vm.define 'server' do |node|
    node.vm.box = "bento/centos-7"
    node.vm.network "private_network", ip: "192.168.33.11"
    node.vm.provision "chef_client" do |chef|
      chef.chef_server_url = "https://#{chef_server}/organizations/#{ENV['CHEF_ORG']}"
      chef.validation_client_name = "#{ENV['CHEF_ORG']}-validator"
      chef.validation_key_path = "#{ENV['HOME']}/.chef/#{ENV['CHEF_VALIDATION_FILE']}"
      chef.json = {
      }
      chef.add_role 'nomad-server'
      chef.delete_node = true
      chef.delete_client = true
    end
  end

  config.vm.define 'client' do |node|
    node.vm.box = "bento/centos-7"
    node.vm.network "private_network", ip: "192.168.33.12"
    node.vm.provision "chef_client" do |chef|
      chef.chef_server_url = "https://#{chef_server}/organizations/#{ENV['CHEF_ORG']}"
      chef.validation_client_name = "#{ENV['CHEF_ORG']}-validator"
      chef.validation_key_path = "#{ENV['HOME']}/.chef/#{ENV['CHEF_VALIDATION_FILE']}"
      chef.json = {
        'nomad-cluster': {
          config: {
            server: {
              enabled: false
            }
          }
        }
      }
      chef.add_recipe 'nomad-cluster'
      chef.delete_node = true
      chef.delete_client = true
    end
  end
end
