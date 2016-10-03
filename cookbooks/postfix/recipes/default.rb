#
# Cookbook Name:: postfix
# Recipe:: default
#

package 'postfix'
service 'postfix'

cookbook_file '/etc/postfix/main.cf'
cookbook_file '/etc/postfix/master.cf' do
  notifies :restart, 'service[postfix]'
end
