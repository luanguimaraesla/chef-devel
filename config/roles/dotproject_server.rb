name "dotproject_server"
description "Install and configure dotproject"

run_list *[
  'recipe[basics]',
  'recipe[dotproject]',
]
