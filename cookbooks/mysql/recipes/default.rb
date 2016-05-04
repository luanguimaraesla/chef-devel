package 'mysql-server'

execute 'create db redmine_devel' do
  command 'mysql -uroot -e "create database IF NOT EXISTS redmine_devel"'
end

execute 'create db dotproject' do
  command 'mysql -uroot -e "create database IF NOT EXISTS dotproject"'
end

user = 'root'
execute 'change mysql user password' do
  command' mysql mysql -e "UPDATE user SET Password=PASSWORD(\'password-here\') WHERE User=\'root\';FLUSH PRIVILEGES;"'
end

