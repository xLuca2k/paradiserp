local lang = vRP.lang
local cfg = module("cfg/phone")
local htmlEntities = module("lib/htmlEntities")
local services = cfg.services

local sanitizes = module("cfg/sanitizes")

function vRP.sendServiceAlert(sender, service_name,x,y,z,msg)
  local service = services[service_name]
  local answered = false
  if service then
    local players = {}
    for k,v in pairs(vRP.rusers) do
      local player = vRP.getUserSource(tonumber(k))
      -- check user
    if(service_name == "Politia Romana") and player   then
      if(vRP.hasGroup(tonumber(k),"onduty") and vRP.isUserInFaction(tonumber(k), "Politie"))then
        table.insert(players,player)
    end
		elseif(service_name == "Hitman") and player   then
			if(vRP.hasGroup(tonumber(k),"onduty") and vRP.isUserInFaction(tonumber(k), "Hitman"))then
				table.insert(players,player)
		end
  elseif(service_name == "Taxi") and player   then
    if(vRP.hasGroup(tonumber(k),"onduty") and vRP.isUserInFaction(tonumber(k), "Taxi"))then
      table.insert(players,player)
  end
  elseif(service_name == "Mecanic") and player   then
    if(vRP.hasGroup(tonumber(k),"onduty") and vRP.isUserInFaction(tonumber(k), "Mecanic"))then
      table.insert(players,player)
  end
		elseif(service_name == "Smurd") and player   then
			if(vRP.hasGroup(tonumber(k),"onduty") and vRP.isUserInFaction(tonumber(k), "Smurd"))then
				table.insert(players,player)
			end
		else
      if vRP.hasPermission(k,service.alert_permission) and player   then
        table.insert(players,player)
      end
    end
  end

    for k,v in pairs(players) do
      vRPclient.notify(v,{service.alert_notify..msg})
      vRPclient.addBlip(v,{x,y,z,service.blipid,service.blipcolor,"Apel Smurd"}, function(bid)
        SetTimeout(service.alert_time*1000,function()
          vRPclient.removeBlip(v,{bid})
        end)
      end)

      if sender   then
        local name = vRP.getPlayerName(sender)
        vRP.request(v,lang.phone.service.ask_call({service_name, name, htmlEntities.encode(msg)}), 30, function(v,ok)
          if ok then 
            if not answered then
              vRPclient.notify(sender,{service.answer_notify})
              vRPclient.setGPS(v,{x,y})
              answered = true
            else
              vRPclient.notify(v,{lang.phone.service.taken()})
            end
          end
        end)
      end
    end
  end
end

local phone_menu = {name=lang.phone.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}

local service_menu = {name=lang.phone.service.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}

service_menu.onclose = function(player) vRP.openMenu(player, phone_menu) end

local function ch_service_alert(player,choice)
  local service = services[choice]
  if service then
    vRPclient.getPosition(player,{},function(x,y,z)
      vRP.prompt(player,lang.phone.service.prompt(),"",function(player, msg)
			  msg = sanitizeString(msg,sanitizes.text[1],sanitizes.text[2])
	  	  if msg   and msg ~= "" then
          TriggerClientEvent('playPhoneAnim',player)
			    vRPclient.notify(player,{service.notify})
			    vRP.sendServiceAlert(player,choice,x,y,z,msg)
		    else
			    vRPclient.notify(player,{"Eroare: ~r~Mesaj gol."})
	      end
      end)
    end)
  end
end

for k,v in pairs(services) do
  service_menu[k] = {ch_service_alert}
end

local function ch_service(player, choice)
  vRP.openMenu(player,service_menu)
end

local announce_menu = {name=lang.phone.announce.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}

announce_menu.onclose = function(player) vRP.openMenu(player, phone_menu) end

local function ch_announce_alert(player,choice)
  local cooldown = {}
  local announce = announces[choice]
  local user_id = vRP.getUserId(player)
  if announce and user_id   then
    if announce.permission == nil or vRP.hasPermission(user_id,announce.permission) then
      vRP.prompt(player,lang.phone.announce.prompt(),"",function(player, msg)
        msg = sanitizeString(msg,sanitizes.text[1],sanitizes.text[2])
        if string.len(msg) > 10 and string.len(msg) < 500 then
          if announce.price <= 0 or vRP.tryPayment(user_id, announce.price) then
            vRPclient.notify(player, {lang.money.paid({announce.price})})

            msg = htmlEntities.encode(msg)
            msg = string.gsub("["..user_id.."] "..msg, "\n", "<br />")

            local users = vRP.getUsers()
            for k,v in pairs(users) do
              vRPclient.announce(v,{announce.image,msg})
            end
          else
            vRPclient.notify(player, {lang.money.not_enough()})
          end
        else
          vRPclient.notify(player, {lang.common.invalid_value()})
        end
      end)
    else
      vRPclient.notify(player, {lang.common.not_allowed()})
    end
  end
end

local function ch_announce_alert_police(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id   then
    if vRP.hasGroup(user_id,"onduty") then
    if vRP.isUserInFaction(user_id,"Politia Romana") or vRP.isUserInFaction(user_id,"S.I.A.S") or vRP.isUserInFaction(user_id,"SRI") then
      vRP.prompt(player,"Anuntul tau:","",function(player, msg)
        msg = sanitizeString(msg,sanitizes.text[1],sanitizes.text[2])
        if string.len(msg) > 1 and string.len(msg) < 1000 then

            msg = htmlEntities.encode(msg)
            msg = string.gsub("["..user_id.."] ["..vRP.getPlayerName(player).."] : "..msg, "\n", "<br />")

            local users = vRP.getUsers()
            for k,v in pairs(users) do
              vRPclient.announce(v,{"http://i.imgur.com/DY6DEeV.png",msg})
            end
        else
          vRPclient.notify(player, {lang.common.invalid_value()})
        end
      end)
    else
      vRPclient.notify(player, {"Eroare: Esti Off Duty Nu Ai Acces"})
    end
    else
      vRPclient.notify(player, {lang.common.not_allowed()})
    end
  end
end

local function ch_announce_alert_hitman(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id   then
    if vRP.hasGroup(user_id,"onduty") and vRP.isUserInFaction(user_id,"Hitman") then
      vRP.prompt(player,"Anuntul tau:","",function(player, msg)
        msg = sanitizeString(msg,sanitizes.text[1],sanitizes.text[2])
        if string.len(msg) > 1 and string.len(msg) < 1000 then

            msg = htmlEntities.encode(msg)
            msg = string.gsub("["..user_id.."] ["..vRP.getPlayerName(player).."] : "..msg, "\n", "<br />")

            local users = vRP.getUsers()
            for k,v in pairs(users) do
              vRPclient.announce(v,{"https://i.imgur.com/wfw2JBT.png",msg})
            end
        else
          vRPclient.notify(player, {lang.common.invalid_value()})
        end
      end)
    else
      vRPclient.notify(player, {lang.common.not_allowed()})
    end
  end
end

local function ch_announce(player, choice)
  vRP.openMenu(player,announce_menu)
end

local function ch_anunturi(player, choice)
    vRP.openMenu(source,anunturi_menu) 
end

local defaultBG = "https://i.imgur.com/5DsKDBE.jpg"
local resetBG = "https://i.imgur.com/5DsKDBE.jpg"
local defaultColor = "0, 166, 255"

RegisterServerEvent("saveMenuPos")
AddEventHandler("saveMenuPos",function(menuTopBottom,menuLeftRight)
    local user_id = vRP.getUserId(source)
    exports.oxmysql:query("UPDATE vrp_users SET menuTopBottom=@menuTopBottom,menuLeftRight=@menuLeftRight WHERE id = @id",{['id'] = user_id, ['menuTopBottom'] = menuTopBottom, ['menuLeftRight'] = menuLeftRight}, function() end)
end)

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	Debug.pbegin("playerSpawned_player_state")
	local data = vRP.getUserDataTable(user_id)
	local tmp = vRP.getUserTmpTable(user_id)
	if first_spawn then
		exports.oxmysql:query("SELECT * FROM vrp_users WHERE id = @user_id",{["user_id"] = user_id}, function(rows)
			if #rows > 0 then
    			local menuTopBottom = rows[1].menuTopBottom
    			local menuLeftRight = rows[1].menuLeftRight
    			vRPclient.setPhonePos(source,{menuTopBottom,menuLeftRight})
			end
		end)
	end
	Debug.pend()
end)