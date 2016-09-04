# This recipe sets the crab Team development environment on
# a virtual machine vagrant debian jessie 8.5
# created by Luan Guimarães Lacerda
current_user = 'vagrant'


execute 'apt-get update'

necessary_packages = %w(curl git vim nodejs)

necessary_packages.each do | pkg_name |
  package pkg_name
end

key_server = 'hkp://keys.gnupg.net'
key_server_port = '80'
home_dir = "/home/#{current_user}/.gnupg"
gpg_key = '409B6B1796C275462A1703113804BB82D39DC0E3'

execute 'Adding gpg key' do
  command "`which gpg2 || which gpg` --keyserver #{key_server}:#{key_server_port} --homedir #{home_dir} --recv-keys #{gpg_key}"
  only_if 'which gpg2 || which gpg'
  user current_user
end

old_home = ENV['HOME']

ruby_block "clear_home for CHEF-3940" do
  block do
      ENV['HOME'] = Etc.getpwnam(current_user).dir
  end
end

#bash 'install ruby via curl' do
#  code '\curl -L https://get.rvm.io | bash -s stable --ruby'
#  user current_user
#  cwd home_dir
#end

#execute 'installing the newest version of ruby via curl' do
#  command '\curl -L https://get.rvm.io | bash -s stable --ruby'
#  user current_user
#  cwd home_dir
#end

execute 'update ruby gem system' do
  command 'gem update --system'
  user current_user
end

execute 'update all stale gems' do
  command 'gem update'
  user current_user
end

execute 'create gemset' do
  command 'rvm gemset create owla'
  user current_user
end

execute 'use gemset' do
  command 'rvm use 2.3.1@owla'
end

package 'ruby-dev'

execute 'gem install rails' do
  command 'gem install rails -v 5.0.0.1'
  user current_user
end

execute 'gem install bundler' do
  command 'gem install bundler'
  user current_user
end

ruby_block "reset home" do
  block do
    ENV['HOME'] = old_home
  end
end
