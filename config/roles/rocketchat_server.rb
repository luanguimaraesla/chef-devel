name "rocketchat_server"
description "Install and configure Rocket.Chat server"

run_list *[
  'recipe[basics]',
  'recipe[chat::rocketchat]'
]
