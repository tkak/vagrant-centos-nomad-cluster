#
# Cookbook:: nomad-cluster
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

servers = []
search_string = node['nomad-cluster']['consul']['search_query']
search(
  :node, search_string,
  filter_result: { 'ip' => ['ipaddress'] }
).each do |result|
  servers << result['ip']
end

if node['nomad']['config']['server']['enabled']
  node.default['consul']['config']['server'] = true
  node.default['nomad']['config']['server']['bootstrap_expect'] = servers.uniq.length
  node.default['consul']['config']['bootstrap_expect'] = servers.uniq.length
end

node.default['consul']['config']['advertise_addr'] = node['ipaddress']
node.default['consul']['config']['advertise_addr_wan'] = node['ipaddress']
node.default['consul']['config']['start_join'] = servers.uniq

include_recipe 'consul::default'
include_recipe 'nomad-agent::default'
