#
# Cookbook Name:: portal
# Recipe:: backup
#
#
# Settings up backup routine
#

template '/usr/bin/portal_backup' do
  mode '755'
end

file '/var/log/portal_backup.log'
cookbook_file '/etc/cron.d/portal_backup_routine'
