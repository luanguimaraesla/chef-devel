repo_dir= '/etc/yum.repos.d/opennebula.repo'
config_ssh_dir = '/var/lib/one/.ssh/config'
network_config_dir = '/etc/sysconfig/network-scripts'

package 'bridge-utils'
#remove all network files
execute "remove_network_files" do
  command 'rm ifcfg-eth1'
  cwd network_config_dir 
  ignore_failure true 
end

#add network files configuration for OpenNebula
template network_config_dir + "/ifcfg-eth1" do
  source 'ifcfg-eth1.erb'
end

template network_config_dir + "/ifcfg-br0" do
  source 'ifcfg-br0.erb'
end

service "network" do
  action :restart
end
#add opennebula repository
template repo_dir do
  source 'opennebula.repo.erb'
end
#install node package for OpenNebula
package "opennebula-node-kvm"

#enable and starts services
service "messagebus.service" do
  action [:enable, :start]
end

service "libvirtd.service" do
  action [:enable, :start]
end

service "nfs-server.service" do
  action [:enable, :start]
end

template config_ssh_dir do
  source 'config.erb'
  owner 'oneadmin'
  group 'oneadmin'
  mode '0600'
end

