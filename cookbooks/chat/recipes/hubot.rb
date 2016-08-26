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

template '/etc/init.d/hubot' do
  source 'hubot/hubot.erb'
  mode '0755'
  variables({
    rocketchat_url: "http://#{node['peers']['rocketchat']}:\
                    #{node['crt_domains']['rocketchat']['service_port']}",
    rocketchat_room: node.rocketchat.initd_hubot.rocketchat_room,
    listen_on_all_public: node.rocketchat.initd_hubot.listen_on_all_public,
    rocketchat_user: node.rocketchat.initd_hubot.rocketchat_user,
    rocketchat_password: node['passwd']['hubot'],
    rocketchat_auth: node.rocketchat.initd_hubot.rocketchat_auth,
    bot_name: node.rocketchat.initd_hubot.bot_name,
    external_scripts: node.rocketchat.initd_hubot.external_scripts
  })
end

cookbook_file '/lib/systemd/system/hubot.service' do
  source 'hubot/hubot.service'
  owner 'root'
  group 'root'
  mode '0644'
end

service 'hubot' do
  action [:restart, :enable]
end
