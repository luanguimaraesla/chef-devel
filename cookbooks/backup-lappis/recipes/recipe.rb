script_dir = "/usr/bin/noosfero-backup.sh"
crontab_dir = "/var/spool/cron/crontab/root"

cookbook_file script_dir do
  source 'noosfero-backup.sh'
  owner 'root'
  group 'root'
  mode '0755'
  action :create 
end

cookbook_file crontab_dir do
  source 'root'
  owner 'root'
  group 'root'
  mode '600'
  action :create
end

execute 'grants_permission_noosfero' do
  command 'chmod +x /usr/bin/noosfero-backup.sh'
end

