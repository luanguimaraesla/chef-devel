name "hubot_server"
description "Install and configure Hubot server"

run_list *[
  'recipe[basics]',
  'recipe[chat::hubot]'
]
