
#
# Cookbook Name:: portal
# Recipe:: database
#

# Settings for PostgreSQL database
#
execute 'create:noosfero:user' do
  command 'createuser noosfero'
  user 'postgres'
  only_if do
    `sudo -u postgres -i psql --quiet --tuples-only -c "select count(*) from pg_user where usename = 'noosfero';"`.strip.to_i == 0
  end
end

execute 'create:noosfero:database' do
  command 'createdb --owner=noosfero noosfero'
  user 'postgres'
  only_if do
    `sudo -u postgres -i psql --quiet --tuples-only -c "select count(*) from pg_database where datname = 'noosfero';"`.strip.to_i == 0
  end
end
