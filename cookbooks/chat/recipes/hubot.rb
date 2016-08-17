package 'git'

git '/root/hubot-rocketchat' do
  repository 'https://github.com/RocketChat/hubot-rocketchat.git'
  revision 'master'
  action :sync
end

file '/etc/apt/sources.list.d/backports.list' do
  content 'deb http://http.debian.net/debian'
  user 'root'
  group 'root'
  mode '0644'
  action :create_if_missing
end

execute 'purge other docker repos' do
  command 'apt-get purge lxc-docker*'
  command 'apt-get purge docker.io*'
end


execute 'apt-get update'

package 'docker.io'
