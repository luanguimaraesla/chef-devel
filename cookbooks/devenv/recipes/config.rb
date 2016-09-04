# This recipe sets the crab Team development environment on
# a virtual machine vagrant debian jessie 8.5
# created by Luan Guimarães Lacerda

execute 'apt-get update'

necessary_packages = %w(curl git vim nodejs)

necessary_packages.each do | pkg_name |
  package pkg_name
end

execute 'add gpg key' do
  command 'gpg --keyserver hkp://keys.gnupg.net:80 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3'
end

execute 'installing the newest version of ruby via curl' do
  command '\curl -L https://get.rvm.io | bash -s stable --ruby'
end

execute 'update ruby gem system' do
  command 'gem update --system'
  user 'vagrant'
end

execute 'update all stale gems' do
  command 'gem update'
  user 'vagrant'
end

execute 'create gemset' do
  command 'rvm gemset create owla'
  user 'vagrant'
end

execute 'use gemset' do
  command 'rvm use 2.3.1@owla'
end

package 'ruby-dev'

execute 'gem install rails' do
  command 'gem install rails -v 5.0.0.1'
  user 'vagrant'
end

execute 'gem install bundler' do
  command 'gem install bundler'
  user 'vagrant'
end
