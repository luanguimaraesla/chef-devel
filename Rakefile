require 'yaml'

evironment = "lappis"

ssh_config_file = "config/#{environment}/ssh_config"
ips_file = "config/#{environment}/ips.yaml"

ENV['CHAKE_SSH_CONFIG'] = ssh_config_file

require "chake"

ips ||= YAML.load_file(ips_file)
config ||= YAML.load_file(config_file)

$nodes.each do |node|
  node.data['config'] = config
  node.data['peers'] = ips
end
