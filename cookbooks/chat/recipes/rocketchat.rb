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

execute "add mongo environment variable" do
  command 'echo "export MONGO_OPLOG_URL=mongodb://localhost:27017/local" >> /etc/environment'
  command 'export MONGO_OPLOG_URL=mongodb://localhost:27017/local'
  not_if 'grep -q "MONGO_OPLOG_URL" /etc/environment'
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

execute "add mongo environment variable" do
  command "echo \"export ROOT_URL=#{external_address}\" >> /etc/environment"
  command 'echo "export MONGO_URL=mongodb://localhost:27017/rocketchat" >> /etc/environment'
  command 'echo "export PORT=80" >> /etc/environment'
  not_if 'grep -q "ROOT_URL" /etc/environment'
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

execute "run Rocket.Chat" do
  ENV['ROOT_URL'] = external_address
  ENV['MONGO_URL'] = "mongodb://localhost:27017/rocketchat"
  ENV['PORT'] = "80"
  ENV['MONGO_OPLOG_URL'] = "mongodb://localhost:27017/local"
  cwd "/root/Rocket.Chat"
  command "tmux new-session -s rocketchat -d &&
	   tmux send-keys -t rocketchat 'node main.js' enter"
end
