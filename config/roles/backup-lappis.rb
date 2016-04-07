name "backup-lappis"
description "Install and configure backup_lappis"

run_list *[
  'recipe[basics]',
  'recipe[backup-lappis]'
]

