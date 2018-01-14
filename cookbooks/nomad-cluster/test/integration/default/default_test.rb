# # encoding: utf-8

# Inspec test for recipe nomad-cluster::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe command('/usr/local/bin/consul members') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/alive/) }
  its('stdout') { should match(/192\.168\.33\./) }
end

describe command('/usr/local/bin/nomad server-members') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/alive/) }
end
