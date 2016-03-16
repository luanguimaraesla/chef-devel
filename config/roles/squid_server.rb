name "squid_server"
description "Install and configure proxy cache squid service"

run_list *[
  'recipe[basics]',
  'recipe[squid]'
]
