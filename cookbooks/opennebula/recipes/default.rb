repo_dir = '/etc/yum.repos.d/opennebula.repo'
package "epel-release"

template repo_dir do 
  source 'opennebula.repo'
end

package 'opennebula-server'
package 'opennebula-sunstone'

execute 'sunstone' do
  command '/usr/share/one/install_gems'
end

service 'opennebula-server' do 
  action [:enable. :start]
end

service 'opennebula-sunstone' do
  action [:enable, :start]
end
 
execute "ssh_public_key_permission" do
  command "cat << EOT > ~/.ssh/config"+
          "Host *
              StrictHostKeyChecking no
              UserKnownHostsFile /dev/null"+
          "EOT"+
          "chmod 600 ~/.ssh/config" 
