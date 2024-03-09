local lang = vRP.lang
local cfg = module("cfg/homes")

local components = {}

-- cbreturn user address (home and number) or nil
function vRP.getUserAddress(user_id, cbr)
  local task = Task(cbr)
  
  local rows = exports.oxmysql:executeSync("SELECT * FROM vrp_user_homes WHERE user_id = @user_id", {user_id = user_id})
  if #rows > 0 then
    data = {home = rows[1].home, number = rows[1].number}
    task({data})
  else
    task()
  end
end

-- set user address
function vRP.setUserAddress(user_id,home,number)
  exports.oxmysql:query("REPLACE INTO vrp_user_homes(user_id,home,number) VALUES(@user_id,@home,@number)", {user_id = user_id, home = home, number = number}, function()end)
end

-- remove user address
function vRP.removeUserAddress(user_id)
  exports.oxmysql:query("DELETE FROM vrp_user_homes WHERE user_id = @user_id", {user_id = user_id}, function()end)
end

function vRP.sellHomeToPlayer(user_id, oldUser, home, number)
	exports.oxmysql:query("UPDATE vrp_user_homes SET user_id = @user_id WHERE user_id = @oldUser AND home = @home AND number = @number", {user_id = user_id, oldUser = oldUser, home = home, number = number}, function()end)
end

-- cbreturn user_id or nil
function vRP.getUserByAddress(home,number,cbr)
  local task = Task(cbr)

  local rows = exports.oxmysql:executeSync("SELECT user_id FROM vrp_user_homes WHERE home = @home AND number = @number", {home = home, number = number})
  if #rows > 0 then
    task({rows[1].user_id})
  else
    task()
  end
end

-- find a free address number to buy
-- cbreturn number or nil if no numbers availables
function vRP.findFreeNumber(home,max,cbr)
  local task = Task(cbr)

  local i = 1
  local function search()
    vRP.getUserByAddress(home,i,function(user_id)
      if user_id == nil then -- found
        task({i})
      else -- not found
        i = i+1
        if i <= max then -- continue search
          search()
        else -- global not found
          task()
        end
      end
    end)
  end

  search()
end

-- define home component
-- name: unique component id
-- oncreate(owner_id, slot_type, slot_id, cid, config, x, y, z, player)
-- ondestroy(owner_id, slot_type, slot_id, cid, config, x, y, z, player)
function vRP.defHomeComponent(name, oncreate, ondestroy)
  components[name] = {oncreate,ondestroy}
end

-- SLOTS

-- used (or not) slots
local uslots = {}
for k,v in pairs(cfg.slot_types) do
  uslots[k] = {}
  for l,w in pairs(v) do
    uslots[k][l] = {used=false}
  end
end

-- return slot id or nil if no slot available
local function allocateSlot(stype)
  local slots = cfg.slot_types[stype]
  if slots then
    local _uslots = uslots[stype]
    -- search the first unused slot
    for k,v in pairs(slots) do
      if _uslots[k] and not _uslots[k].used then
        _uslots[k].used = true -- set as used
        return k  -- return slot id
      end
    end
  end

  return nil
end

-- free a slot
local function freeSlot(stype, id)
  local slots = cfg.slot_types[stype]
  if slots then
    uslots[stype][id] = {used = false} -- reset as unused
  end
end

-- get in use address slot (not very optimized yet)
-- return slot_type, slot_id or nil,nil
local function getAddressSlot(home_name,number)
  for k,v in pairs(uslots) do
    for l,w in pairs(v) do
      if w.home_name == home_name and tostring(w.home_number) == tostring(number) then
        return k,l
      end
    end
  end

  return nil,nil
end

-- builds

local function is_empty(table)
  for k,v in pairs(table) do
    return false
  end

  return true
end

-- leave slot
local function leave_slot(user_id,player,stype,sid) -- called when a player leave a slot
  print("ID: "..user_id.." a iesit din casa la interfon "..stype.." "..sid)
  local slot = uslots[stype][sid]
  local home = cfg.homes[slot.home_name]

  -- record if inside a home slot
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    tmp.home_stype = nil
    tmp.home_sid = nil
  end

  -- teleport to home entry point (outside)
  vRPclient.teleport(player, home.entry_point) -- already an array of params (x,y,z)

  -- uncount player
  slot.players[user_id] = nil

  -- destroy loaded components and special entry component
  for k,v in pairs(cfg.slot_types[stype][sid]) do
    local name,x,y,z = table.unpack(v)

    if name == "entry" then
      -- remove marker/area
      local nid = "vRP:home:slot"..stype..sid
      vRPclient.removeNamedMarker(player,{nid})
      vRP.removeArea(player,nid)
    else
      local component = components[v[1]]
      if component then
        -- ondestroy(owner_id, slot_type, slot_id, cid, config, x, y, z, player)
        component[2](slot.owner_id, stype, sid, k, v._config or {}, x, y, z, player)
      end
    end
  end

  if is_empty(slot.players) then -- free the slot
    print("free slot "..stype.." "..sid)
    freeSlot(stype,sid)
  end
end

-- enter slot
local function enter_slot(user_id,player,stype,sid) -- called when a player enter a slot
  print("ID: "..user_id.." a intrat in casa la interfon "..stype.." "..sid)
  local slot = uslots[stype][sid]
  local home = cfg.homes[slot.home_name]

  -- record inside a home slot
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    tmp.home_stype = stype
    tmp.home_sid = sid
  end

  -- count
  slot.players[user_id] = player

  -- build the slot entry menu
  local menu = {name=slot.home_name,css={top="75px",header_color="rgba(0,255,125,0.75)"}}
  menu[lang.home.slot.leave.title()] = {function(player,choice) -- add leave choice
    leave_slot(user_id,player,stype,sid)
  end}

  vRP.getUserAddress(user_id, function(address)
    -- check if owner
    if address   and address.home == slot.home_name and tostring(address.number) == slot.home_number then
      menu[lang.home.slot.ejectall.title()] = {function(player,choice) -- add eject all choice
        -- copy players before calling leave for each (iteration while removing)
        local copy = {}
        for k,v in pairs(slot.players) do
          copy[k] = v
        end

        for k,v in pairs(copy) do
          leave_slot(k,v,stype,sid)
        end
      end,lang.home.slot.ejectall.description()}
    end

    -- build the slot entry menu marker/area

    local function entry_enter(player,area)
      vRP.openMenu(player,menu)
    end

    local function entry_leave(player,area)
      vRP.closeMenu(player)
    end

    -- build components and special entry component
    for k,v in pairs(cfg.slot_types[stype][sid]) do
      local name,x,y,z = table.unpack(v)

      if name == "entry" then
        -- teleport to the slot entry point
        vRPclient.teleport(player, {x,y,z}) -- already an array of params (x,y,z)

        local nid = "vRP:home:slot"..stype..sid
        vRPclient.setNamedMarker(player,{nid,x,y,z-1,0.7,0.7,0.5,0,255,125,125,150})
        vRP.setArea(player,nid,x,y,z,1,1.5,entry_enter,entry_leave)
      else -- load regular component
        local component = components[v[1]]
        if component then
          -- oncreate(owner_id, slot_type, slot_id, cid, config, x, y, z, player)
          component[1](slot.owner_id, stype, sid, k, v._config or {}, x, y, z, player)
        end
      end
    end
  end)
end

-- access a home by address
-- cbreturn true on success
function vRP.accessHome(user_id, home, number)
	local _home = cfg.homes[home]
	local stype,slotid = getAddressSlot(home,number) -- get current address slot
	local player = vRP.getUserSource(user_id)

	vRP.getUserByAddress(home,number, function(owner_id)
		if _home   and player   then
			if stype == nil then -- allocate a new slot
				stype = _home.slot
				slotid = allocateSlot(_home.slot)

				if slotid   then -- allocated, set slot home infos
					local slot = uslots[stype][slotid]
					slot.home_name = home
					slot.home_number = number
					slot.owner_id = owner_id
					slot.players = {} -- map user_id => player
				end
			end

			if slotid   then -- slot available
				enter_slot(user_id,player,stype,slotid)
				return true
			end
		end
	end)
end

-- build the home entry menu
local function build_entry_menu(user_id, home_name)
  local home = cfg.homes[home_name]
  local menu = {name=home_name,css={top="75px",header_color="rgba(0,255,125,0.75)"}}

  -- intercom, used to enter in a home
  menu[lang.home.intercom.title()] = {function(player,choice)
    vRP.prompt(player, lang.home.intercom.prompt(), "", function(player,number)
      number = parseInt(number)
      vRP.getUserByAddress(home_name,number,function(huser_id)
        if huser_id   then
          if huser_id == user_id then -- identify owner (direct home access)
            if not vRP.accessHome(user_id, home_name, number) == true then
              vRPclient.notify(player,{lang.home.intercom.not_available()})
            end
          else -- try to access home by asking owner
            local hplayer = vRP.getUserSource(huser_id)
            if hplayer   then
              vRP.prompt(player,lang.home.intercom.prompt_who(),"",function(player,who)
                vRPclient.notify(player,{lang.home.intercom.asked()})
                -- request owner to open the door
                vRP.request(hplayer, lang.home.intercom.request({who}), 30, function(hplayer,ok)
                  if ok then
                    vRP.accessHome(user_id, home_name, number)
                  else
                    vRPclient.notify(player,{lang.home.intercom.refused()})
                  end
                end)
              end)
            else
              vRPclient.notify(player,{lang.home.intercom.refused()})
            end
          end
        else
          vRPclient.notify(player,{lang.common.not_found()})
        end
      end)
    end)
  end,lang.home.intercom.description()}

  menu[lang.home.buy.title()] = {function(player,choice)
    vRP.getUserAddress(user_id, function(address)
      if address == nil then -- check if not already have a home
        vRP.findFreeNumber(home_name, home.max, function(number)
          if number   then
            if vRP.tryPayment(user_id, home.buy_price) then
              -- bought, set address
				      vRP.setUserAddress(user_id, home_name, number)
				      vRPclient.notify(player,{lang.home.buy.bought()})
            else
              vRPclient.notify(player,{lang.money.not_enough()})
            end
          else
            vRPclient.notify(player,{lang.home.buy.full()})
          end
        end)
      else
        vRPclient.notify(player,{lang.home.buy.have_home()})
      end
    end)
  end, lang.home.buy.description({vRP.formatMoney(home.buy_price)})}

  menu[lang.home.sell.title()] = {function(player,choice)
    vRP.prompt(player, "Esti sigur?", "[STERGE si scrie 'Da' pentru a vinde casa]", function(player,answer)
      answer = tostring(answer)
      if(string.lower(answer) == "da")then
        vRP.getUserAddress(user_id, function(address)
          if address   and address.home == home_name then -- check if already have a home
            -- sold, give sell price, remove address
            vRP.giveMoney(user_id, home.sell_price)
            vRP.removeUserAddress(user_id)
            vRPclient.notify(player,{lang.home.sell.sold()})
          else
            vRPclient.notify(player,{lang.home.sell.no_home()})
          end
        end)
      else
        vRPclient.notify(player, {"~r~Trebuie sa scrii 'Da' pentru a vinde casa!"})
      end
    end)
  end, lang.home.sell.description({home.sell_price})}

	menu["Vinde Casa Unui Jucator"] = {function(player,choice)
		if player   then
			vRPclient.getNearestPlayers(player,{15},function(nplayers)
				vRP.getUserAddress(user_id, function(address)
					if address   then
						usrList = ""
						for k,v in pairs(nplayers) do
							usrList = usrList .. "[" .. vRP.getUserId(k) .. "]" .. vRP.getPlayerName(k) .. " | "
						end
						if usrList ~= "" then
							vRP.prompt(player,"Jucatori Apropiati: " .. usrList .. "","",function(player,buyerID) 
								buyerID = buyerID
								if buyerID   and buyerID ~= "" then
									local target2 = vRP.getUserSource(tonumber(buyerID))
									local bID = vRP.getUserId(target2)
									if target2   then
										vRP.prompt(player,"Pret $: ","",function(player,amount)
											if (tonumber(amount)) then
													if(tonumber(amount) < 0)then
														vRPclient.notify(player, {"~r~Pretul nu poate fii sub $0!"})
														return
													else
													vRP.getUserAddress(bID, function(address2)
														if address2 == nil then
															vRP.request(target2,""..vRP.getPlayerName(player).." vrea sa vanda casa: " ..address.home.. " Pret: $"..amount.."", 10, function(target,ok)
																if ok then
																	local oldUser = vRP.getUserId(player)
																	local pID = vRP.getUserId(target2)
																	local money = vRP.getMoney(pID)
																	print(tonumber(money))
																	if (tonumber(money) >= tonumber(amount)) then
																		vRP.sellHomeToPlayer(pID, oldUser, address.home, address.number)
																		vRP.giveMoney(oldUser, amount)
																		vRP.setMoney(pID,money-amount)
																		vRPclient.notify(player,{"~g~Ai vandut cu succes casa lui ".. vRP.getPlayerName(target).." pentru $"..amount.."!"})
																		vRPclient.notify(target,{"~g~"..vRP.getPlayerName(player).." ti-a vandut cu succes casa pentru $"..amount.."!"})
																		vRP.closeMenu(player)
																	else
																		vRPclient.notify(player,{"~r~".. vRP.getPlayerName(target).." Nu are destui Bani!"})
																		vRPclient.notify(target,{"~r~Nu ai destui Bani!"})
																	end
																else
																	vRPclient.notify(player,{"~r~"..vRP.getPlayerName(target).." a refuzat sa cumpere casa."})
																	vRPclient.notify(target,{"~r~Ai refuzat sa cumperi casa lui "..vRP.getPlayerName(player).."."})
																end
															end)
														else
															vRPclient.notify(player,{"~r~Jucatorul are deja o casa."})
															vRP.closeMenu(player)
														end	
													end)
												end
											else
												vRPclient.notify(player,{"~r~Pretul casei trebuie sa fie un numar."})
											end
										end)
									else
										vRPclient.notify(player,{"~r~Acel ID pare Invalid"})
									end
								else
									vRPclient.notify(player,{"~r~Niciun jucator ID selectat."})
								end
							end)
						else
							vRPclient.notify(player,{"~r~Niciun jucator in apropiere."})
						end
					else
						vRPclient.notify(player,{lang.home.sell.no_home()})
					end
				end)
			end)
		end
  end, "Vinde casa unui jucator."}
  
  return menu
end

-- build homes entry points
local function build_client_homes(source)
  local user_id = vRP.getUserId(source)
  if user_id   then
    for k,v in pairs(cfg.homes) do
      local x,y,z = table.unpack(v.entry_point)

      local function entry_enter(player,area)
        local user_id = vRP.getUserId(player)
        if user_id   and vRP.hasPermissions(user_id,v.permissions or {}) then
          vRP.openMenu(source,build_entry_menu(user_id, k))
        end
      end

      local function entry_leave(player,area)
        vRP.closeMenu(player)
      end

      vRPclient.addBlip(source,{x,y,z,v.blipid,v.blipcolor,k})
      vRPclient.addMarker(source,{x,y,z-1,0.7,0.7,0.5,0,255,125,125,150})
      vRPclient.addMarkerNames(source,{x, y, z, "~g~LOCUINTA: ~y~"..k, 0, 0.8})
      vRP.setArea(source,"vRP:home"..k,x,y,z,1,1.5,entry_enter,entry_leave)
    end
  end
end

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
  if first_spawn then -- first spawn, build homes
    build_client_homes(source)
  else -- death, leave home if inside one
    -- leave slot if inside one
    local tmp = vRP.getUserTmpTable(user_id)
    if tmp and tmp.home_stype then
      leave_slot(user_id, source, tmp.home_stype, tmp.home_sid)
    end
  end
end)

AddEventHandler("vRP:playerLeave",function(user_id, player) 
  -- leave slot if inside one
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp and tmp.home_stype then
    leave_slot(user_id, player, tmp.home_stype, tmp.home_sid)
  end
end)

