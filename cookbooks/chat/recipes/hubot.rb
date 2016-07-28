git '/root/hubot-rocketchat' do
  repository 'https://github.com/RocketChat/hubot-rocketchat.git'
  revision 'master'
  action :sync
end

package 'docker'

execute 'enable jessie backport' do
  command 'echo "deb http://http.debian.net/debian jessie-backports main" > /etc/apt/sources.list.d/backports.list'
end

execute 'apt-get update'


