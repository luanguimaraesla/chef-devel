#install dependencies
version = '3.2.0'
url_redmine = "https://www.redmine.org/releases/redmine-#{version}.tar.gz"
redmine_dir = '/opt/redmine/'
packages = %w(mysql-client libmysqlclient-dev gcc build-essential zlib1g zlib1g-dev zlibc ruby-zip libssl-dev libyaml-dev libcurl4-openssl-dev ruby gem libapache2-mod-passenger apache2-mpm-prefork apache2-dev libapr1-dev libxslt1-dev checkinstall libxml2-dev ruby-dev vim libmagickwand-dev imagemagick)

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
  command 'bundle install --without development test'
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



