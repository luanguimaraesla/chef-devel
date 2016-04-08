# Configurations
work_dir = "/home/lappis/"

# Update apt-get
execute "apt-get_update" do
  command "apt-get -y update"
end

# Upgrade apt-get
execute "apt-get_upgrade" do
  command "apt-get -y upgrade"
end

# Install python-software-properties
package 'python-software-properties'

# Remove unecessary packages
unecessary_packages = %w(libreoffice-common libreoffice-base-core thunderbird
                         unity-lens-shopping unity-webapps-common)

unecessary_packages.each do |package_to_purge|
  apt_package package_to_purge do
    package_name package_to_purge
    action :purge
    ignore_failure true
  end
end

necessary_packages = %w(sysvinit-utils install zenity apache2 eclipse-pde
                        eclipse eclipse-rcp eclipse-platform eclipse-jdt eclipse-cdt
                        evince g++ gcc scite libstdc++6
                        manpages-dev php5-cli php5-mcrypt openjdk-7-dbg
                        openjdk-7-jdk php5 php5-pgsql postgresql postgresql-client
                        postgresql-contrib quota sharutils default-jdk
                        openjdk-7-doc geany geany-plugin-addons
                        geany-plugins geany-plugin-debugger default-jre sysstat
                        xfce4 php5-gd debootstrap schroot)

necessary_packages.each do |package_to_install|
  package package_to_install
end

execute 'apt-get autoremove' do
  command 'apt-get -y autoremove'
end

execute 'apt-get clean' do
  command 'apt-get -y clean'
end

# Create boca admin
user 'icpc' do
  comment 'boca admin'
  home '/home/icpc'
  shell '/bin/bash'
  password node['passwd']['boca']
end

directory '/etc/icpc' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

remote_file '/tmp/.boca.version' do
  source 'http://www.ime.usp.br/~cassio/boca/icpc.etc.ver.txt'
  mode '0755'
end

boca_version = File.read("/tmp/.boca.version")

remote_file '/tmp/icpc.etc.tgz' do
  source "http://www.ime.usp.br/~cassio/boca/download.php?"\
         "filename=icpc-#{boca_version}.etc.tgz"
  mode '0755'
end

# Reboot virtual machine
reboot 'now' do
  action :restart_now
  reason 'Boca needs to reboot'
  delay_mins 1
end
