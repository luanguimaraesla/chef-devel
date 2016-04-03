name "Polaris"
description "Iconfigure Polaris network"

run_list *[
  'recipe[basics]',
  'recipe[polaris]'
]
