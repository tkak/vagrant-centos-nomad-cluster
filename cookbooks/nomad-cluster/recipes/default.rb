#
# Cookbook:: nomad-cluster
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

servers = []
search_string = node['nomad-cluster']['consul']['search_query']
search(
  :node, search_string,
  filter_result: { 'interfaces' => ['network', 'interfaces'] }
).each do |result|
  result['interfaces'].each_value do |v|
    v['addresses'].each_key do |k|
      servers << k if k =~ /^192\.168\.33\./
    end
  end
end

private_ipaddress = ''
node['network']['interfaces'].each_value do |v|
  v['addresses'].each_key do |k|
    private_ipaddress = k if k =~ /^192\.168\.33\./
  end
end

if node['nomad']['config']['server']['enabled']
  node.default['consul']['config']['server'] = true
  node.default['nomad']['config']['server']['bootstrap_expect'] = servers.uniq.length
  node.default['consul']['config']['bootstrap_expect'] = servers.uniq.length
end

node.default['consul']['config']['advertise_addr'] = private_ipaddress
node.default['consul']['config']['advertise_addr_wan'] = private_ipaddress
node.default['consul']['config']['start_join'] = servers.uniq
node.default['nomad']['config']['advertise']['http'] = private_ipaddress
node.default['nomad']['config']['advertise']['rpc'] = private_ipaddress
node.default['nomad']['config']['advertise']['serf'] = private_ipaddress
node.default['nomad']['config']['consul']['address'] = "#{private_ipaddress}:8500"


include_recipe 'consul::default'
include_recipe 'nomad-agent::default'
include_recipe 'chef-client::default'
