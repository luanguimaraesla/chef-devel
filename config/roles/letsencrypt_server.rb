name "letsencrypt_server"
description "Install and configure letsencrypt server"

run_list *[
  'recipe[basics]',
  'recipe[letsencrypt]',
  'recipe[letsencrypt::nginx_servers]'
]
