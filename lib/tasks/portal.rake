
namespace :portal do

  def ssh_cmd(cmd)
    sh 'ssh', '-F', ENV['CHAKE_SSH_CONFIG'], 'portal', cmd
  end

  def scp_cmd(file, dest, flags='')
    sh 'scp', flags,'-F', ENV['CHAKE_SSH_CONFIG'], file, "portal:#{dest}"
  end

  desc 'Restore backups to noosfero portal database'
  task :restore do
    puts 'Starting backup...'
    ssh_cmd('rm -rf /tmp/backups') # TODO: check if are the same backup by size
    scp_cmd('backups','/tmp/backups','-r')
    routine = [
      'sudo systemctl stop noosfero',
      'sudo -u postgres dropdb noosfero 2> /dev/null',
      'sudo -u postgres createdb noosfero --owner noosfero 2> /dev/null',
      'cd /usr/share/noosfero ; yes y | RAILS_ENV=production sudo -u noosfero bundle exec rake restore BACKUP=/tmp/backups/portal/portal_backup.tar.gz 1> /dev/null 2>/dev/null',
      'sudo systemctl start noosfero'
    ]
    routine.each do |cmd|
      ssh_cmd(cmd)
    end
  end

  desc 'Generate backups from noosfero portal database'
  task :backup do
    puts 'Starting restore...'
  end
end
