name "database_server"
description "Install and configure postgres"

run_list *[
  'recipe[basics]',
  'recipe[database::postgresql]',
  'recipe[database::redis]'
]
