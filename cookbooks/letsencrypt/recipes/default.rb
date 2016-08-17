# Recipe to install and configure nginx and letsencrypt

execute 'apt-get update'

packages = %w(nginx hit bc)

packages.each do |a|
  package a
end

git '/opt/letsencrypt' do
  repository 'https://github.com/letsencrypt/letsencrypt'
  action :sync
end

cookbook_file '/etc/nginx/sites-available/default' do
  source 'nginx-default-config'
  owner 'root'
  group 'root'
  mode '0644'
end

service 'nginx' do
  action :reload
end

