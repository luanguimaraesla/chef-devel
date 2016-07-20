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
  not_if 'echo -o -P "mongodb-org" | wc -l'
end

execute "update apt" do
  command "apt-get update"
end

packages = %w(mongodb-org curl graphicsmagick npm nodejs build-essential)

packages.each do |p|
  package p
end

execute "install tool to change node version" do
  command "npm install -g n"
end

execute "change node version to the least" do
  command "n 0.10.40"
end

execute "configure mongo" do
  command 'echo "replication:\n\treplSetName:  \"001-rs\"" >> /etc/mongod.conf'
  not_if 'echo -o -P "replSetName:" | wc -l'
end

service "mongod" do
  action :restart
end

execute "initiate the replica set" do
  command 'mongo --eval "rs.initiate()"'
end

execute "add mongo environment variable" do
  command 'echo "export MONGO_OPLOG_URL=mongodb://localhost:27017/local" >> /etc/environment'
  command 'export MONGO_OPLOG_URL=mongodb://localhost:27017/local'
  only_if 'echo -o -P "MONGO_OPLOG_URL" | wc -l'
end

ENV['MONGO_OPLOG_URL'] = "mongodb://localhost:27017/local"

# INSTALL ROCKET.CHAT

execute "download stable version of rocket.chat" do
  command "curl -L https://rocket.chat/releases/latest/download -o rocket.chat.tgz"
end

execute "untar the binary release" do
  command "tar zxvf rocket.chat.tgz"
  command "rm rocket.chat.tgz"
end

execute "add mongo environment variable" do
  command "echo \"export ROOT_URL=#{external_address}\" >> /etc/environment"
  command 'echo "export MONGO_URL=mongodb://localhost:27017/rocketchat" >> /etc/environment'
  command 'echo "export PORT=80" >> /etc/environment'
  only_if 'echo -o -P "ROOT_URL" | wc -l'
end

ENV['ROOT_URL'] = external_address
ENV['MONGO_URL'] = "mongodb://localhost:27017/rocketchat"
ENV['PORT'] = "80"

execute "rename Rocket.Chat directory" do
  command "mv bundle Rocket.Chat"
end

execute "install Rocket.Chat" do
  cwd "Rocket.Chat/programs/server"
  command "npm install"
end

execute "rum Rocket.Chat" do
  cwd "Rocker.Chat"
  command "node main.js"
end
