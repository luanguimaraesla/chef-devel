service 'rocketchat' do
  action :stop
end

execute 'drop rocketchat tcp @ port 80 requests' do
  command 'iptables -A OUTPUT -p tcp -m owner --uid-owner rocketchat --dport 80 -j DROP'
end

package 'iptables-persistent'

service 'rocketchat' do
  action :start
end
