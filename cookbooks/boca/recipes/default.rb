url_download_installation_file = "http://www.ime.usp.br/~cassio/boca/download.php?filename=installv2.sh"
work_dir = "/home/lappis/"
boca_installation_file = "install_boca.sh"

remote_file work_dir + boca_installation_file do
  source url_download_installation_file
end

bash 'extract_module' do
  cwd work_dir
  code <<-EOH
    ./install_boca.sh
  EOH
end
