package 'git'

git '/root/hubot-rocketchat' do
  repository 'https://github.com/RocketChat/hubot-rocketchat.git'
  revision 'master'
  action :sync
end

execute 'enable jessie backport' do
  command 'echo "deb http://http.debian.net/debian jessie-backports main" > /etc/apt/sources.list.d/backports.list'
end

execute 'purge other docker repos' do
  command 'apt-get purge lxc-docker*'
  command 'apt-get purge docker.io*'
end

package 'docker.io'

execute 'apt-get update'


