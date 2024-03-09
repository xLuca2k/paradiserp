-- a basic market implementation

local lang = vRP.lang
local cfg = module("cfg/markets")
local market_types = cfg.market_types
local markets = cfg.markets

local market_menus = {}


-- build market menus
local function build_market_menus()
  for gtype,mitems in pairs(market_types) do
    local market_menu = {
      name=lang.market.title({gtype}),
      css={top = "75px", header_color="rgba(0,255,125,0.75)"}
    }

    -- build market items
    local kitems = {}

    -- item choice
    local market_choice = function(player,choice)
      local idname = kitems[choice][1]
      local item = vRP.items[idname]
      local price = kitems[choice][2]

      if item then
        -- prompt amount
        local user_id = vRP.getUserId(player)
        if user_id   then
          vRP.prompt(player,lang.market.prompt({item.name}),"",function(player,amount)
            local amount = parseInt(amount)
            if amount >= 0 and amount   and amount ~= "" then
              if amount <= 20 then
              -- weight check
              local new_weight = vRP.getInventoryWeight(user_id)+item.weight*amount
              if new_weight <= vRP.getInventoryMaxWeight(user_id) then
                -- payment
                if vRP.tryPayment(user_id,amount*price) then
                  vRP.giveInventoryItem(user_id,idname,amount,true)
                  vRPclient.notify(player,{lang.money.paid({amount*price})})
                else
                  vRPclient.notify(player,{lang.money.not_enough()})
                end
              else
                vRPclient.notify(player,{lang.inventory.full()})
              end
            else
              vRPclient.notify(player,{"Eroare: ~w~Poti cumpara maxim 20 de produse"})
            end
            else
              vRPclient.notify(player,{lang.common.invalid_value()})
            end
          end)
        end
      end
    end

    -- add item options
    for k,v in pairs(mitems) do
      local item = vRP.items[k]
      if item then
        kitems[item.name] = {k,math.max(v,0)} -- idname/price
        market_menu[item.name] = {market_choice,lang.market.info({item.name, item.description, vRP.formatMoney(v), k})}
      end
    end

    market_menus[gtype] = market_menu
  end
end

local first_build = true

local function build_client_markets(source)
  -- prebuild the market menu once (all items should be defined now)
  if first_build then
    build_market_menus()
    first_build = false
  end

  local user_id = vRP.getUserId(source)
  if user_id   then
    for k,v in pairs(markets) do
      local gtype,x,y,z = table.unpack(v)
      local x = v[2].x
      local y = v[2].y
      local z = v[2].z
      local group = market_types[gtype]
      local menu = market_menus[gtype]

      if group and menu then -- check market type
        local gcfg = group._config

        local function market_enter()
          local user_id = vRP.getUserId(source)
          if user_id   and vRP.hasPermissions(user_id,gcfg.permissions or {}) and gcfg.faction == nil and gcfg.fType == nil  then
            vRP.openMenu(source,menu) 
          elseif(gcfg.fType   and gcfg.fType ~= "")then
				if(vRP.hasGroup(user_id,"onduty") and vRP.hasUserFaction(user_id))then
					local theFaction = vRP.getUserFaction(user_id)
					if(tostring(vRP.getFactionType(theFaction)) == tostring(gcfg.fType))then
						vRP.openMenu(source,menu)
					end
				end
			elseif(gcfg.faction   and gcfg.faction ~= "")then
				if(vRP.hasGroup(user_id,"onduty") and vRP.isUserInFaction(user_id,gcfg.faction))then
					vRP.openMenu(source,menu)
				end
			end 
        end

        local function market_leave()
          vRP.closeMenu(source)
        end

        if(gtype == "ATASAMENTE ARMA")then
          vRPclient.addMarkerNames(source,{x, y, z+0.250, "~w~MAGAZIN \n~r~ATASAMENTE ARMA", 4, 1.1})  
        else
          vRPclient.addBlip(source,{x,y,z,gcfg.blipid,gcfg.blipcolor,lang.market.title({gtype})})
          vRPclient.addMarkerSign(source,{21,x,y,z-1.65,0.50,0.60,0.60,255,255,255,150,150,1,false,0})
          vRPclient.addMarkerNames(source,{x,y,z+0.350, "~w~MAGAZIN: ~b~"..gtype, 4, 1.1})          
        end
        vRP.setArea(source,"vRP:market"..k,x,y,z,1,1.5,market_enter,market_leave)
      end
    end
  end
end

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
  if first_spawn then
    build_client_markets(source)
  end
end)
