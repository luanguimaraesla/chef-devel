# This recipe sets the crab Team development environment on
# a virtual machine vagrant debian jessie 8.5
# created by Luan Guimarães Lacerda

execu 'apt-get update'

necessary_packages = %w(curl git vim nodejs)

necessary_packages.each do | pkg_name |
  package pkg_name
end

execute 'add gpg key' do
  command 'gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3'
end

execute 'installing the newest version of ruby via curl' do
  command '\curl -L https://get.rvm.io | bash -s stable --ruby'
end

execute 'update ruby gem system' do
  command 'gem update --system'
end

execute 'update all stale gems' do
  command 'gem update'
end

package 'ruby-dev'

necessary_gem_packages = %w(bundler nokogiri)

necessary_gem_packages.each do | gpkg_name |
  gem_package gpkg_name
end

execute 'install rails using gem set just for the current release' do
  command 'rvm use ruby-2.3.1@rails5.0 --create'
end
