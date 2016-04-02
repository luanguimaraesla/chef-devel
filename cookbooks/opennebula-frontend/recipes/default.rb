repo_dir = '/etc/yum.repos.d/opennebula.repo'
config_ssh_dir = '/var/lib/one/.ssh/config'
package "epel-release"

template repo_dir do 
  source 'opennebula.repo.erb'
end

package 'opennebula-server'
package 'opennebula-sunstone'

execute 'disable-selinux' do
  command 'sed -i "s/SELINUX=\w*/SELINUX=disable /g" etc/sysconfig/selinux'
end

execute 'change_script' do
  command 'sed -i "s/yum install/yum install -y/g" /usr/share/one/install_gems'
end

execute 'sunstone' do
  command 'echo -e 1 "\n" "\n"| /usr/share/one/install_gems'
end

execute 'external_acess' do
  command 'sed -i "s/:host: 127.0.0.1/:host: 0.0.0.0/g" /etc/one/sunstone-server.conf'
end

service 'opennebula' do
  action [:enable, :start]
end

service 'opennebula-sunstone' do
  action [:enable, :start]
end
 
template config_ssh_dir do
  source 'config.erb'
  owner 'oneadmin'
  group 'oneadmin'
  mode '0600'
end
