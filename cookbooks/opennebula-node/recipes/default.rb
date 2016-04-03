repo_dir= '/etc/yum.repos.d/opennebula.repo'

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


