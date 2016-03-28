repo_dir = '/etc/yum.repos.d/opennebula.repo'
temp_dir = '/tmp'
package "epel-release"

template repo_dir do 
  source 'opennebula.repo.erb'
end

template temp_dir + '/entry' do
  source 'entry.erb'
end

package 'opennebula-server'
package 'opennebula-sunstone'


execute 'change_script' do
  command 'sed -i "s/yum install/yum install -y/g" /usr/share/one/install_gems'
end

execute 'sunstone' do
  command 'echo -e 1 "\n" | /usr/share/one/install_gems'
end

service 'opennebula-server' do 
  action [:enable, :start]
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
end
