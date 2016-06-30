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

necessary_packages = %w(build-essential ruby-all-dev sysvinit-utils zenity apache2 eclipse-pde
                        python-pip evince g++ gcc libstdc++6 manpages-dev
                        makepasswd php5-cli php5-mcrypt openjdk-7-dbg
                        openjdk-7-jdk php5 php5-pgsql postgresql postgresql-client
                        postgresql-contrib quota sharutils default-jdk
                        openjdk-7-doc default-jre sysstat
                        default-jre sysstat php5-gd debootstrap schroot)

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
  not_if "cat /etc/group | grep icpc | wc -l"
  password node['passwd']['boca']
end

directory '/etc/icpc' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Get the boca current version
require 'open-uri'
boca_version = open("http://www.ime.usp.br/~cassio/boca/icpc.etc.ver.txt") { |f| f.read }
boca_version.delete!("\n")

# Download boca
remote_file '/tmp/icpc.etc.tgz' do
  source "http://www.ime.usp.br/~cassio/boca/download.php?"\
         "filename=icpc-#{boca_version}.etc.tgz"
  mode '0755'
end

execute 'decompress icpc.etc.tgz' do
  cwd '/tmp/'
  command 'tar -xvzf icpc.etc.tgz -C /etc/'
end

bash 'configure permissions' do
  cwd "/tmp/"
  code <<-EOH
    for i in `tar tvzf /tmp/icpc.etc.tgz | awk '{ print $6; }'`; do
      chown root.root /etc/$i
      chmod o-w,u+rx /etc/$i
    done
  EOH
end

service 'procps' do
  action :start
end

bash 'setup user quota' do
  cwd 'tmp/'
  code <<-EOH
    mount / -o remount
    quotaoff -a 2>/dev/null
    quotacheck -M -a
    quotaon -a
    setquota -u postgres 0 3000000 0 10000 -a
    setquota -u icpc 0 500000 0 10000 -a
    setquota -u nobody 0 500000 0 10000 -a
    setquota -u www-data 0 1500000 0 10000 -a
  EOH
end

execute 'update rc.local' do
  command "update-rc.d -f cups remove"
end

execute 'apt-get clean' do
  command "apt-get -y clean"
end

execute 'icpc restart' do
  cwd '/etc/icpc/'
  command "./restart.sh"
end

execute 'pip install pexpect' do
  command 'pip install pexpect'
end

python 'run installboca.sh' do
  cwd '/etc/icpc/'
  code <<-EOH
import pexpect
import sys
from time import sleep

child = pexpect.spawn('/bin/bash', ['-c', './installboca.sh'])
child.logfile = sys.stdout

child.expect('I will install boca at /var/www is it correct[.]*')
child.sendline('y')

child.expect('Do you want me to call the script to make this computer the server[.]*')
child.sendline('y')

child.expect('Do you really want to make this computer the server?[.]*')
child.sendline('y')

child.expect('.*Want a random password.*')
child.sendline('Y')

child.expect('.*Type YES and press return to continue.*')
child.sendline("YES")

sleep(15)

print("FINISHING...")
  EOH
end

service "apache2" do
  action :restart
end
