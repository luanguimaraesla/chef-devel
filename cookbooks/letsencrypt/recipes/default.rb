# Recipe to install and configure nginx and letsencrypt

execute 'apt-get update'

packages = %w(nginx git bc)

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

crt_domains = ''
node['crt_domains'].each do |key, value|
  crt_domains += " -d #{value}"
end

execute 'create certificate' do
  command "./letsencrypt-auto certonly -a webroot --renew-by-default --email lappis.unb@gmail.com\
           --webroot-path=/var/www/html#{crt_domains} --agree-tos"
  cwd '/opt/letsencrypt'
end
