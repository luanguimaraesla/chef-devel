name "firewall"
description "Install and configure firewall"

run_list *[
  'recipe[basics]',
  'recipe[firewall]'
]
  
