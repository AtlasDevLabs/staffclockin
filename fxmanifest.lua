fx_version 'cerulean'
games { 'gta5' }
author 'AtlasDevLabs'
description 'Need Support? Join discord.gg/atlaslabs'
version '3.0.0'
lua54 'yes'

shared_script '@ox_lib/init.lua'

client_scripts {
  "client.lua"
}

server_scripts {
  "server_config.lua",
  "functions.lua",
  "server.lua"
}
