require 'yaml'

environment = "lappis"

ssh_config_file = "config/#{environment}/ssh_config"
ips_file = "config/#{environment}/ips.yaml"
passwd_file = "config/#{environment}/passwd.yaml"

ENV['CHAKE_SSH_CONFIG'] = ssh_config_file

require "chake"

ips ||= YAML.load_file(ips_file)
passwords ||= YAML.load_file(ips_file)

$nodes.each do |node|
  node.data['peers'] = ips
  node.data['passwd'] = passwords
end
