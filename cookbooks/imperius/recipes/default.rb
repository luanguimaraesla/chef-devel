network_config_dir = '/etc/sysconfig/network-scripts'

package 'bridge-utils'

execute "remove_network_files" do
  command 'rm ifcfg-eth1'
  cwd network_config_dir
  ignore_failure true
end

template network_config_dir + "/ifcfg-eth1" do
  source 'ifcfg-eth1.erb'
end

template network_config_dir + "ifcfg-br0" do
  source 'ifcfg-br0.erb'
end

service "network" do
  action :restart
end
