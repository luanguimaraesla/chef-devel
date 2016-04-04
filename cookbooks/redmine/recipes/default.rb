version = '3.2.0'
url_redmine = "https://www.redmine.org/releases/redmine-#{version}.tar.gz"
redmine_dir = '/opt/redmine/'
apache_conf_dir = '/etc/apache2/sites-available/master.conf'
#install dependencies
execute 'update' do
  command "apt-get update"
  ignore_failure true
  action :nothing
end
packages = %w(mysql-client libmysqlclient-dev gcc build-essential zlib1g zlib1g-dev zlibc ruby-zip libssl-dev libyaml-dev libcurl4-openssl-dev ruby gem libapache2-mod-passenger apache2-mpm-prefork apache2-dev libapr1-dev libxslt1-dev checkinstall libxml2-dev ruby-dev vim libmagickwand-dev imagemagick)

#gem_package 'passenger'
packages.each do |package_name|
  package package_name
end

directory redmine_dir

remote_file redmine_dir + 'redmine.tar.gz' do
  source url_redmine
  mode '0755'
end

execute 'extract_redmine' do
  command 'tar xzf redmine.tar.gz'
  cwd redmine_dir
end

#installing gem bundler
gem_package 'bundler'

extracted_redmine_dir = redmine_dir+'redmine-'+version

execute 'bundle_install' do
  command 'bundle install'
  cwd extracted_redmine_dir
end

execute 'generate_redmine_secret_token' do
  command 'bundle exec rake generate_secret_token'
  cwd extracted_redmine_dir
end

template extracted_redmine_dir+'/'+'config/database.yml' do
  source 'database.yml.erb'
  variables({
    redmine_passwd: node['passwd']['redmine']
  })
end

execute 'database_migration' do
  command 'RAILS_ENV=production bundle exec rake db:migrate'
  cwd extracted_redmine_dir
  #RAILS_ENV=production bundle exec rake redmine:load_default_data
end

execute "chown-data-www" do
  command "sudo chown -R www-data files log tmp public/plugin_assets"
  user "root"
  cwd extracted_redmine_dir
end

execute "simbolic_link" do
  command 'sudo ln -s '+extracted_redmine_dir+'/public/'+' /var/www/html/redmine'  
end 

template apache_conf_dir do
  source 'master.conf.erb'
end

execute 'disable_default_apache' do
  command 'sudo a2dissite 000-default.conf'
end

execute 'enable_master_conf' do
  command 'sudo a2ensite master.conf'
end

execute 'passenger_permission' do
  command "echo 'PassengerUser www-data' >> /etc/apache2/mods-available/passenger.conf"
end

execute 'enable_passenger' do
  command "sudo a2enmod passenger"

end
service 'apache2' do
  action :restart
end 


