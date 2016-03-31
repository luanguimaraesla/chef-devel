name "boca_server"
description "Install and configure boca server"

run_list *[
  'recipe[basics]',
  'recipe[boca]'
]
