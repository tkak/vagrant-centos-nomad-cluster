default['nomad']['config']['server']['enabled'] = false
default['consul']['config']['bind_addr'] = '0.0.0.0'
default['consul']['config']['ui'] = true
default['consul']['config']['datacenter'] = 'dc1'
default['consul']['config']['ports'] = {
  'dns'      => 8600,
  'http'     => 8500,
  'serf_lan' => 8301,
  'serf_wan' => 8302,
  'server'   => 8300,
}
default['nomad-cluster']['consul']['search_query'] = ''
default['chef_client']['interval'] = 300
default['chef_client']['splay'] = 60
