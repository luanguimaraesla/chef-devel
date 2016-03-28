name "opennebula-frontend"
description "Install and configure OpenNebula Front end"

run_list *[
  'recipe[basics]',
  'recipe[opennebula-frontend]'
]
