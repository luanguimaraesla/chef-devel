name "opennebula-node"
description "Install and configure OpenNebula node"

run_list *[
  'recipe[basics]',
  'recipe[opennebula-node]'
]
