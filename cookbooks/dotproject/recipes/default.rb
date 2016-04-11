version = '2.1.8'
url_dotproject = "http://tenet.dl.sourceforge.net/project/dotproject/dotproject/dotProject%20Version%20#{version}/dotproject-#{version}.tar.gz"
dotproject_extracted_dir = '/var/www/'
dotproject_dir = '/var/www/dotproject'
packages = %w(mysql-server mysql-client php5 php5-mysql unzip libphp-jpgraph libgd-tools)

execute 'update' do
  command "apt-get update"
  ignore_failure true
  action :nothing
end

packages.each do |package_name|
  package package_name
end

remote_file dotproject_extracted_dir+'dotproject.tar.gz' do
  source url_dotproject
  mode '0755'
end

execute 'extract_dotproject' do
  command 'tar xzf dotproject.tar.gz'
  cwd dotproject_extracted_dir
end

execute 'configure_permissions' do
  command 'sudo chown www-data.www-data /var/www/dotproject -Rf && sudo chmod 755 /var/www/dotproject -Rf'
  cwd dotproject_dir
end

execute 'confiugre_php' do
  command 'sed -i "s/session.auto_start = 0/session.auto_start = 1/g" /etc/php5/apache2/php.ini'
end

service 'apache2' do
  action :restart
end
