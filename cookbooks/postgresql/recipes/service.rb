
package 'postgresql'

template '/etc/postgresql/9.4/main/pg_hba.conf' do
  source 'pg_hba.conf.erb'
  owner 'postgres'
  group 'postgres'
  mode 0644
end

service 'postgresql' do
  action [:enable, :start]
end
