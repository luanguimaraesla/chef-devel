iptables_dir = "/etc/iptables.up.rules" 

#Update apt-get
execute "enable_IP_forwading " do
  command "sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf"
end

#Execute forwading ip
execute "forwading ip" do
  command "sudo sysctl -p"
end

template iptables_dir do
  source "iptables.up.rules.erb"
  variables({
    ips: node['peers']
  })
end

#Enable script
execute "enable scripts" do
  command "chmod +x /etc/iptables.up.rules"
end

#Execute script
execute "run scripts" do
  command "./etc/iptables.up.rules"
end
