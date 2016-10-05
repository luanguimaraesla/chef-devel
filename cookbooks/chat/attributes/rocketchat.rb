default[:rocketchat][:initd][:external_address] = "https://chat.crab.solutions/"
default[:rocketchat][:initd][:mongo_url] = "mongodb://localhost:27017/rocketchat"
default[:rocketchat][:initd][:port] = "3000"
default[:rocketchat][:initd][:mongo_oplog_url] = "mongodb://localhost:27017/local"

default[:rocketchat][:initd_hubot][:rocketchat_room] = ''
default[:rocketchat][:initd_hubot][:listen_on_all_public] = 'true'
default[:rocketchat][:initd_hubot][:rocketchat_user] = 'botson'
default[:rocketchat][:initd_hubot][:rocketchat_password] = node['passwd']['hubot']
default[:rocketchat][:initd_hubot][:rocketchat_auth] = 'password'
default[:rocketchat][:initd_hubot][:bot_name] = 'botson'
default[:rocketchat][:initd_hubot][:external_scripts] = 'hubot-pugme,hubot-help'
