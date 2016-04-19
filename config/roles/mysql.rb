name 'Mysql'
description "Configure mysql network"

run_list *[
  'recipe[basics]',
  'recipe[mysql]'
]
