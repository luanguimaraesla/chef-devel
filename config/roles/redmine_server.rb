name "redmine_server"
description "Install and configure redmine"

run_list *[
  'recipe[redmine]'
]
