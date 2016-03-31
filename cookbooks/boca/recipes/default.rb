# Configurations
url_download_installation_file = "http://www.ime.usp.br/~cassio/boca/download.php?filename=installv2.sh"
work_dir = "/home/lappis/"
boca_installation_file = "install_boca.sh"

# Download installer
remote_file work_dir + boca_installation_file do
  source url_download_installation_file
  mode '0755'
end

# Update apt-get
execute "apt-get_update" do
  command "apt-get -y update"
end

# Execute installer script
execute 'boca_script' do
  flags = " alreadydone"
  command boca_installation_file + flags
  cwd work_dir
end

# Reboot virtual machine
reboot 'now' do
  action :restart_now
  reason 'Boca needs to reboot'
  delay_mins 1
end


