# Recipe to install and configure the Rocket.Chat

# Variables

external_address = "http://mattermost.lappis.rocks/"

# HOST CONFIGURATION

execute "add apt-key" do
  command "apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10"
end

# since Jessie repository of Mongodb does NOT includes mongodb 3.0
execute "add mongodb repository" do
  command 'echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.0 main" |
                sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list'
  only_if "test -f /etc/apt/sources.list.d/mongodb-org-3.0.list; echo $?"
end

execute "update apt" do
  command "apt-get update"
end


packages = %w(tmux mongodb-org curl graphicsmagick npm nodejs build-essential)

packages.each do |p|
  package p
end

execute "install tool to change node version" do
  command "npm install -g n"
end

execute "change node version to the least" do
  command "n 0.10.40"
end

# Configure host alias for mongo
execute "remove wrong hostname alias" do
  command 'sed -i "/127\.0\.1\.1/d" /etc/hosts'
  ignore_failure true
end

execute "alias hostname" do
  command 'sed -i "s/127\.0\.0\.1/127\.0\.0\.1\trocketchat/g" /etc/hosts'
  not_if 'grep -q rocketchat /etc/hosts'
end

execute "configure mongo" do
  command 'echo "replication:\n  replSetName:  \"001-rs\"" >> /etc/mongod.conf'
  not_if 'grep -q 001-rs /etc/mongod.conf'
end

service "mongod" do
  action :restart
end

execute "initiate the replica set" do
  command 'mongo --eval "rs.initiate()"'
end

# INSTALL ROCKET.CHAT

execute "download stable version of rocket.chat" do
  command "curl -L https://rocket.chat/releases/latest/download -o /root/rocket.chat.tgz"
end


execute "untar the binary release" do
  cwd "/root"
  command "tar zxvf rocket.chat.tgz"
#  command "rm rocket.chat.tgz"
end

execute "remove old Rocket.Chat dir" do
  command "rm -rf /root/Rocket.Chat/"
end

execute "fix npm missing package" do
  command "npm install fibers@1.0.5 -g"
end

execute "rename Rocket.Chat directory" do
  cwd "/root/"
  command "mv bundle Rocket.Chat"
end

execute "mkdir of npm modules" do
  command "mkdir -p /root/Rocket.Chat/programs/server/node_modules/fibers/"
end

execute "copy fiber binary" do
  command "cp -ar /usr/local/lib/node_modules/fibers/ /root/Rocket.Chat/programs/server/node_modules/"
end

execute "install Rocket.Chat" do
  cwd "/root/Rocket.Chat/programs/server"
  command "npm install"
end

template '/etc/init.d/rocketchat' do
  source 'rocketchat/rocketchat.erb'
  mode '0755'
  variables({
    external_address: node.rocketchat.initd.external_address,
    mongo_url: node.rocketchat.initd.mongo_url,
    port: node.rocketchat.initd.port,
    mongo_oplog_url: node.rocketchat.initd.mongo_oplog_url
  })
end

cookbook_file '/lib/systemd/system/rocketchat.service' do
  source 'rocketchat/rocketchat.service'
  owner 'root'
  group 'root'
  mode '0644'
end

service 'rocketchat' do
  action [:restart, :enable]
end
