package 'postgresql'

vagrant_user = 'vagrant'
owla_user = 'owla'

template '/etc/postgresql/9.4/main/pg_hba.conf' do
  source 'pg_hba.conf.erb'
  owner 'postgres'
  group 'postgres'
  mode 0644
  variables({
    user_dev: vagrant_user,
    user_app: owla_user,
  })
end

service 'postgresql' do
  action [:enable, :start]
end

execute 'creating postgres\' users for Owla' do
  command "createuser #{owla_user} with createdb login password #{node['passwd']['postgresql']};"
  command "createuser #{owla_vagrant} with createdb login password #{node['passwd']['postgresql']};"
  user 'postgres'
end

service 'postgresql' do
  action [:restart]
end
