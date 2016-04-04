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
                        emacs evince g++ gcc gedit scite libstdc++6
                        makepasswd manpages-dev php5-cli php5-mcrypt openjdk-7-dbg
                        openjdk-7-jdk php5 php5-pgsql postgresql postgresql-client
                        postgresql-contrib quota sharutils default-jdk
                        openjdk-7-doc geany geany-plugin-addons
                        geany-plugins geany-plugin-debugger default-jre sysstat vim
                        xfce4 php5-gd debootstrap schroot libgnomekbd-common)

necessary_packages.each do |package_to_install|
  package package_to_install
end



# Reboot virtual machine
reboot 'now' do
  action :restart_now
  reason 'Boca needs to reboot'
  delay_mins 1
end
