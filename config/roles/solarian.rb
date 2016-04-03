name "Solarian"
description "Configure Solarian network"

run_list *[
  'recipe[basics]',
  'recipe[solarian]'
]
