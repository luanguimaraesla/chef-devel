execute 'apt-get update'

package 'build-essential'
package 'tcl8.5'

remote_file '/tmp/redis-stable.tar.gz' do
  source 'http://download.redis.io/releases/redis-stable.tar.gz'
  owner 'root'
  group 'root'
  action :create
end

execute 'untar redis tarball' do
  cwd '/etc'
  command 'tar -xzf /tmp/redis-stable.tar.gz'
end

execute 'redis make' do
  cwd '/etc/redis-stable'
  command 'make && make install'
end

execute 'run install_server script' do
  cwd '/etc/redis-stable/utils'
  command './install_server.sh'
end

service 'redis_6379' do
  action [:enable, :start]
end
