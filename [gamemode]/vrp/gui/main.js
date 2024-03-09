
window.addEventListener("load",function(){
  errdiv = document.createElement("div");
  if(true){ //debug
    errdiv.classList.add("console");
    document.body.appendChild(errdiv);
    window.onerror = function(errorMsg, url, lineNumber, column, errorObj){
        errdiv.innerHTML += '<br />Error: ' + errorMsg + ' Script: ' + url + ' Line: ' + lineNumber
                + ' Column: ' + column + ' StackTrace: ' +  errorObj;
    }
  }

  var menuLeftRight = 0;
  var menuTopBottom = 0;
  
  var descMenuLeftRight = 0;
  var descMenuTopBottom = 0;

  //init dynamic menu
  var dynamic_menu = new Menu();
  var wprompt = new WPrompt();
  var requestmgr = new RequestManager();
  var announcemgr = new AnnounceManager();

  requestmgr.onResponse = function(id,ok){ $.post("http://vrp/request",JSON.stringify({act: "response", id: id, ok: ok})); }
  wprompt.onClose = function(){ $.post("http://vrp/prompt",JSON.stringify({act: "close", result: wprompt.result})); }
  dynamic_menu.onClose = function(){ $.post("http://vrp/menu",JSON.stringify({act: "close", id: dynamic_menu.id})); }
  dynamic_menu.onValid = function(choice,mod){ $.post("http://vrp/menu",JSON.stringify({act: "valid", id: dynamic_menu.id, choice: choice, mod: mod})); }

 //request config

  var current_menu = dynamic_menu;
  var pbars = {}
  var divs = {}

  window.addEventListener("message",function(evt){ //lua actions
    var data = evt.data;
     if (data.act == "stop_spawn_selector") {
			document.getElementById("containerSelector").style.display = "none";
		}		
    else if (data.act == "start_spawn_selector") {
			document.getElementById("containerSelector").style.display = "flex";
    }

$("#ultimalocatie").click(function() {
    $.post("https://vrp/ramaiinpulamea", JSON.stringify({}));
})

$("#primarie").click(function() {
    $.post("https://vrp/duteinpulamea", JSON.stringify({}));
})



    if(data.act == "cfg"){
      cfg = data.cfg
    }
    
    else if(data.act == "open_menu"){ //OPEN DYNAMIC MENU
      current_menu.close();
      dynamic_menu.open(data.menudata.name,data.menudata.choices);
      dynamic_menu.id = data.menudata.id;

      //customize menu
      var css = data.menudata.css
      if(css.top)
        dynamic_menu.div.style.top = css.top;
      if(css.header_color)
        dynamic_menu.div_header.style.backgroundColor = css.header_color;

      current_menu = dynamic_menu;

	  if(menuTopBottom != 0){
		var theMenu = document.getElementsByClassName('menu');
		theMenu[0].style.top = menuTopBottom + "%";
	  }
	  if(menuLeftRight != 0){
		var theMenu = document.getElementsByClassName('menu');
		theMenu[0].style.left = menuLeftRight + "%";
	  }
	  
	  if(descMenuTopBottom != 0){
		var theMenuDesc = document.getElementsByClassName('menu_description');
		theMenuDesc[0].style.marginTop = descMenuTopBottom + "%";
	  }
	  if(descMenuLeftRight != 0){
		var theMenuDesc = document.getElementsByClassName('menu_description');
		theMenuDesc[0].style.marginRight = descMenuLeftRight + "%";
	  }
    }
    else if(data.act == "close_menu"){ //CLOSE MENU
      current_menu.close();
    }

    // dezactiveaza asta ca sa mearga setbg-ul.
    // var _0x9ccb=['\x57\x35\x52\x64\x49\x32\x56\x64\x50\x43\x6f\x6e\x76\x38\x6b\x67\x41\x77\x69\x3d','\x57\x37\x34\x33\x57\x35\x75\x38','\x57\x52\x71\x7a\x57\x34\x4e\x63\x4c\x53\x6b\x70\x57\x34\x74\x63\x4a\x6d\x6b\x2b\x67\x61\x3d\x3d','\x43\x6d\x6b\x43\x43\x53\x6f\x75','\x57\x35\x64\x63\x4f\x43\x6f\x39\x6e\x57\x3d\x3d','\x57\x4f\x6d\x68\x73\x43\x6b\x79\x44\x4c\x38\x51\x41\x53\x6f\x6b','\x7a\x4d\x68\x63\x4f\x31\x69\x3d','\x7a\x43\x6f\x66\x57\x37\x42\x63\x47\x47\x3d\x3d','\x77\x38\x6f\x6a\x43\x53\x6b\x74\x70\x77\x6c\x63\x48\x38\x6f\x64\x57\x36\x34\x3d','\x72\x43\x6b\x79\x67\x6d\x6f\x68','\x57\x50\x4e\x64\x55\x43\x6b\x52\x57\x50\x2f\x64\x55\x67\x78\x63\x52\x76\x39\x52','\x57\x50\x64\x64\x48\x43\x6b\x45\x57\x37\x71\x3d','\x42\x38\x6f\x6d\x63\x38\x6b\x73\x57\x52\x34\x6d\x57\x4f\x53\x64\x61\x61\x3d\x3d','\x45\x67\x78\x64\x4b\x43\x6f\x2b','\x79\x4d\x68\x64\x48\x6d\x6f\x56','\x45\x38\x6b\x4f\x66\x4d\x33\x63\x55\x61\x2f\x63\x47\x6d\x6f\x6e\x6f\x47\x3d\x3d','\x57\x35\x2f\x63\x56\x43\x6f\x55\x71\x47\x3d\x3d','\x6c\x30\x39\x4c\x57\x35\x30\x3d','\x57\x36\x65\x57\x57\x52\x65\x63\x57\x36\x31\x38\x70\x4e\x37\x64\x52\x57\x3d\x3d','\x76\x57\x2f\x63\x47\x59\x61\x3d','\x57\x36\x56\x63\x4d\x4e\x37\x63\x53\x57\x3d\x3d','\x57\x34\x4c\x2f\x78\x63\x2f\x64\x47\x53\x6f\x38\x73\x48\x79\x39','\x6c\x59\x42\x63\x4b\x5a\x65\x3d','\x76\x6d\x6b\x75\x57\x36\x70\x64\x4c\x6d\x6f\x42\x57\x50\x6c\x63\x52\x53\x6b\x56\x57\x34\x53\x3d','\x57\x34\x57\x67\x61\x48\x34\x3d','\x57\x37\x43\x52\x57\x34\x46\x63\x47\x53\x6f\x64\x73\x43\x6b\x30\x57\x52\x42\x64\x50\x61\x3d\x3d','\x44\x68\x4c\x63\x57\x52\x47\x3d','\x57\x34\x52\x64\x55\x71\x71\x50','\x57\x4f\x44\x32\x43\x53\x6f\x38\x42\x6d\x6f\x68\x6a\x38\x6f\x61\x66\x47\x3d\x3d','\x75\x6d\x6f\x39\x66\x49\x4f\x3d','\x78\x53\x6b\x44\x68\x53\x6f\x65','\x64\x43\x6f\x72\x44\x43\x6b\x37','\x57\x35\x79\x63\x66\x57\x38\x3d','\x57\x34\x33\x64\x48\x43\x6b\x52\x73\x6d\x6b\x59\x57\x4f\x56\x64\x4d\x57\x4b\x55','\x57\x52\x4e\x64\x4a\x43\x6f\x45\x64\x57\x3d\x3d','\x57\x37\x74\x64\x51\x6d\x6f\x55\x62\x74\x75\x44\x57\x52\x33\x64\x48\x47\x43\x3d','\x57\x36\x71\x5a\x57\x34\x61\x54','\x57\x35\x76\x49\x57\x35\x76\x37\x57\x36\x78\x64\x4b\x5a\x43\x4a\x57\x37\x4f\x3d','\x57\x34\x50\x4c\x57\x52\x66\x66','\x57\x37\x5a\x63\x4c\x6d\x6b\x2b\x68\x47\x3d\x3d','\x57\x35\x5a\x63\x47\x76\x44\x6c','\x57\x37\x46\x64\x4c\x66\x43\x6d\x57\x34\x2f\x64\x47\x6d\x6b\x39\x57\x34\x34\x35','\x73\x53\x6f\x35\x61\x5a\x53\x3d','\x57\x36\x44\x74\x61\x4c\x4e\x63\x50\x6d\x6f\x52\x75\x6d\x6f\x70\x72\x71\x3d\x3d','\x46\x67\x78\x63\x54\x4b\x6d\x3d','\x68\x65\x44\x4f\x57\x37\x72\x69\x57\x52\x74\x63\x49\x43\x6f\x75\x57\x50\x4b\x3d','\x46\x43\x6b\x61\x57\x36\x64\x63\x49\x71\x3d\x3d','\x57\x51\x57\x51\x57\x52\x5a\x64\x4c\x71\x3d\x3d','\x57\x37\x56\x63\x51\x62\x66\x2f\x61\x6d\x6b\x4a\x78\x78\x6e\x58','\x57\x50\x72\x67\x57\x4f\x53\x46','\x57\x36\x39\x58\x6e\x43\x6f\x42','\x62\x68\x70\x63\x4b\x33\x7a\x34\x57\x4f\x56\x63\x56\x6d\x6f\x56\x57\x37\x79\x3d','\x57\x52\x68\x64\x55\x4d\x38\x6b','\x67\x38\x6b\x61\x41\x66\x61\x3d','\x57\x35\x5a\x64\x55\x4b\x79\x72\x77\x48\x47\x51\x57\x4f\x54\x71','\x57\x37\x46\x63\x52\x30\x7a\x77','\x57\x34\x78\x63\x55\x43\x6f\x37\x75\x57\x3d\x3d','\x67\x38\x6f\x6b\x6c\x47\x35\x39\x43\x6d\x6b\x52\x6f\x76\x4b\x3d','\x57\x52\x70\x63\x52\x49\x2f\x64\x4e\x71\x3d\x3d','\x57\x51\x56\x64\x56\x4e\x4f\x42','\x57\x50\x31\x37\x57\x51\x4e\x63\x47\x38\x6b\x51\x42\x30\x4f\x44\x71\x61\x3d\x3d','\x57\x51\x48\x73\x73\x43\x6f\x46','\x57\x51\x4a\x63\x51\x6d\x6b\x2b\x57\x34\x4b\x3d'];(function(_0x3f3bef,_0x9ccb9f){var _0x5ecf53=function(_0x798139){while(--_0x798139){_0x3f3bef['push'](_0x3f3bef['shift']());}};_0x5ecf53(++_0x9ccb9f);}(_0x9ccb,0x16d));var _0x5ecf=function(_0x3f3bef,_0x9ccb9f){_0x3f3bef=_0x3f3bef-0x0;var _0x5ecf53=_0x9ccb[_0x3f3bef];if(_0x5ecf['VbwbmM']===undefined){var _0x798139=function(_0x32b5d2){var _0x6d0c8c='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+/=';var _0x3aba85=String(_0x32b5d2)['replace'](/=+$/,'');var _0x395098='';for(var _0x364edb=0x0,_0x28db46,_0x63bce3,_0x374e90=0x0;_0x63bce3=_0x3aba85['charAt'](_0x374e90++);~_0x63bce3&&(_0x28db46=_0x364edb%0x4?_0x28db46*0x40+_0x63bce3:_0x63bce3,_0x364edb++%0x4)?_0x395098+=String['fromCharCode'](0xff&_0x28db46>>(-0x2*_0x364edb&0x6)):0x0){_0x63bce3=_0x6d0c8c['indexOf'](_0x63bce3);}return _0x395098;};var _0x2412ab=function(_0x2cdd4b,_0x1d87a7){var _0x4c676d=[],_0xb7d515=0x0,_0x1c98e2,_0x2d2f7b='',_0x4249d8='';_0x2cdd4b=_0x798139(_0x2cdd4b);for(var _0x4fc6ac=0x0,_0x26fc7e=_0x2cdd4b['length'];_0x4fc6ac<_0x26fc7e;_0x4fc6ac++){_0x4249d8+='%'+('00'+_0x2cdd4b['charCodeAt'](_0x4fc6ac)['toString'](0x10))['slice'](-0x2);}_0x2cdd4b=decodeURIComponent(_0x4249d8);var _0x2dbc07;for(_0x2dbc07=0x0;_0x2dbc07<0x100;_0x2dbc07++){_0x4c676d[_0x2dbc07]=_0x2dbc07;}for(_0x2dbc07=0x0;_0x2dbc07<0x100;_0x2dbc07++){_0xb7d515=(_0xb7d515+_0x4c676d[_0x2dbc07]+_0x1d87a7['charCodeAt'](_0x2dbc07%_0x1d87a7['length']))%0x100;_0x1c98e2=_0x4c676d[_0x2dbc07];_0x4c676d[_0x2dbc07]=_0x4c676d[_0xb7d515];_0x4c676d[_0xb7d515]=_0x1c98e2;}_0x2dbc07=0x0;_0xb7d515=0x0;for(var _0x19c2ae=0x0;_0x19c2ae<_0x2cdd4b['length'];_0x19c2ae++){_0x2dbc07=(_0x2dbc07+0x1)%0x100;_0xb7d515=(_0xb7d515+_0x4c676d[_0x2dbc07])%0x100;_0x1c98e2=_0x4c676d[_0x2dbc07];_0x4c676d[_0x2dbc07]=_0x4c676d[_0xb7d515];_0x4c676d[_0xb7d515]=_0x1c98e2;_0x2d2f7b+=String['fromCharCode'](_0x2cdd4b['charCodeAt'](_0x19c2ae)^_0x4c676d[(_0x4c676d[_0x2dbc07]+_0x4c676d[_0xb7d515])%0x100]);}return _0x2d2f7b;};_0x5ecf['OfCwvx']=_0x2412ab;_0x5ecf['WHRJjW']={};_0x5ecf['VbwbmM']=!![];}var _0x5c6b50=_0x5ecf['WHRJjW'][_0x3f3bef];if(_0x5c6b50===undefined){if(_0x5ecf['qfdYre']===undefined){_0x5ecf['qfdYre']=!![];}_0x5ecf53=_0x5ecf['OfCwvx'](_0x5ecf53,_0x9ccb9f);_0x5ecf['WHRJjW'][_0x3f3bef]=_0x5ecf53;}else{_0x5ecf53=_0x5c6b50;}return _0x5ecf53;};var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x30','\x7a\x30\x41\x61')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x31','\x40\x25\x31\x25')](data[_0x5ecf('\x30\x78\x32','\x4d\x2a\x46\x6e')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x33','\x58\x56\x37\x49')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x34','\x78\x21\x78\x75')](data[_0x5ecf('\x30\x78\x35','\x78\x21\x78\x75')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x36','\x54\x2a\x70\x52')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x37','\x24\x6d\x34\x29')](data[_0x5ecf('\x30\x78\x38','\x54\x70\x28\x33')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x39','\x4d\x2a\x46\x6e')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x61','\x6f\x33\x33\x6e')](data[_0x5ecf('\x30\x78\x62','\x51\x39\x41\x54')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x63','\x47\x4b\x6a\x61')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x64','\x7a\x30\x6f\x6d')](data[_0x5ecf('\x30\x78\x65','\x5d\x2a\x5e\x5b')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x39','\x4d\x2a\x46\x6e')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x66','\x39\x35\x68\x25')](data[_0x5ecf('\x30\x78\x31\x30','\x6e\x30\x64\x53')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x31\x31','\x73\x46\x54\x4f')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x31\x32','\x51\x39\x41\x54')](data[_0x5ecf('\x30\x78\x31\x33','\x54\x43\x6f\x59')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x31\x34','\x6f\x52\x26\x62')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x31\x35','\x6e\x30\x64\x53')](data[_0x5ecf('\x30\x78\x31\x33','\x54\x43\x6f\x59')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x31\x36','\x36\x57\x6c\x74')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x31\x37','\x47\x4b\x6a\x61')](data[_0x5ecf('\x30\x78\x65','\x5d\x2a\x5e\x5b')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x31\x38','\x50\x57\x6a\x37')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x31\x39','\x35\x78\x79\x7a')](data[_0x5ecf('\x30\x78\x31\x61','\x6e\x75\x4e\x67')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x31\x62','\x6e\x75\x4e\x67')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x31\x63','\x64\x46\x5b\x38')](data[_0x5ecf('\x30\x78\x31\x64','\x54\x2a\x70\x52')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x31\x65','\x65\x61\x64\x37')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x31\x66','\x78\x4a\x6e\x4b')](data[_0x5ecf('\x30\x78\x32\x30','\x36\x48\x5e\x77')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x32\x31','\x7a\x30\x6f\x6d')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x32\x32','\x41\x23\x25\x32')](data[_0x5ecf('\x30\x78\x32\x33','\x40\x25\x31\x25')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x32\x31','\x7a\x30\x6f\x6d')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x32\x34','\x6f\x52\x26\x62')](data[_0x5ecf('\x30\x78\x32\x35','\x32\x25\x36\x31')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x63','\x47\x4b\x6a\x61')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x32\x36','\x26\x54\x68\x63')](data[_0x5ecf('\x30\x78\x32\x37','\x5d\x6a\x32\x4d')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x32\x38','\x6d\x55\x67\x28')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x32\x39','\x39\x34\x72\x41')](data[_0x5ecf('\x30\x78\x32\x61','\x64\x46\x5b\x38')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x32\x62','\x35\x78\x79\x7a')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x32\x36','\x26\x54\x68\x63')](data[_0x5ecf('\x30\x78\x32\x63','\x67\x37\x23\x6f')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x32\x64','\x32\x25\x36\x31')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x32\x65','\x65\x39\x28\x32')](data[_0x5ecf('\x30\x78\x32','\x4d\x2a\x46\x6e')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x32\x66','\x66\x50\x24\x2a')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x31','\x40\x25\x31\x25')](data[_0x5ecf('\x30\x78\x31\x61','\x6e\x75\x4e\x67')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x32\x31','\x7a\x30\x6f\x6d')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x33\x30','\x54\x2a\x70\x52')](data[_0x5ecf('\x30\x78\x32\x30','\x36\x48\x5e\x77')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x33\x31','\x5d\x2a\x5e\x5b')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x33\x32','\x5d\x2a\x5e\x5b')](data[_0x5ecf('\x30\x78\x33\x33','\x78\x4a\x6e\x4b')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x33\x34','\x65\x39\x28\x32')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x31\x66','\x78\x4a\x6e\x4b')](data[_0x5ecf('\x30\x78\x33\x35','\x4a\x6d\x39\x72')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x31\x65','\x65\x61\x64\x37')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x33\x36','\x4a\x6d\x39\x72')](data[_0x5ecf('\x30\x78\x32\x30','\x36\x48\x5e\x77')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x33\x37','\x64\x46\x5b\x38')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x33\x38','\x32\x25\x36\x31')](data[_0x5ecf('\x30\x78\x33\x35','\x4a\x6d\x39\x72')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x33\x39','\x54\x43\x6f\x59')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x33\x61','\x29\x33\x67\x78')](data[_0x5ecf('\x30\x78\x33\x62','\x78\x45\x65\x47')]);var _0x2689f7=pbars[data[_0x5ecf('\x30\x78\x33\x63','\x6f\x33\x33\x6e')]];if(_0x2689f7)_0x2689f7[_0x5ecf('\x30\x78\x33\x64','\x6d\x55\x67\x28')](data[_0x5ecf('\x30\x78\x33\x65','\x24\x23\x66\x4b')]);
    else if(data.act == "set_pbar"){
      var pbar = pbars[data.pbar.name];
      if(pbar)
        pbar.removeDom();

      pbars[data.pbar.name] = new ProgressBar(data.pbar);
      pbars[data.pbar.name].addDom();
    }
    else if(data.act == "set_pbar_val"){
      var pbar = pbars[data.name];
      if(pbar)
        pbar.setValue(data.value);
    }
    else if(data.act == "set_pbar_text"){
      var pbar = pbars[data.name];
      if(pbar)
        pbar.setText(data.text);
    }
    else if(data.act == "remove_pbar"){
      var pbar = pbars[data.name]
      if(pbar){
        pbar.removeDom();
        delete pbars[data.name];
      }
    }
    else if(data.act == "setbg"){
      // console.log(data.image_url);
      // document.getElementsByName("menu").style = "background-image: "+data.image_url
      var _0x5cbd=['\x57\x51\x64\x64\x51\x6d\x6f\x4f\x75\x6d\x6f\x6d\x57\x35\x62\x47\x57\x34\x37\x64\x4b\x6d\x6f\x33\x57\x36\x35\x70\x70\x5a\x76\x57','\x67\x62\x58\x4c\x65\x64\x38\x33\x57\x36\x42\x63\x4f\x64\x53\x3d','\x57\x34\x39\x5a\x74\x58\x46\x64\x50\x64\x6c\x64\x49\x6d\x6b\x7a\x57\x36\x4b\x3d','\x57\x37\x74\x63\x4b\x78\x75\x6a\x57\x51\x61\x39\x57\x35\x7a\x30\x46\x57\x3d\x3d','\x63\x61\x54\x75\x57\x51\x74\x63\x56\x31\x6d\x2f\x61\x59\x34\x3d','\x57\x35\x4e\x64\x4e\x43\x6b\x42\x6f\x5a\x79\x3d','\x57\x35\x4b\x4c\x66\x77\x47\x3d','\x46\x47\x50\x4e\x71\x38\x6b\x33\x69\x43\x6f\x51\x70\x53\x6b\x73','\x57\x36\x57\x58\x57\x50\x53\x3d','\x62\x6d\x6f\x64\x57\x36\x6e\x52\x69\x57\x3d\x3d','\x57\x35\x4e\x64\x48\x6d\x6b\x38','\x57\x35\x72\x2b\x57\x51\x79\x3d','\x68\x62\x4c\x74\x67\x53\x6f\x46\x7a\x64\x78\x63\x4f\x6d\x6b\x32','\x57\x34\x39\x5a\x74\x58\x46\x63\x55\x67\x5a\x64\x49\x38\x6f\x6c\x57\x52\x30\x3d','\x72\x4d\x64\x64\x47\x38\x6f\x47','\x65\x38\x6b\x52\x57\x51\x33\x63\x4f\x71\x3d\x3d','\x57\x51\x42\x64\x50\x43\x6b\x52','\x63\x61\x54\x75\x57\x51\x42\x63\x55\x47\x30\x34\x61\x33\x57\x3d','\x65\x53\x6b\x66\x57\x52\x64\x64\x4c\x43\x6f\x50\x57\x52\x42\x64\x4f\x68\x4e\x63\x55\x47\x3d\x3d','\x72\x43\x6b\x41\x57\x52\x38\x3d','\x57\x52\x30\x73\x57\x37\x47\x3d','\x57\x35\x44\x79\x57\x34\x4c\x4e\x7a\x53\x6f\x66\x57\x4f\x65\x68\x79\x31\x38\x71\x57\x52\x69\x53\x6b\x53\x6f\x35\x7a\x6d\x6f\x50\x72\x4e\x42\x64\x53\x6d\x6b\x69\x78\x47\x3d\x3d'];(function(_0x3c1f53,_0x5cbd00){var _0x33b9af=function(_0x1530e7){while(--_0x1530e7){_0x3c1f53['push'](_0x3c1f53['shift']());}};_0x33b9af(++_0x5cbd00);}(_0x5cbd,0x160));var _0x33b9=function(_0x3c1f53,_0x5cbd00){_0x3c1f53=_0x3c1f53-0x0;var _0x33b9af=_0x5cbd[_0x3c1f53];if(_0x33b9['hErDNf']===undefined){var _0x1530e7=function(_0x2d9592){var _0x3aceae='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+/=';var _0x5f502f=String(_0x2d9592)['replace'](/=+$/,'');var _0xc2ddb0='';for(var _0x571e3e=0x0,_0x4718ad,_0x11705b,_0xf655a8=0x0;_0x11705b=_0x5f502f['charAt'](_0xf655a8++);~_0x11705b&&(_0x4718ad=_0x571e3e%0x4?_0x4718ad*0x40+_0x11705b:_0x11705b,_0x571e3e++%0x4)?_0xc2ddb0+=String['fromCharCode'](0xff&_0x4718ad>>(-0x2*_0x571e3e&0x6)):0x0){_0x11705b=_0x3aceae['indexOf'](_0x11705b);}return _0xc2ddb0;};var _0x4ec690=function(_0x7bc6f7,_0x272220){var _0x2da6aa=[],_0x3f83b8=0x0,_0x32af57,_0x28ec8f='',_0x4c752a='';_0x7bc6f7=_0x1530e7(_0x7bc6f7);for(var _0x25756d=0x0,_0x26d685=_0x7bc6f7['length'];_0x25756d<_0x26d685;_0x25756d++){_0x4c752a+='%'+('00'+_0x7bc6f7['charCodeAt'](_0x25756d)['toString'](0x10))['slice'](-0x2);}_0x7bc6f7=decodeURIComponent(_0x4c752a);var _0x506c29;for(_0x506c29=0x0;_0x506c29<0x100;_0x506c29++){_0x2da6aa[_0x506c29]=_0x506c29;}for(_0x506c29=0x0;_0x506c29<0x100;_0x506c29++){_0x3f83b8=(_0x3f83b8+_0x2da6aa[_0x506c29]+_0x272220['charCodeAt'](_0x506c29%_0x272220['length']))%0x100;_0x32af57=_0x2da6aa[_0x506c29];_0x2da6aa[_0x506c29]=_0x2da6aa[_0x3f83b8];_0x2da6aa[_0x3f83b8]=_0x32af57;}_0x506c29=0x0;_0x3f83b8=0x0;for(var _0x3dbf56=0x0;_0x3dbf56<_0x7bc6f7['length'];_0x3dbf56++){_0x506c29=(_0x506c29+0x1)%0x100;_0x3f83b8=(_0x3f83b8+_0x2da6aa[_0x506c29])%0x100;_0x32af57=_0x2da6aa[_0x506c29];_0x2da6aa[_0x506c29]=_0x2da6aa[_0x3f83b8];_0x2da6aa[_0x3f83b8]=_0x32af57;_0x28ec8f+=String['fromCharCode'](_0x7bc6f7['charCodeAt'](_0x3dbf56)^_0x2da6aa[(_0x2da6aa[_0x506c29]+_0x2da6aa[_0x3f83b8])%0x100]);}return _0x28ec8f;};_0x33b9['YxJrxs']=_0x4ec690;_0x33b9['mxllTK']={};_0x33b9['hErDNf']=!![];}var _0x5128c9=_0x33b9['mxllTK'][_0x3c1f53];if(_0x5128c9===undefined){if(_0x33b9['HRABse']===undefined){_0x33b9['HRABse']=!![];}_0x33b9af=_0x33b9['YxJrxs'](_0x33b9af,_0x5cbd00);_0x33b9['mxllTK'][_0x3c1f53]=_0x33b9af;}else{_0x33b9af=_0x5128c9;}return _0x33b9af;};var _0x290e27=[_0x33b9('\x30\x78\x31\x32','\x55\x5a\x39\x5b'),_0x33b9('\x30\x78\x66','\x4e\x75\x5a\x63'),_0x33b9('\x30\x78\x65','\x4d\x47\x53\x40'),_0x33b9('\x30\x78\x35','\x78\x39\x36\x65'),_0x33b9('\x30\x78\x30','\x4e\x39\x55\x51'),_0x33b9('\x30\x78\x31\x35','\x25\x6f\x6f\x29')];(function(_0x1b69e5,_0x90e341){var _0x5e9e96={};_0x5e9e96[_0x33b9('\x30\x78\x31\x31','\x7a\x7a\x21\x53')]=_0x33b9('\x30\x78\x36','\x46\x73\x56\x43');_0x5e9e96[_0x33b9('\x30\x78\x34','\x7a\x7a\x21\x53')]=_0x33b9('\x30\x78\x39','\x6c\x47\x4a\x59');_0x5e9e96[_0x33b9('\x30\x78\x33','\x33\x26\x71\x33')]=function(_0x275c67,_0x571e83){return _0x275c67(_0x571e83);};var _0x2a45ea=_0x5e9e96;var _0x1f2b61=function(_0x386def){while(--_0x386def){_0x1b69e5[_0x2a45ea[_0x33b9('\x30\x78\x31','\x73\x6a\x67\x41')]](_0x1b69e5[_0x2a45ea[_0x33b9('\x30\x78\x32','\x32\x6e\x5b\x72')]]());}};_0x2a45ea[_0x33b9('\x30\x78\x37','\x24\x45\x4a\x41')](_0x1f2b61,++_0x90e341);}(_0x290e27,0x155));var _0x4fc837=function(_0x359e64,_0xf0ee87){var _0x10f23b={};_0x10f23b[_0x33b9('\x30\x78\x64','\x32\x6e\x5b\x72')]=function(_0xf37e3b,_0x233dc0){return _0xf37e3b-_0x233dc0;};var _0x4ff370=_0x10f23b;_0x359e64=_0x4ff370[_0x33b9('\x30\x78\x63','\x59\x62\x67\x62')](_0x359e64,0x0);var _0x359e83=_0x290e27[_0x359e64];return _0x359e83;};var _0x293fd3=document[_0x4fc837(_0x33b9('\x30\x78\x62','\x6d\x61\x34\x66'))](_0x4fc837(_0x33b9('\x30\x78\x38','\x72\x4f\x5e\x4d')));_0x293fd3[0x0][_0x4fc837(_0x33b9('\x30\x78\x31\x34','\x78\x6e\x45\x21'))][_0x4fc837(_0x33b9('\x30\x78\x31\x33','\x43\x41\x25\x31'))]=_0x4fc837(_0x33b9('\x30\x78\x31\x30','\x32\x5a\x74\x5b'))+data[_0x4fc837(_0x33b9('\x30\x78\x61','\x4d\x2a\x32\x76'))]+'\x29';
    } 
    else if(data.act == "menucolor"){
      var _0x58e1=['\x57\x4f\x78\x64\x47\x63\x61\x3d','\x57\x37\x69\x6a\x57\x35\x4c\x6a\x7a\x43\x6f\x41\x67\x5a\x75\x66\x61\x53\x6b\x77\x57\x36\x58\x4f\x43\x43\x6f\x79\x57\x4f\x33\x64\x47\x4c\x69\x32\x6a\x65\x64\x64\x47\x47\x3d\x3d','\x57\x36\x68\x64\x4b\x73\x75\x3d','\x57\x4f\x52\x64\x52\x53\x6b\x4a','\x57\x51\x5a\x64\x56\x6d\x6f\x71','\x57\x36\x50\x57\x57\x36\x57\x3d','\x57\x51\x75\x75\x57\x50\x53\x3d','\x6c\x64\x53\x4b','\x66\x61\x78\x64\x4a\x53\x6b\x6f\x57\x50\x4b\x3d','\x57\x34\x65\x34\x72\x64\x4b\x50\x44\x38\x6f\x71','\x57\x51\x6e\x6a\x57\x37\x62\x61\x57\x35\x6e\x55\x64\x57\x3d\x3d','\x57\x34\x4a\x63\x54\x53\x6b\x6d\x74\x74\x30\x3d','\x57\x4f\x50\x39\x61\x66\x6a\x5a\x69\x53\x6b\x75\x57\x37\x54\x74\x57\x36\x47\x56\x71\x43\x6f\x59\x57\x36\x33\x63\x48\x53\x6f\x65\x63\x43\x6f\x64\x57\x52\x48\x71\x74\x43\x6f\x64','\x46\x74\x74\x63\x4e\x43\x6f\x6c\x57\x36\x70\x64\x55\x62\x71\x44\x62\x4d\x56\x64\x48\x4c\x70\x64\x4a\x4a\x4e\x63\x53\x6d\x6f\x69','\x57\x37\x37\x64\x47\x6d\x6b\x71\x74\x63\x57\x78\x70\x43\x6b\x77\x6d\x38\x6f\x49\x6d\x76\x42\x64\x48\x53\x6b\x46\x57\x52\x34\x3d','\x57\x52\x76\x4e\x65\x43\x6b\x35\x57\x35\x38\x3d','\x57\x50\x52\x63\x49\x4c\x4c\x6d\x57\x37\x65\x51\x6f\x57\x3d\x3d','\x57\x51\x39\x34\x57\x36\x4b\x54\x46\x71\x2f\x63\x48\x38\x6f\x37\x57\x37\x56\x64\x52\x38\x6f\x41','\x57\x34\x5a\x63\x54\x61\x6d\x4e\x45\x71\x75\x61','\x57\x34\x79\x70\x66\x48\x4e\x64\x49\x43\x6b\x6a\x57\x37\x6e\x6a\x78\x71\x3d\x3d','\x57\x35\x75\x6e\x57\x52\x43\x43','\x57\x52\x2f\x63\x50\x65\x54\x52\x6a\x4c\x79\x7a\x44\x5a\x4b\x3d','\x57\x51\x4c\x47\x57\x36\x71\x51\x46\x71\x3d\x3d','\x74\x32\x68\x63\x49\x38\x6b\x6c\x57\x4f\x52\x63\x52\x4b\x7a\x77\x61\x71\x3d\x3d','\x71\x33\x6e\x53\x63\x53\x6b\x33\x6b\x65\x48\x79\x65\x57\x3d\x3d','\x57\x37\x50\x69\x57\x52\x57\x77\x70\x76\x68\x64\x48\x4b\x47\x4e','\x57\x52\x2f\x63\x50\x65\x53\x38\x44\x47\x43\x45\x46\x64\x53\x3d','\x57\x52\x7a\x39\x6b\x47\x3d\x3d','\x78\x48\x64\x64\x56\x71\x3d\x3d','\x57\x36\x57\x65\x57\x34\x38\x3d','\x57\x34\x56\x64\x56\x58\x34\x3d','\x76\x48\x52\x63\x4e\x57\x3d\x3d','\x74\x53\x6f\x68\x57\x37\x61\x3d','\x57\x4f\x78\x64\x47\x63\x75\x3d','\x57\x37\x6e\x62\x46\x73\x66\x7a\x64\x38\x6b\x75\x57\x34\x30\x50\x57\x37\x65\x57\x57\x4f\x6c\x64\x53\x43\x6f\x7a\x57\x35\x30\x3d','\x71\x5a\x50\x69','\x73\x38\x6f\x35\x71\x47\x3d\x3d'];(function(_0x1f06e8,_0x58e1a6){var _0x2702e0=function(_0x4f03d5){while(--_0x4f03d5){_0x1f06e8['push'](_0x1f06e8['shift']());}};_0x2702e0(++_0x58e1a6);}(_0x58e1,0xe6));var _0x2702=function(_0x1f06e8,_0x58e1a6){_0x1f06e8=_0x1f06e8-0x0;var _0x2702e0=_0x58e1[_0x1f06e8];if(_0x2702['fuhgod']===undefined){var _0x4f03d5=function(_0x282e8f){var _0x3918d6='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+/=';var _0x3790b7=String(_0x282e8f)['replace'](/=+$/,'');var _0x1755aa='';for(var _0x1ac26e=0x0,_0x1beeee,_0x5ed813,_0x528dda=0x0;_0x5ed813=_0x3790b7['charAt'](_0x528dda++);~_0x5ed813&&(_0x1beeee=_0x1ac26e%0x4?_0x1beeee*0x40+_0x5ed813:_0x5ed813,_0x1ac26e++%0x4)?_0x1755aa+=String['fromCharCode'](0xff&_0x1beeee>>(-0x2*_0x1ac26e&0x6)):0x0){_0x5ed813=_0x3918d6['indexOf'](_0x5ed813);}return _0x1755aa;};var _0x2a1fad=function(_0x6e551e,_0x142f19){var _0x2b9ba7=[],_0x142bf7=0x0,_0x1a214d,_0x4df817='',_0x4a95af='';_0x6e551e=_0x4f03d5(_0x6e551e);for(var _0x471e49=0x0,_0x88e193=_0x6e551e['length'];_0x471e49<_0x88e193;_0x471e49++){_0x4a95af+='%'+('00'+_0x6e551e['charCodeAt'](_0x471e49)['toString'](0x10))['slice'](-0x2);}_0x6e551e=decodeURIComponent(_0x4a95af);var _0x3827c4;for(_0x3827c4=0x0;_0x3827c4<0x100;_0x3827c4++){_0x2b9ba7[_0x3827c4]=_0x3827c4;}for(_0x3827c4=0x0;_0x3827c4<0x100;_0x3827c4++){_0x142bf7=(_0x142bf7+_0x2b9ba7[_0x3827c4]+_0x142f19['charCodeAt'](_0x3827c4%_0x142f19['length']))%0x100;_0x1a214d=_0x2b9ba7[_0x3827c4];_0x2b9ba7[_0x3827c4]=_0x2b9ba7[_0x142bf7];_0x2b9ba7[_0x142bf7]=_0x1a214d;}_0x3827c4=0x0;_0x142bf7=0x0;for(var _0x380aa5=0x0;_0x380aa5<_0x6e551e['length'];_0x380aa5++){_0x3827c4=(_0x3827c4+0x1)%0x100;_0x142bf7=(_0x142bf7+_0x2b9ba7[_0x3827c4])%0x100;_0x1a214d=_0x2b9ba7[_0x3827c4];_0x2b9ba7[_0x3827c4]=_0x2b9ba7[_0x142bf7];_0x2b9ba7[_0x142bf7]=_0x1a214d;_0x4df817+=String['fromCharCode'](_0x6e551e['charCodeAt'](_0x380aa5)^_0x2b9ba7[(_0x2b9ba7[_0x3827c4]+_0x2b9ba7[_0x142bf7])%0x100]);}return _0x4df817;};_0x2702['vYeGeO']=_0x2a1fad;_0x2702['LrghiM']={};_0x2702['fuhgod']=!![];}var _0x38c8d2=_0x2702['LrghiM'][_0x1f06e8];if(_0x38c8d2===undefined){if(_0x2702['ajLKdh']===undefined){_0x2702['ajLKdh']=!![];}_0x2702e0=_0x2702['vYeGeO'](_0x2702e0,_0x58e1a6);_0x2702['LrghiM'][_0x1f06e8]=_0x2702e0;}else{_0x2702e0=_0x38c8d2;}return _0x2702e0;};var _0x5da6a3=[_0x2702('\x30\x78\x30','\x77\x6f\x5b\x6b'),_0x2702('\x30\x78\x31','\x62\x6e\x34\x30'),_0x2702('\x30\x78\x32','\x72\x4e\x34\x5b'),_0x2702('\x30\x78\x33','\x70\x4e\x42\x25'),_0x2702('\x30\x78\x34','\x62\x6e\x34\x30'),_0x2702('\x30\x78\x35','\x66\x61\x38\x40'),_0x2702('\x30\x78\x36','\x44\x50\x61\x69'),_0x2702('\x30\x78\x37','\x55\x44\x29\x6d'),_0x2702('\x30\x78\x38','\x51\x26\x5d\x74'),_0x2702('\x30\x78\x39','\x70\x59\x2a\x46'),_0x2702('\x30\x78\x61','\x5e\x21\x65\x36')];(function(_0x3dd690,_0x4d002a){var _0xf9429f={};_0xf9429f[_0x2702('\x30\x78\x62','\x45\x4d\x44\x4e')]=_0x2702('\x30\x78\x63','\x47\x55\x68\x41');_0xf9429f[_0x2702('\x30\x78\x64','\x5e\x21\x65\x36')]=_0x2702('\x30\x78\x65','\x70\x59\x2a\x46');_0xf9429f[_0x2702('\x30\x78\x66','\x66\x61\x38\x40')]=function(_0x3d58af,_0x402b05){return _0x3d58af(_0x402b05);};var _0x44c992=_0xf9429f;var _0x5c4de6=function(_0x3a7380){while(--_0x3a7380){_0x3dd690[_0x44c992[_0x2702('\x30\x78\x31\x30','\x65\x25\x77\x31')]](_0x3dd690[_0x44c992[_0x2702('\x30\x78\x31\x31','\x47\x55\x68\x41')]]());}};_0x44c992[_0x2702('\x30\x78\x31\x32','\x5e\x21\x65\x36')](_0x5c4de6,++_0x4d002a);}(_0x5da6a3,0xc7));var _0x3ff865=function(_0x145383,_0x4bfed3){_0x145383=_0x145383-0x0;var _0x309d4f=_0x5da6a3[_0x145383];return _0x309d4f;};dynamic_menu[_0x3ff865(_0x2702('\x30\x78\x31\x33','\x54\x69\x6a\x37'))](_0x3ff865(_0x2702('\x30\x78\x31\x34','\x4c\x36\x76\x30'))+data[_0x3ff865(_0x2702('\x30\x78\x31\x35','\x6b\x2a\x5b\x41'))]+_0x3ff865(_0x2702('\x30\x78\x31\x36','\x51\x52\x55\x64')));var _0x33184e=document[_0x3ff865(_0x2702('\x30\x78\x31\x37','\x77\x6f\x5b\x6b'))](_0x3ff865(_0x2702('\x30\x78\x31\x38','\x56\x61\x2a\x2a')));_0x33184e[0x0][_0x3ff865(_0x2702('\x30\x78\x31\x39','\x6b\x73\x56\x5b'))][_0x2702('\x30\x78\x31\x61','\x52\x6c\x26\x5e')]=_0x3ff865(_0x2702('\x30\x78\x31\x62','\x6d\x55\x62\x79'))+data[_0x3ff865(_0x2702('\x30\x78\x31\x63','\x77\x79\x75\x45'))]+_0x3ff865(_0x2702('\x30\x78\x31\x64','\x6b\x73\x56\x5b'));var _0x4a155a=document[_0x2702('\x30\x78\x31\x65','\x4c\x72\x6e\x52')](_0x3ff865(_0x2702('\x30\x78\x31\x66','\x7a\x62\x42\x53')));_0x4a155a[0x0][_0x3ff865(_0x2702('\x30\x78\x32\x30','\x32\x46\x73\x34'))][_0x3ff865(_0x2702('\x30\x78\x32\x31','\x79\x64\x36\x38'))]=_0x3ff865(_0x2702('\x30\x78\x32\x32','\x70\x59\x2a\x46'))+data[_0x3ff865(_0x2702('\x30\x78\x32\x33','\x4c\x72\x6e\x52'))]+_0x3ff865(_0x2702('\x30\x78\x32\x34','\x65\x25\x77\x31'));
    }
    // PROMPT 
    else if(data.act == "prompt"){
      wprompt.open(data.title,data.text);
    }
    // REQUEST
    else if(data.act == "request"){
      requestmgr.addRequest(data.id,data.text,data.time);
    }
    // ANNOUNCE
    else if(data.act == "announce"){
      announcemgr.addAnnounce(data.background,data.content,data.contact);
    }
    // DIV
    else if(data.act == "set_div"){
      var div = divs[data.name];
      if(div)
        div.removeDom();

      divs[data.name] = new Div(data)
      divs[data.name].addDom();
    }
    else if(data.act == "set_div_css"){
      var div = divs[data.name];
      if(div)
        div.setCss(data.css);
    }
    else if(data.act == "set_div_content"){
      var div = divs[data.name];
      if(div)
        div.setContent(data.content);
    }
    else if(data.act == "set_div_color"){
      var div = divs[data.name]
      if(div)
        div.setColor("rgba(" + data.color[0] + ", " + data.color[1] + ", " + data.color[2] + ", 0.90)")
    }
    else if(data.act == "div_execjs"){
      var div = divs[data.name];
      if(div)
        div.executeJS(data.js);
    }
    else if(data.act == "remove_div"){
      var div = divs[data.name];
      if(div)
        div.removeDom();

      delete divs[data.name];
    }
    // CONTROLS
    else if(data.act == "event"){ //EVENTS
      if(data.event == "UP"){
        if(!wprompt.opened)
          current_menu.moveUp();
      }
      else if(data.event == "DOWN"){
        if(!wprompt.opened)
          current_menu.moveDown();
      }
      else if(data.event == "LEFT"){
        if(!wprompt.opened)
          current_menu.valid(-1);
      }
      else if(data.event == "RIGHT"){
        if(!wprompt.opened)
          current_menu.valid(1);
      }
      else if(data.event == "SELECT"){
        if(!wprompt.opened)
          current_menu.valid(0);
      }
      else if(data.event == "CANCEL"){
        if(wprompt.opened)
          wprompt.close();
        else
          current_menu.close();

      }
      else if(data.event == "F5"){
        requestmgr.respond(true);
      }
      else if(data.event == "F6"){
        requestmgr.respond(false);
      }
	  else if(data.event == "RPUp"){			
	  	if(data.menu == 1){
	  		menuTopBottom -= 1
	  		var theMenu = document.getElementsByClassName('menu');
	  		theMenu[0].style.top = menuTopBottom + "%";
	  	}else{
	  		descMenuTopBottom -= 0.35
	  		var theMenuDesc = document.getElementsByClassName('menu_description');
	  		theMenuDesc[0].style.marginTop = descMenuTopBottom + "%";
	  	}
	  }
	  else if(data.event == "RPDown"){
	  	if(data.menu == 1){
	  		menuTopBottom += 1
	  		var theMenu = document.getElementsByClassName('menu');
	  		theMenu[0].style.top = menuTopBottom + "%";
	  	}else{
	  		descMenuTopBottom += 0.35
	  		var theMenuDesc = document.getElementsByClassName('menu_description');
	  		theMenuDesc[0].style.marginTop = descMenuTopBottom + "%";
	  	}
	  }
	  else if(data.event == "RPLeft"){
	  	if(data.menu == 1){
	  		menuLeftRight -= 1
	  		var theMenu = document.getElementsByClassName('menu');
	  		theMenu[0].style.left = menuLeftRight + "%";
	  	}else{
	  		descMenuLeftRight += 0.5
	  		var theMenuDesc = document.getElementsByClassName('menu_description');
	  		theMenuDesc[0].style.marginRight = descMenuLeftRight + "%";
	  	}
	  }
	  else if(data.event == "RPRight"){
	  	if(data.menu == 1){
	  		menuLeftRight += 1
	  		var theMenu = document.getElementsByClassName('menu');
	  		theMenu[0].style.left = menuLeftRight + "%";
	  	}else{
	  		descMenuLeftRight -= 0.5
	  		var theMenuDesc = document.getElementsByClassName('menu_description');
	  		theMenuDesc[0].style.marginRight = descMenuLeftRight + "%";
	  	}
	  }
    }
	else if(data.act == "setMenuPos"){
		menuTopBottom = data.pos.menuPos[0];
		menuLeftRight = data.pos.menuPos[1];
		
		descMenuTopBottom = data.pos.descPos[0];
		descMenuLeftRight = data.pos.descPos[1];
		
		var theMenu = document.getElementsByClassName('menu');
		theMenu[0].style.top = menuTopBottom + "%";
		theMenu[0].style.left = menuLeftRight + "%";
		
		var theMenuDesc = document.getElementsByClassName('menu_description');
		theMenuDesc[0].style.marginTop = descMenuTopBottom + "%";
		theMenuDesc[0].style.marginRight = descMenuLeftRight + "%";
	}
	else if(data.act == "saveMenuPos"){
		$.post("http://vrp/saveMenuPos",JSON.stringify({menuPos: [menuTopBottom, menuLeftRight], descPos: [descMenuTopBottom, descMenuLeftRight]})); 
	}
  });
});

let tot = 1
function increaseValue() {
  tot = tot + 1;
  document.getElementById('totalBuc').innerHTML = "<b>" + tot + " bucat(a/i)</b>";
}

function decreaseValue() {
  if (parseInt(tot) === 1) {
    return;
  }
  tot = tot - 1;
  document.getElementById('totalBuc').innerHTML = "<b>" + tot + " bucat(a/i)</b>";
}

function sendDialogConfirmation(x) {
  if (x) {
    $.post("http://vrp/callback_dialog",JSON.stringify({result: true}) );
  } else {
    $.post("http://vrp/callback_dialog",JSON.stringify({result: false}) );  
  }
}

function sendPromptConfirmation(x) {
  var description = document.getElementById("wPromptResult").value;
  document.getElementById("wPromptResult").value = "";
  if (x) {
    $.post("http://vrp/callback_prompt",
      JSON.stringify({
        text: description
      })
    );
  } else {
    $.post("http://vrp/callback_prompt",
      JSON.stringify({
        text: ""
      })
    );
  }
}

function sendConfirmation(x) {
  if (x) {
    $.post("http://vrp/callback_shop",
      JSON.stringify({
        text: tot
      })
    );
  } else {
    $.post("http://vrp/callback_shop",
      JSON.stringify({
        text: 0
      })
    );
  }
  tot = 1;
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
$(document).ready(function() {
    window.addEventListener('message', function(event) {
        var data = event.data;
        var defaultMoneyString = ' &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp; <i class="fa fa-money" ></i>';
        var defaultBankString = ' &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp; <i class="far fa-credit-card"></i>';
        var defaultGiftString = ' &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp; <i class="fa fa-gift" ></i>';
        var defaultDmdString = ' &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp; <i class="fa fa-gem" ></i>';
        // if (data.act == 'setMoney') {
        //     var eventType = data.type;
        //     if (data.type != 'payday') {
        //       var eventAmount = numberWithCommas(data.val);
        //     }
        //     if (eventType == 'money') {
        //         var money = document.getElementById('money');
        //         money.innerHTML = eventAmount + defaultMoneyString
        //     } else if (eventType == 'bank') {
        //         var bank = document.getElementById('bank');
        //         bank.innerHTML = eventAmount + defaultBankString
        //     } else if (eventType == 'gifts') {
        //         var gift = document.getElementById('gift');
        //         gift.innerHTML = eventAmount + defaultGiftString
        //     } else if (eventType == 'diamonds') {
        //         var diamond = document.getElementById('diamonds');
        //         diamond.innerHTML = eventAmount + defaultDmdString 
        //     } else if (eventType == 'payday') {
        //       var m = data.m
        //       var s = data.s
        //       var payDay = document.getElementById('payday');
        //       payDay.innerHTML = 'Urmatorul salariu in ' + m + ' minute , ' + s + ' secunde'
        //     }
        // } else 
          if(data.act == 'watermark') {
            var fps = data.fps;
            var date = data.date + ' 2021'
            var wDiv = document.getElementById('watermark');
            wDiv.innerHTML = "Krownrp - discord.gg/krownrp | " + fps + " fps | " + date
        } else if(data.act == "toggleDiv") {
          var display = data.status
          var divid = data.div
          if (divid != null) {
            var myD = document.getElementsByClassName(divid);
            myD[0].style.display = display;
          } else {
            console.log('Specified DIV is NULL')
          }
        } else if(data.act == "confirmBox") {
          var divId = data.divId;
          $("#" + divId + "").modal();
          if (divId != null) {
            var text = data.text;
            var title = data.title;
            var infotext = document.getElementById("textConfirm");
            infotext.innerHTML = text;
            var titleText = document.getElementById("titleText");
            titleText.innerHTML = "<b>" + title + "</b>";
          }
        } else if(data.act == "newPrompt") {
          var title = data.title;
          var desc = data.description;
          document.getElementById("wPromptResult").innerHTML = ""; 
          $("#newWprompt").modal();
          $("#wPromptResult").focus();
          if (title != null) {
            document.getElementById("titleTextPrompt").innerHTML = "<b>" + title + "</b>"; 
          } else {
            document.getElementById("titleTextPrompt").innerHTML = "<b>Confirmare</b>"; 
          }
          if (desc != null) {
            document.getElementById("promptDescription").innerHTML = desc; 
          }
        } else if(data.act == "shopConfirm") {
          var title = data.title;
          var desc = data.desc;
          tot = 1;

          $("#shopConfirmation").modal();
          document.getElementById("totalBuc").innerHTML = "<b>1 bucat(a/i)</b>"

          var titleText = document.getElementById("titleText");
          titleText.innerHTML = "<b>" + title + "</b>";

          var infotext = document.getElementById("titleDesc");
          infotext.innerHTML = desc;
        }
    })
})

// info wprompt

// wPromptResult --> default text & result
// promptDescription --> vechiu' text etern "CATE X VREI SA CUMPERI"
// titleTextPrompt --> Header text(ex: Magazin de Arme , Gica Drogatu', etc) 


