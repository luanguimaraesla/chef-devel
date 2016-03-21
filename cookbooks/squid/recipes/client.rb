# Configuring squid nodes

# Set proxy
yum_configuration_file = '/etc/yum.conf'
squid_server_ip = node['peers']['squid']
squid_server_proxy_port = '3128'

execute "configure_proxy_cache" do
  command "sed -i '13iproxy=http://#{squid_server_ip}:#{squid_server_proxy_port}' #{yum_configuration_file}"
end

# Comment mirrorlist, uncomment baseurl at CentOS-Base.repo
execute "configure_centos_base_repo" do
  backup_file = ".base_repo_bkp"
  substitution_regex = "'s_mirrorlist/#baseurl_#mirrorlist/baseurl_'"
  centos_base_repo_file = "CentOS-Base.repo"
  command "sed -i#{backup_file + " " +
                   substitution_regex + " " +
                   centos_base_repo_file}"
  cwd "/etc/yum.repos.d/"
end

# Remove fastest mirror plugin
execute "remove_fastestmirror_plugin" do
  command "rm -f /etc/yum/pluginconf.d/fastestmirror.conf"
end
