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
  command 'apt-get purge lxc-docker* -y'
  command 'apt-get purge docker.io* -y'
end


execute 'apt-get update'

package 'docker.io'

execute 'docker run hubot' do
	command "docker run -i -e ROCKETCHAT_URL=http://#{ node['peers']['rocketchat'] }:3000 \
    -e ROCKETCHAT_ROOM= \
    -e LISTEN_ON_ALL_PUBLIC=true \
    -e ROCKETCHAT_USER=botson \
    -e ROCKETCHAT_PASSWORD=#{ node['passwd']['hubot'] } \
    -e ROCKETCHAT_AUTH=password \
    -e BOT_NAME=hubot \
    -e EXTERNAL_SCRIPTS=hubot-pugme,hubot-help \
    rocketchat/hubot-rocketchat"
end
