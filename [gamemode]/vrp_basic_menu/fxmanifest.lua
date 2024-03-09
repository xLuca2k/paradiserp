description "vrp_basic_menu"
fx_version "adamant"
games {'gta5'}

client_scripts{
  "client/Tunnel.lua",
  "client/Proxy.lua",
  "client.lua",
  "drag/aj/client.lua",
  "playerblips/client.lua",
  "customscripts/client.lua",
  "cfg/commands.lua",
  "runcode/client.lua",
  "jobs/client/*.lua",
  "tptowaypoint/client.lua",
  "taxi/cl_taxi.lua",
  "biz/client.lua",
  "drag/client.lua"
}

server_scripts{
  "@vrp/lib/utils.lua",
  "runcode/server.lua",
  "customscripts/server.lua",
  "drag/aj/server.lua",
  "taxi/sv_taxi.lua",
  "jobs/server/*.lua",
  "server.lua"
}