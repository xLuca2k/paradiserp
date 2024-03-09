
fx_version 'adamant'
game 'gta5'

ui_page "gui/index.html"
shared_script 'scripts_cl/cfg_3dme.lua'

map 'fivem_modul/map.lua'
resource_type 'map' { gameTypes = { fivem = true } }
resource_type 'gametype' { name = 'Medium Roleplay' }

server_scripts{
	"lib/utils.lua",
  	"base.lua",
  	"modules/gui.lua",
  	"modules/group.lua",
  	"modules/admin.lua",
  	"modules/survival.lua",
  	"modules/player_state.lua",
  	"modules/map.lua",
  	"modules/money.lua",
  	"modules/inventory.lua",
  	"modules/identity.lua",
  	"modules/business.lua",
  	"modules/item_transformer.lua",
  	"modules/emotes.lua",
  	"modules/police.lua",
  	"modules/mission.lua",    
  	"modules/aptitude.lua",
	"modules/vip.lua",
	"modules/meniuri.lua",
  	"modules/faction.lua",
	"modules/paycheck.lua",
	"modules/sponsor.lua",
  	"lib/server.lua",
  	"modules/basic_phone.lua",
  	"modules/basic_atm.lua",
  	"modules/basic_market.lua",
  	"modules/basic_gunshop.lua",
  	"modules/basic_garage.lua",
  	"modules/basic_items.lua",
	"modules/basic_miner.lua",
	"modules/basic_portarma.lua",
  	"modules/basic_event.lua",
  	"modules/cloakroom.lua",
	"modules/youtuber.lua",
	"scripts_sv/*.lua",
	"fivem_modul/sv/*.lua",
	"modules/basic_permis.lua",
}

client_scripts{
	"lib/utils.lua",
	"client/Tunnel.lua",
  	"client/Proxy.lua",
  	"client/base.lua",
  	"client/iplloader.lua",
  	"client/gui.lua",
  	"client/player_state.lua",
	"client/spectate.lua",
  	"client/survival.lua",
  	"client/map.lua",
  	"client/basic_garage.lua",
  	"client/lockcar-client.lua",
  	"client/police.lua",
  	"client/paycheck.lua",
	  "scripts_cl/*.lua",
	  "fivem_modul/cl/*.lua",
  	"client/admin.lua",
}

shared_script 'fivem_modul/sh/*.lua'
export 'getRandomSpawnPoint'
export 'spawnPlayer'
export 'addSpawnPoint'
export 'removeSpawnPoint'
export 'loadSpawns'
export 'setAutoSpawn'
export 'setAutoSpawnCallback'
export 'forceRespawn'
server_export "IsRolePresent"
server_export "GetRoles"

files{
	"cfg/client.lua",
	"cfg/item/drugs.lua",
	"lib/Debug.lua",
	"lib/Tools.lua",
	"lib/Proxy.lua",
	"lib/Lang.lua",
	"lib/htmlEntities.lua",
	"cfg/item/food.lua",
	"cfg/item/illegalweapons.lua",
  	"cfg/item/required.lua",
	"cfg/lang/en.lua",
  	"gui/AnnounceManager.js",
  	"gui/design.css",
  	"gui/Div.js",
  	"gui/dynamic_classes.js",
	"gui/index.html",
	"gui/Menu.js",
	"gui/init.js",
	"gui/ProgressBar.js",
	"gui/jquery.js",
	"gui/main.js",
	"img/*.png",
	'html/index.html',
    'html/fontcustom.woff',
    'html/fontcustom2.woff',
    'html/style.css',
    'html/reset.css',
    'html/listener.js',
    'html/img/*.png',
    'stream/*.png',
    'html/index.html',
    'html/index.js',
    'html/style.css',
    "stream/*.gfx",
    "stream/wmk.gfx",
    "stream/*",
    'nui/img/logo2.png',
    'nui/img/backgr.png',
	"gui/RequestManager.js",
	"gui/Menu.js",
	"gui/ogrp.menu.js",
	"gui/WPrompt.js", 
	"gui/fonts/carme.woff",
	"gui/fonts/fontcustom.woff",
	"gui/fonts/GTA.woff",
	"gui/fonts/House.woff",
	"gui/fonts/carme.woff", 
	"gui/fonts/london.woff", 
	"gui/fonts/Adrianna-Extrabold.woff",
	"gui/fonts/Pdown.woff",
	"gui/fonts/Pricedown.woff", 
	"gui/fonts/wmk.gfx"
}

files{
	"gui/fonts/wmk.gfx",
  	"gui/assets/visualsettings.dat",
	"gui/assets/logo.png",
	"gui/assets/buletin.png",
	"gui/assets/logoserver.png"
}

files{
	"cfg/client.lua",

	"gui/index.html",
	"gui/design.css",
	"gui/main.js",
	"gui/ogrp.main.js",
	"gui/ogrp.menu.js",
	"gui/ProgressBar.js",
	"gui/WPrompt.js",
	"gui/RequestManager.js",
	"gui/AnnounceManager.js",
	"gui/Div.js",
	"gui/dynamic_classes.js",
	"gui/deathscreen.css",
	"gui/underground.js",
	"gui/fonts/Pdown.woff",
	"gui/fonts/GTA.woff",
  
	"gui/img/backgr.png",
	"gui/img/logo.png",
  'stream/*.png',
  'stream/*.gfx',

  'assets/*',
}

files{
	"cfg/client.lua",
	'gui/*',

  'gui/sounds/*.ogg',
	"gui/index.html",
	"gui/design.css",
	"gui/items/*.png",
	"imgs/*",
	"gui/main.js",
	"gui/ogrp.main.js",
	"gui/ogrp.menu.js",
	"gui/ProgressBar.js",
	"gui/WPrompt.js",
	"gui/RequestManager.js",
	"gui/AnnounceManager.js",
	"gui/Div.js",
	"gui/dynamic_classes.js",
	"gui/fonts/fontcustom.woff",
	"gui/fonts/Meniu.ttf",
	"gui/fonts/GOODTIME.ttf",
	"gui/fonts/GTA.woff",
  
	"gui/visualsettings.dat",
  'stream/*.png',
  'stream/*.gfx',
  'gui/fonts/lemon2.otf',
  'assets/*',
}


