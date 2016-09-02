node['crt_domains'].each do | server, params |
	if server != 'default'
		template "/etc/nginx/sites-available/#{ server }-server" do
			source 'server_conf.erb'
			variables({
				server_ip:    node['peers']["#{server}"] || node['peers']['letsencrypt'],
				service_port: params['service_port'],
				server_name:  params['server_name']
			})
			mode 0644
		end
	end

  link "/etc/nginx/sites-enabled/#{server}-server" do
    to "/etc/nginx/sites-available/#{server}-server"
  end
end

service 'nginx' do
  action :reload
end
