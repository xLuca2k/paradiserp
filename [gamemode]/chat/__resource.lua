resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'
description 'chat management stuff'

server_scripts{ 
  "@vrp/lib/utils.lua",
}

client_scripts{ 
  "client.lua"
}

ui_page 'html/index.html'

client_script 'cl_chat.lua'

server_script 'sv_chat.lua'

files {
  'html/index.html',
  'html/index.css',
  'html/config.default.js',
  'html/config.js',
  'html/App.js',
  'html/Message.js',
  'html/Suggestions.js',
  'html/vendor/vue.2.3.3.min.js',
  'html/vendor/flexboxgrid.6.3.1.min.css',
  'html/vendor/animate.3.5.2.min.css',
  'html/vendor/latofonts.css',
  'html/vendor/fonts/LatoRegular.woff2',
  'html/vendor/fonts/LatoRegular2.woff2',
  'html/vendor/fonts/LatoLight2.woff2',
  'html/vendor/fonts/LatoLight.woff2',
  'html/vendor/fonts/LatoBold.woff2',
  'html/vendor/fonts/LatoBold2.woff2',
'html/font2.ttf',
'html/font2.otf',
  'html/font3.ttf',
  'html/font1.otf',
  'html/font4.ttf',
}


