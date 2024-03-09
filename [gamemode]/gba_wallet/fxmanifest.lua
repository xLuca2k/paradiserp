shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield



fx_version 'adamant'

game 'gta5'

server_scripts {
    '@vrp/lib/utils.lua',
	'server.lua'
}

client_scripts {
    "@vrp/client/Tunnel.lua",
	"@vrp/client/Proxy.lua",
	'client.lua'
}

ui_page "html/index.html"

files { 
"html/*"
}server_scripts { '@mysql-async/lib/MySQL.lua' }