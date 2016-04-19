package 'mysql-server'
depends 'mysql', '~> 6.0'

#execute 'create db redmine_devel' do
 # command "CREATE DATABASE redmine_devel"
  #only_if do
   #  "mysql -u root -p mysql -u root --password=''"
  #end
#end


#execute 'create db dotproject' do
 # command "CREATE DATABASE dotproject"
  #only_if do
   #  "mysql -u root -p mysql -u root --password=''"
 # end
#end

mysql_server 'mysql' do
  initial_root_password ''
  action [:create, :start]
end
