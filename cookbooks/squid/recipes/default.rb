# Recipe for squid server

squid_maximum_object_size = "600" #MB
squid_minimum_object_size = "0" #MB
squid_cache_size = "30000" #MB

# Yum update
execute "yum_update" do
  command "yum -y update"
end

# Install Squid
package 'squid'

# Configure squid.conf
squid_conf_file = "/etc/squid/squid.conf"
template squid_conf_file do
  source 'squid.conf.erb'
  variables({
    cache_size: squid_cache_size,
    maximum_object_size: squid_maximum_object_size,
    minimum_object_size: squid_minimum_object_size
  })
end

# Enable iptables to listen port 3128
execute "add_squid_iptables_rule" do
  command "iptables -I INPUT -p tcp --dport 3128 -j ACCEPT && " +
          "iptables-save > /etc/sysconfig/iptables"
end

# Install iptables service
package 'iptables-services'

# Enable iptables on boot and start it
service "iptables" do
  action [:enable,:start]
end
