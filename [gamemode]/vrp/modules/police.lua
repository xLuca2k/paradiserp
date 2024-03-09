
-- this module define some police tools and functions
local lang = vRP.lang
local cfg = module("cfg/police")

-- police records

-- insert a police record for a specific user
--- line: text for one line (can be html)
function vRP.insertPoliceRecord(user_id, line)
  if user_id   then
    vRP.getUData(user_id, "vRP:police_records", function(data)
      local records = data..line.."<br />"
      vRP.setUData(user_id, "vRP:police_records", records)
    end)
  end
end

-- Hotkey Open Police PC 1/2
function vRP.openPolicePC(source)
  vRP.buildMenu("police_pc", {player = source}, function(menudata)
    menudata.name = "Police PC"
    menudata.css = {top="75px",header_color="rgba(0,125,255,0.75)"}
    vRP.openMenu(source,menudata)
  end)
end

-- Hotkey Open Police PC 2/2
function tvRP.openPolicePC()
  vRP.openPolicePC(source)
end

AddEventHandler('alertPolitie', function(msg)
  local cops = vRP.getOnlineUsersByFaction('Politie')
  for k,v in pairs(cops) do 
      local s = vRP.getUserSource(tonumber(v))
      TriggerClientEvent('chatMessage',s,msg)
  end
end)

-- Hotkey Open Police Menu 1/2
function vRP.openPoliceMenu(source)
  vRP.buildMenu("police", {player = source}, function(menudata)
    menudata.name = "Police"
    menudata.css = {top="75px",header_color="rgba(0,125,255,0.75)"}
    vRP.openMenu(source,menudata)
  end)
end

-- Hotkey Open Police Menu 2/2
function tvRP.openPoliceMenu()
  vRP.openPoliceMenu(source)
end

-- police PC

local menu_pc = {name=lang.police.pc.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}

-- show police records by registration
local function ch_show_police_records(player,choice)
  vRPclient.getNearestPlayer(player,{5},function(nplayer)
    local user_id = vRP.getUserId(nplayer)
    if user_id   then
      vRPclient.notify(player,{"Succes: ~w~Te uiti la cazierul lui ID: ~b~"..user_id..""})
      vRP.getUData(user_id, "vRP:police_records", function(content)
        vRPclient.setDiv(player,{"police_pc",".div_police_pc{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
      end)
    else
      vRPclient.notify(player,{lang.common.not_found()})
    end
  end)
end

-- delete police records by registration
local function ch_delete_police_records(player,choice)
  vRPclient.getNearestPlayer(player,{5},function(nplayer)
    local user_id = vRP.getUserId(nplayer)
    if user_id   then
      vRP.getUserIdentity(user_id, function(identity)
        vRP.request(player,"Esti sigur ca vrei sa cureti cazierul lui "..identity.name.." "..identity.firstname.." ?",15,function(player,ok)
          if ok then
            vRPclient.notify(player,{"Succes: ~w~Ai curatat cazierul lui ID: ~r~"..user_id..""})
            vRP.setUData(user_id, "vRP:police_records", "")
          end
        end)
      end)
    else
      vRPclient.notify(player,{lang.common.not_found()})
    end
  end)
end

-- close business of an arrested owner
local function ch_closebusiness(player,choice)
  vRPclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id   then
      vRP.getUserIdentity(nuser_id, function(identity)
        vRP.getUserBusiness(nuser_id, function(business)
          if identity and business then
            vRP.request(player,lang.police.pc.closebusiness.request({identity.name,identity.firstname,business.name}),15,function(player,ok)
              if ok then
                vRP.closeBusiness(nuser_id)
                vRPclient.notify(player,{lang.police.pc.closebusiness.closed()})
              end
            end)
          else
            vRPclient.notify(player,{lang.common.no_player_near()})
          end
        end)
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end

menu_pc[lang.police.pc.records.show.title()] = {ch_show_police_records,lang.police.pc.records.show.description()}
menu_pc[lang.police.pc.records.delete.title()] = {ch_delete_police_records, lang.police.pc.records.delete.description()}
menu_pc[lang.police.pc.closebusiness.title()] = {ch_closebusiness,lang.police.pc.closebusiness.description()}

menu_pc.onclose = function(player) -- close pc gui
  vRPclient.removeDiv(player,{"police_pc"})
end

local function pc_enter(source,area)
  local user_id = vRP.getUserId(source)
  if user_id   then
    if vRP.isUserInFaction(user_id,"Politie") or vRP.isUserInFaction(user_id,"Jandarmerie") or vRP.isUserInFaction(user_id,"SRI") then
      vRP.openMenu(source,menu_pc)
    else
      vRPclient.notify(source,{"Eroare: ~w~Nu ai acces!"})
    end
  end
end

local function pc_leave(source,area)
  vRP.closeMenu(source)
end

-- main menu choices

---- handcuff
local choice_handcuff = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id   then
      vRPclient.toggleHandcuff(nplayer,{})
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,"Incatuseaza/Descatuseaza Rutier cel mai apropiat om"}

local choice_handcuff2 = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id   then
      TriggerClientEvent('mita:arrestonway', nplayer, source) 
      TriggerClientEvent('radu:arrest', source)  
      Citizen.Wait(5000)
      vRPclient.toggleHandcuff(nplayer,{})
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end, "Incatuseaza Agresiv cel mai apropiat om"}

---- putinveh
local choice_putinveh = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id   then
      vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
        if handcuffed then
          vRPclient.putInNearestVehicleAsPassenger(nplayer, {5})
        else
          vRPclient.notify(player,{lang.police.not_handcuffed()})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.putinveh.description()}

---- getoutveh
local choice_getoutveh = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id   then
      vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
        if handcuffed then
          vRPclient.ejectVehicle(nplayer, {})
        else
          vRPclient.notify(player,{lang.police.not_handcuffed()})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.getoutveh.description()}

---- askid
local choice_askid = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id   then
      vRPclient.notify(player,{lang.police.menu.askid.asked()})
      vRP.request(nplayer,lang.police.menu.askid.request(),15,function(nplayer,ok)
        if ok then
          vRP.getUserIdentity(nuser_id, function(identity)
            if identity then
              -- display identity and business
              local name = identity.name
              local firstname = identity.firstname
              local age = identity.age
              local phone = identity.phone
              local registration = identity.registration
              local bname = ""
              local bcapital = 0
              local number = ""

              vRP.getUserBusiness(nuser_id, function(business)
                if business then
                  bname = business.name
                  bcapital = business.capital
                end

                  TriggerClientEvent("Wake:showBuletin", player, {
                    nume = firstname, 
                    prenume = name, 
                    age = age, 
                    usr_id = nuser_id, 
                    target = nplayer
                  })

                end)
            end
          end)
        else
          vRPclient.notify(player,{lang.common.request_refused()})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end, lang.police.menu.askid.description()}


-- Store WEAPONS CUAIE
local isStoring = false
local choice_store_weapons = {function(player, choice)
  local user_id = vRP.getUserId(player)
  
	vRPclient.getWeapons(player,{},function(weapons)
		vRP.request(player,"are you sure that you want to store your weapons?",30,function(player,ok)
			if ok then 
			  if isStoring == false then
              isStoring = true
				vRPclient.notify(source,{"Info: In 1 minut iti vor fi depozitate armele."})
				SetTimeout(60000, function()
					vRPclient.giveWeapons(player,{{},true})
		
					for k,v in pairs(weapons) do
					-- convert weapons to parametric weapon items
					  vRP.giveInventoryItem(user_id, "wbody|"..k, 1, true)
						if  v.ammo > 0 then
						vRP.giveInventoryItem(user_id, "wammo|"..k, v.ammo, true)
						end
						
          end
			  vRPclient.notify(player,{"Succes: ~w~Ai strans armele"})
				SetTimeout(10000,function()
					isStoring = false
				end)
				end)
			  else
				vRPclient.notify(player,{"Eroare: ~w~Deja ai strans armele"})
			  end
			end
		end)
	end)
end, lang.police.menu.store_weapons.description()}

---- police check
local choice_check = {function(player,choice)
  vRPclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id   then
      vRPclient.isHandcuffed(nplayer,{},function(handcuffed)
        if handcuffed then
          vRPclient.notify(nplayer,{lang.police.menu.check.checked()})
          vRPclient.getWeapons(nplayer,{},function(weapons)
            -- prepare display data (money, items, weapons)
            local money = vRP.getMoney(nuser_id)
            local items = ""
            local data = vRP.getUserDataTable(nuser_id)
            if data and data.inventory then
              for k,v in pairs(data.inventory) do
                local item = vRP.items[k]
                if item then
                  items = items.."<br />"..item.name.." ("..v.amount..")"
                end
              end
            end
          
            local weapons_info = ""
            for k,v in pairs(weapons) do
              weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
            end
          
            vRPclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
            -- request to hide div
            vRP.request(player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
              vRPclient.removeDiv(player,{"police_check"})
            end)
          end)
        else
          vRPclient.notify(player,{"Eroare: ~w~Nu este incatusat!"})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end, lang.police.menu.check.description()}

local choice_seize_weapons = {function(player, choice)
	local user_id = vRP.getUserId(player)
	if user_id   then
		vRPclient.getNearestPlayer(player, {5}, function(nplayer)
			local nuser_id = vRP.getUserId(nplayer)
			if nuser_id   and vRP.isUserInFaction(user_id,"Politie") or vRP.isUserInFaction(user_id,"Jandarmerie") then
				vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)
					if handcuffed then
						if (vRP.getInventoryItemAmount(nuser_id, "gunpermit_doc") == 0) then
							vRPclient.giveWeapons(nplayer,{{},true})
							vRPclient.notify(nplayer,{lang.police.menu.seize.weapons.seized()})
							vRPclient.notify(player, {"Eroare: ~w~Jucatorul nu are permis de port-arma, armele i-au fost confiscate!"})
						else
							vRPclient.notify(player, {"Succes: ~w~Jucatorul are permis de port-arma!"})
						end
					else
						vRPclient.notify(player,{lang.police.not_handcuffed()})
					end
				end)
			else
				vRPclient.notify(player,{lang.common.no_player_near()})
			end
		end)
	end
end, lang.police.menu.seize.weapons.description()}

local choice_seize_items = {function(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id   then
    vRPclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id   and vRP.isUserInFaction(user_id,"Politie") or vRP.isUserInFaction(user_id,"Jandarmerie") or vRP.isUserInFaction(user_id,"SRI") then
        vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            for k,v in pairs(cfg.seizable_items) do -- transfer seizable items
              local amount = vRP.getInventoryItemAmount(nuser_id,v)
              if amount > 0 then
                local item = vRP.items[v]
                if item then -- do transfer
                  if vRP.tryGetInventoryItem(nuser_id,v,amount,true) then
                   -- vRP.giveInventoryItem(user_id,v,amount,false)
                    vRPclient.notify(player,{lang.police.menu.seize.seized({item.name,amount})})
					          --vRPclient.notify(nplayer,{lang.police.menu.seize.seized({item.name,amount})})
                  end
                end
              end
            end
          else
            vRPclient.notify(player,{lang.police.not_handcuffed()})
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.seize.items.description()}

local confisca_asigurare = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id   then
    vRPclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id   then
        vRP.prompt(player, "Verifica Asigurare(1) / Confisca Asigurare(2)", "", function(player, permis)
          permis = parseInt(permis)
          if(tonumber(permis)) and (permis == 1 or permis == 2) and permis ~= "" and permis   then
            if(permis == 2)then
              if vRP.tryGetInventoryItem(nuser_id,"asigurare_masina",1,true) then
                vRPclient.notify(player,{"Succes: ~w~I-ai confiscat Asigurarea de Masina lui ID: ~r~"..nuser_id.."~w~!"})
                vRPclient.notify(nplayer,{"Succes: ~w~ID: ~r~"..user_id.." ~w~Ti-a confiscat Asigurarea de Masina!"})
              else
                vRPclient.notify(player,{"Eroare: ~w~ID: ~w~"..nuser_id.." ~r~Nu Asigurare Masina!"})
              end
            else
              if vRP.getInventoryItemAmount(nuser_id,"asigurare_masina") == 0 then
                vRPclient.notify(player,{"Eroare: ~w~ID "..nuser_id.." Nu Asigurare Masina!"})
              else
                vRPclient.notify(player,{"Succes: ~w~ID "..nuser_id.." Are Asigurare Masina!"})
              end
            end
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  else
    vRPclient.notify(player,{lang.common.no_player_near()})
  end
end, "Verifica sau Confisca Asigurarea de Masina celui mai apropiat jucator."}

local confisca_gundoc = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id   then
    vRPclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id   then
        vRP.prompt(player, "Verifica Permis(1) / Confisca Permis(2)", "", function(player, permis)
          permis = parseInt(permis)
          if(tonumber(permis)) and (permis == 1 or permis == 2) and permis ~= "" and permis   then
            if(permis == 2)then
              if vRP.tryGetInventoryItem(nuser_id,"gunpermit_doc",1,true) then
                vRPclient.notify(player,{"Succes: ~w~I-ai confiscat Permisul de Port-Arma lui ID: ~r~"..nuser_id.."~w~!"})
                vRPclient.notify(nplayer,{"Succes: ~w~ID: ~r~"..user_id.." ~w~Ti-a confiscat Permisul de Port-Arma!"})
              else
                vRPclient.notify(player,{"Eroare: ~w~ID "..nuser_id.." Nu are Permis Port-Arma!"})
              end
            else
              if vRP.getInventoryItemAmount(nuser_id,"gunpermit_doc") == 0 then
                vRPclient.notify(player,{"Eroare: ~w~ID ~w~"..nuser_id.." ~r~Nu are Permis Port-Arma!"})
              else
                vRPclient.notify(player,{"Succes: ~w~ID: ~w~"..nuser_id.." ~g~Are Permis de Port-Arma!"})
              end
            end
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  else
    vRPclient.notify(player,{lang.common.no_player_near()})
  end
end, "Verifica sau Confisca Permis-ul de Port-Arma celui mai apropiat jucator."}

local choice_confisclc = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id   then
    vRPclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id   then
        vRP.prompt(player, "Verifica Permis(1) / Confisca Permis(2)", "", function(player, permis)
          permis = parseInt(permis)
          if(tonumber(permis)) and (permis == 1 or permis == 2) and permis ~= "" and permis   then
            if(permis == 2)then
              if vRP.tryGetInventoryItem(nuser_id,"permis_doc",1,true) then
                vRPclient.notify(player,{"Succes: ~w~I-ai confiscat Permisul de Masina lui ID: ~r~"..nuser_id.."~w~!"})
                vRPclient.notify(nplayer,{"Succes: ~w~ID: ~r~"..user_id.." ~w~Ti-a confiscat Permisul de Masina!"})
              else
                vRPclient.notify(player,{"Eroare: ~w~ID "..nuser_id.." ~w~Nu are Permis de Masina!"})
              end
            else
              if vRP.getInventoryItemAmount(nuser_id,"permis_doc") == 0 then
                vRPclient.notify(player,{"Eroare: ~w~ID ~w~"..nuser_id.." ~w~Nu are Permis de Masina!"})
              else
                vRPclient.notify(player,{"Succes: ~w~ID ~w~"..nuser_id.." ~w~Are Permis de Masina!"})
              end
            end
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  else
    vRPclient.notify(player,{lang.common.no_player_near()})
  end
end, "Verifica sau Confisca Permis-ul de conducere celui mai apropiat jucator."}

local choice_buletin = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id   then
    
    vRP.getUserIdentity(user_id, function(identity)
      if identity then
        -- display identity and business
        local name = identity.name
        local firstname = identity.firstname
        local age = identity.age
        local bname = ""
        local bcapital = 0
        local home = ""
        local number = ""

        vRP.getUserBusiness(user_id, function(business)
          if business then
            bname = business.name
            bcapital = business.capital
          end

          vRP.getUserAddress(user_id, function(address)
            if address then
              home = address.home
              number = address.number
            end

            local content = lang.police.identity.info({name,firstname,age,bname,bcapital,home,number})
            vRPclient.setDiv(player,{"police_identity",".div_police_identity{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
            -- request to hide div
            Citizen.Wait(6500)
            vRPclient.removeDiv(player,{"police_identity"})
          end)
        end)
      end
    end)
  end
end, "Vezi Buletinul Tau !"}

-- add choices to the menu
vRP.registerMenuBuilder("main", function(add, data)
	local player = data.player

	local user_id = vRP.getUserId(player)
	if user_id   then
    local choices = {}
    if vRP.isUserInFaction(user_id,"Politie") or vRP.isUserInFaction(user_id,"Jandarmerie") or vRP.isUserInFaction(user_id,"DIICOT") or vRP.isUserInFaction(user_id,"Cartel Tijuana") or vRP.isUserInFaction(user_id,"Barrio Azteca") or vRP.isUserInFaction(user_id,"Mafia Rusa") or vRP.isUserInFaction(user_id,"Mafia Siciliana") or vRP.isUserInFaction(user_id,"Mafia Narcos") or vRP.isUserInFaction(user_id,"The Devil Angel of Light") or vRP.isUserInFaction(user_id,"Mafia Catifea") or vRP.isUserInFaction(user_id,"Mafia 4Blocks") or vRP.isUserInFaction(user_id,"Mafia Traperilor") or vRP.isUserInFaction(user_id,"Mafia Gipsy") or vRP.isUserInFaction(user_id,"Mafia Albaneza")or vRP.isUserInFaction(user_id,"Mafia Curcubeu")  or vRP.isUserInFaction(user_id,"Crips Gang") or vRP.isUserInFaction(user_id,"Santa Muerte") or vRP.isUserInFaction(user_id,"Mafia Cosa Nostra") or vRP.isUserInFaction(user_id,"Mafia Lautarilor") or vRP.isUserInFaction(user_id,"Mafia Geneve") or vRP.isUserInFaction(user_id,"Sons of Anarchy") or vRP.isUserInFaction(user_id,"Mafia Araba") or vRP.isUserInFaction(user_id,"Mafia The Jokers") or vRP.isUserInFaction(user_id,"Mafia OTF") or vRP.isUserInFaction(user_id,"Sindicat") or vRP.isUserInFaction(user_id,"Ballas Gang") or vRP.isUserInFaction(user_id,"Marabunta Grande") or vRP.isUserInFaction(user_id,"Hitman") or vRP.isUserInFaction(user_id,"Mafia Bloods") or vRP.isUserInFaction(user_id,"Mafia Casa Blanca") or vRP.isUserInFaction(user_id,"18th Street Gang") or vRP.isUserInFaction(user_id,"Grove Street") or vRP.isUserInFaction(user_id,"Guvern") or vRP.isUserInFaction(user_id,"Mafia Los Vagos") or vRP.isUserInFaction(user_id,"Santa Muerte") then
			-- build police menu
			choices[lang.police.title()] = {function(player,choice)
				vRP.buildMenu("police", {player = player}, function(menu)
					menu.name = lang.police.title()
					menu.css = {top="75px",header_color="rgba(0,125,255,0.75)"}

            if vRP.hasGroup(user_id,"onduty")then
          
            if vRP.isUserInFaction(user_id,"Politie") or vRP.isUserInFaction(user_id,"Jandarmerie") or vRP.isUserInFaction(user_id,"DIICOT") or vRP.isUserInFaction(user_id,"Cartel Tijuana") or vRP.isUserInFaction(user_id,"Barrio Azteca") or vRP.isUserInFaction(user_id,"Mafia Rusa") or vRP.isUserInFaction(user_id,"Mafia Siciliana") or vRP.isUserInFaction(user_id,"Mafia Narcos")  or vRP.isUserInFaction(user_id,"The Devil Angel of Light") or vRP.isUserInFaction(user_id,"Mafia Catifea") or vRP.isUserInFaction(user_id,"Mafia 4Blocks") or vRP.isUserInFaction(user_id,"Mafia Traperilor") or vRP.isUserInFaction(user_id,"Mafia Gipsy") or vRP.isUserInFaction(user_id,"Mafia Albaneza")  or vRP.isUserInFaction(user_id,"Mafia Curcubeu") or vRP.isUserInFaction(user_id,"Crips Gang") or vRP.isUserInFaction(user_id,"Santa Muerte") or vRP.isUserInFaction(user_id,"Mafia Cosa Nostra") or vRP.isUserInFaction(user_id,"Mafia Lautarilor") or vRP.isUserInFaction(user_id,"Mafia Geneve") or vRP.isUserInFaction(user_id,"Sons of Anarchy") or vRP.isUserInFaction(user_id,"Mafia Araba") or vRP.isUserInFaction(user_id,"Mafia The Jokers") or vRP.isUserInFaction(user_id,"Mafia OTF") or vRP.isUserInFaction(user_id,"Sindicat") or vRP.isUserInFaction(user_id,"Ballas Gang") or vRP.isUserInFaction(user_id,"Marabunta Grande") or vRP.isUserInFaction(user_id,"Hitman") or vRP.isUserInFaction(user_id,"Mafia Bloods") or vRP.isUserInFaction(user_id,"Mafia Casa Blanca") or vRP.isUserInFaction(user_id,"18th Street Gang") or vRP.isUserInFaction(user_id,"Grove Street") or vRP.isUserInFaction(user_id,"Guvern") or vRP.isUserInFaction(user_id,"Mafia Los Vagos") or vRP.isUserInFaction(user_id,"Santa Muerte") then
              menu[lang.police.menu.putinveh.title()] = choice_putinveh
              menu["Incatuseaza"] = choice_handcuff
			      end

            if vRP.isUserInFaction(user_id,"Politie") or vRP.isUserInFaction(user_id,"Jandarmerie") or vRP.isUserInFaction(user_id,"DIICOT") or vRP.isUserInFaction(user_id,"Cartel Tijuana") or vRP.isUserInFaction(user_id,"Barrio Azteca") or vRP.isUserInFaction(user_id,"Mafia Rusa") or vRP.isUserInFaction(user_id,"Mafia Siciliana") or vRP.isUserInFaction(user_id,"Mafia Narcos") or vRP.isUserInFaction(user_id,"The Devil Angel of Light") or vRP.isUserInFaction(user_id,"Mafia Catifea") or vRP.isUserInFaction(user_id,"Mafia 4Blocks") or vRP.isUserInFaction(user_id,"Mafia Traperilor") or vRP.isUserInFaction(user_id,"Mafia Gipsy") or vRP.isUserInFaction(user_id,"Mafia Albaneza") or vRP.isUserInFaction(user_id,"Mafia Curcubeu") or vRP.isUserInFaction(user_id,"Crips Gang") or vRP.isUserInFaction(user_id,"Santa Muerte") or vRP.isUserInFaction(user_id,"Mafia Cosa Nostra") or vRP.isUserInFaction(user_id,"Mafia Lautarilor") or vRP.isUserInFaction(user_id,"Mafia Geneve") or vRP.isUserInFaction(user_id,"Sons of Anarchy") or vRP.isUserInFaction(user_id,"Mafia Araba") or vRP.isUserInFaction(user_id,"Mafia The Jokers") or vRP.isUserInFaction(user_id,"Mafia OTF") or vRP.isUserInFaction(user_id,"Sindicat") or vRP.isUserInFaction(user_id,"Ballas Gang") or vRP.isUserInFaction(user_id,"Marabunta Grande") or vRP.isUserInFaction(user_id,"Hitman") or vRP.isUserInFaction(user_id,"Mafia Bloods") or vRP.isUserInFaction(user_id,"Mafia Casa Blanca") or vRP.isUserInFaction(user_id,"18th Street Gang") or vRP.isUserInFaction(user_id,"Grove Street") or vRP.isUserInFaction(user_id,"Guvern") or vRP.isUserInFaction(user_id,"Mafia Los Vagos") or vRP.isUserInFaction(user_id,"Santa Muerte") then
              choices[lang.police.menu.store_weapons.title()] = choice_store_weapons
            end
            
            if vRP.isUserInFaction(user_id,"Politie") or vRP.isUserInFaction(user_id,"Jandarmerie") or vRP.isUserInFaction(user_id,"DIICOT") or vRP.isUserInFaction(user_id,"Cartel Tijuana") or vRP.isUserInFaction(user_id,"Barrio Azteca") or vRP.isUserInFaction(user_id,"Mafia Rusa") or vRP.isUserInFaction(user_id,"Mafia Siciliana") or vRP.isUserInFaction(user_id,"Mafia Narcos") or vRP.isUserInFaction(user_id,"The Devil Angel of Light") or vRP.isUserInFaction(user_id,"Mafia Catifea") or vRP.isUserInFaction(user_id,"Mafia 4Blocks") or vRP.isUserInFaction(user_id,"Mafia Traperilor") or vRP.isUserInFaction(user_id,"Mafia Gipsy") or vRP.isUserInFaction(user_id,"Mafia Albaneza") or vRP.isUserInFaction(user_id,"Mafia Curcubeu") or vRP.isUserInFaction(user_id,"Crips Gang") or vRP.isUserInFaction(user_id,"Santa Muerte") or vRP.isUserInFaction(user_id,"Mafia Cosa Nostra") or vRP.isUserInFaction(user_id,"Mafia Lautarilor") or vRP.isUserInFaction(user_id,"Mafia Geneve") or vRP.isUserInFaction(user_id,"Sons of Anarchy") or vRP.isUserInFaction(user_id,"Mafia Araba") or vRP.isUserInFaction(user_id,"Mafia The Jokers") or vRP.isUserInFaction(user_id,"Mafia OTF") or vRP.isUserInFaction(user_id,"Sindicat") or vRP.isUserInFaction(user_id,"Ballas Gang") or vRP.isUserInFaction(user_id,"Marabunta Grande") or vRP.isUserInFaction(user_id,"Hitman") or vRP.isUserInFaction(user_id,"Mafia Bloods") or vRP.isUserInFaction(user_id,"Mafia Casa Blanca") or vRP.isUserInFaction(user_id,"18th Street Gang") or vRP.isUserInFaction(user_id,"Grove Street") or vRP.isUserInFaction(user_id,"Guvern") or vRP.isUserInFaction(user_id,"Mafia Los Vagos") or vRP.isUserInFaction(user_id,"Santa Muerte") then
					  	menu[lang.police.menu.getoutveh.title()] = choice_getoutveh
					  end

            if vRP.isUserInFaction(user_id,"Politie") or vRP.isUserInFaction(user_id,"Jandarmerie") or vRP.isUserInFaction(user_id,"DIICOT") or vRP.isUserInFaction(user_id,"Cartel Tijuana") or vRP.isUserInFaction(user_id,"Barrio Azteca") or vRP.isUserInFaction(user_id,"Mafia Rusa") or vRP.isUserInFaction(user_id,"Mafia Siciliana") or vRP.isUserInFaction(user_id,"Mafia Narcos") or vRP.isUserInFaction(user_id,"The Devil Angel of Light") or vRP.isUserInFaction(user_id,"Mafia Catifea") or vRP.isUserInFaction(user_id,"Mafia 4Blocks") or vRP.isUserInFaction(user_id,"Mafia Traperilor") or vRP.isUserInFaction(user_id,"Mafia Gipsy") or vRP.isUserInFaction(user_id,"Mafia Albaneza") or vRP.isUserInFaction(user_id,"Mafia Curcubeu") or vRP.isUserInFaction(user_id,"Crips Gang") or vRP.isUserInFaction(user_id,"Santa Muerte") or vRP.isUserInFaction(user_id,"Mafia Cosa Nostra") or vRP.isUserInFaction(user_id,"Mafia Lautarilor") or vRP.isUserInFaction(user_id,"Mafia Geneve") or vRP.isUserInFaction(user_id,"Sons of Anarchy") or vRP.isUserInFaction(user_id,"Mafia Araba") or vRP.isUserInFaction(user_id,"Mafia The Jokers") or vRP.isUserInFaction(user_id,"Mafia OTF") or vRP.isUserInFaction(user_id,"Sindicat") or vRP.isUserInFaction(user_id,"Ballas Gang") or vRP.isUserInFaction(user_id,"Marabunta Grande") or vRP.isUserInFaction(user_id,"Hitman") or vRP.isUserInFaction(user_id,"Mafia Bloods") or vRP.isUserInFaction(user_id,"Mafia Casa Blanca") or vRP.isUserInFaction(user_id,"18th Street Gang") or vRP.isUserInFaction(user_id,"Grove Street") or vRP.isUserInFaction(user_id,"Guvern") or vRP.isUserInFaction(user_id,"Mafia Los Vagos") or vRP.isUserInFaction(user_id,"Santa Muerte") then
					  	menu[lang.police.menu.check.title()] = choice_check
					  end

					  if vRP.isUserInFaction(user_id,"Politie") or vRP.isUserInFaction(user_id,"Jandarmerie") or vRP.isUserInFaction(user_id,"DIICOT") then
					  	menu[lang.police.menu.seize.weapons.title()] = choice_seize_weapons
					  end

					  if vRP.isUserInFaction(user_id,"Politie") or vRP.isUserInFaction(user_id,"Jandarmerie") or vRP.isUserInFaction(user_id,"DIICOT") then
					  	menu[lang.police.menu.seize.items.title()] = choice_seize_items
					  end

            if vRP.isUserInFaction(user_id,"Politie") or vRP.isUserInFaction(user_id,"Jandarmerie") or vRP.isUserInFaction(user_id,"DIICOT") then
					  	menu["Permis Port-Arma"] = confisca_gundoc
            end

            vRP.openMenu(player,menu)
          end
				end)
			end}
    end
          
    add(choices)
  end
end)

vRP.registerMenuBuilder("jucator", function(add, data)
  local user_id = vRP.getUserId(data.player)
  if user_id   then
    local choices = {}

    choices[lang.police.menu.askid.title()] = choice_askid

    add(choices)
  end
end)

local function build_client_points(source)
  -- PC
  for k,v in pairs(cfg.pcs) do
    local x,y,z = table.unpack(v)
    vRPclient.addMarkerSign(source,{21,x,y,z-1.45,0.50,0.60,0.60,0, 127, 255,150,150,1,false,0})
    vRP.setArea(source,"vRP:police:pc"..k,x,y,z,1,1.5,pc_enter,pc_leave)
  end
end

-- build police points
AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
  if first_spawn then
    build_client_points(source)
  end
end)

-- WANTED SYNC

local wantedlvl_players = {}

function vRP.getUserWantedLevel(user_id)
  return wantedlvl_players[user_id] or 0
end

-- receive wanted level
function tvRP.updateWantedLevel(level)
  local player = source
  local user_id = vRP.getUserId(player)
  if user_id   then
    local was_wanted = (vRP.getUserWantedLevel(user_id) > 0)
    wantedlvl_players[user_id] = level
    local is_wanted = (level > 0)

    -- send wanted to listening service
    if not was_wanted and is_wanted then
      vRPclient.getPosition(player, {}, function(x,y,z)
        vRP.sendServiceAlert(nil, cfg.wanted.service,x,y,z,lang.police.wanted({level}))
      end)
    end

    if was_wanted and not is_wanted then
      vRPclient.removeNamedBlip(-1, {"vRP:wanted:"..user_id}) -- remove wanted blip (all to prevent phantom blip)
    end
  end
end

-- delete wanted entry on leave
AddEventHandler("vRP:playerLeave", function(user_id, player)
  wantedlvl_players[user_id] = nil
  vRPclient.removeNamedBlip(-1, {"vRP:wanted:"..user_id})  -- remove wanted blip (all to prevent phantom blip)
end)

-- display wanted positions
local function task_wanted_positions()
  local listeners = vRP.getUsersByPermission("police.wanted")
  for k,v in pairs(wantedlvl_players) do -- each wanted player
    local player = vRP.getUserSource(tonumber(k))
    if player   and v   and v > 0 then
      vRPclient.getPosition(player, {}, function(x,y,z)
        for l,w in pairs(listeners) do -- each listening player
          local lplayer = vRP.getUserSource(w)
          if lplayer   then
            vRPclient.setNamedBlip(lplayer, {"vRP:wanted:"..k,x,y,z,cfg.wanted.blipid,cfg.wanted.blipcolor,lang.police.wanted({v})})
          end
        end
      end)
    end
  end

  SetTimeout(5000, task_wanted_positions)
end
task_wanted_positions()


vRP.registerMenuBuilder("jucator", function(add, data)
  local player = data.player

  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRP.getUserIdentity(user_id, function(identity)

      if identity then

        local choices = {}
        choices["Buletin-ul tau"] = {function()
          local home = ""
          local number = ""
          TriggerClientEvent("ples-id:showBuletin", player, {nume = identity.firstname, prenume = identity.name, age = identity.age, adresa = "Str. "..home.." Nr. "..number, usr_id = user_id, target = player}) 
        
        end, content}  
        add(choices)
      end
    end)
  end
end)

local choice_askid = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id   then
      vRPclient.notify(player,{lang.police.menu.askid.asked()})
      vRP.request(nplayer,lang.police.menu.askid.request(),15,function(nplayer,ok)
        if ok then
          vRP.getUserIdentity(nuser_id, function(identity)
            if identity then
              -- display identity and business
              local name = identity.name
              local firstname = identity.firstname
              local age = identity.age
              local phone = identity.phone
              local registration = identity.registration
              local bname = ""
              local bcapital = 0
              local number = ""

              vRP.getUserBusiness(nuser_id, function(business)
                if business then
                  bname = business.name
                  bcapital = business.capital
                end

                  TriggerClientEvent("ples-id:showBuletin", player, {
                    nume = firstname, 
                    prenume = name, 
                    age = age, 
                    usr_id = nuser_id, 
                    target = nplayer
                  })

                end)
            end
          end)
        else
          vRPclient.notify(player,{lang.common.request_refused()})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end, lang.police.menu.askid.description()}