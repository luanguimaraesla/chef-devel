node['crt_domains'].each do | server, params |
  template "/etc/nginx/sites-available/#{ server }" do
    variables({
      service_port: params['service_port'],
      server_name:  params['server_name'],
      server_ip:    node['peers']["#{server}"]
    })
    mode 0644
  end

  link "/etc/nginx/sites-enabled/#{server}" do
    to "/etc/nginx/sites-available/#{server}"
  end
end

service 'nginx' do
  action :reload
end
