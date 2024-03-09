local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local htmlEntities = module("vrp", "lib/htmlEntities")

vRPbm = {}
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "vRP_basic_menu")
BMclient = Tunnel.getInterface("vRP_basic_menu", "vRP_basic_menu")
vRPbsC = Tunnel.getInterface("vRP_barbershop", "vRP_basic_menu")
Tunnel.bindInterface("vRP_basic_menu", vRPbm)

local Lang = module("vrp", "lib/Lang")
local cfg = module("vrp", "cfg/base")
local lang = Lang.new(module("vrp", "cfg/lang/" .. cfg.lang) or {})

-- teleport waypoint
local choice_tptowaypoint = {function(player, choice)
    TriggerClientEvent("TpToWaypoint", player)
end, "Teleporteaza-te La Point-ul Setat."}

local blips = false

--toggle blips
local ch_blips = {function(player, choice)
    local user_id = vRP.getUserId{player}
    TriggerClientEvent("showBlips", player)
    local embed = {
        {
          ["color"] = 0xffff00,
          ["author"] = {
            ["name"] = GetPlayerName(player).."["..user_id.."]",
            ["icon_url"] = "https://cdn.discordapp.com/attachments/950408202158235718/972220998046871682/1.png"
          } ,                                               
          ["description"] = "A folosit /blips",
          ["footer"] = {
            ["text"] = os.date("%d/%m/%y").." - "..os.date("%H:%M")
          }
        }
      }
    PerformHttpRequest('https://discord.com/api/webhooks/974683243506982932/2vyX5C3-u5aRWeUdA37atvkdecURw2ni7fAKzVJH07jZA30E-L_xVLdnx4c1H9qardVK', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
    vRP.sendStaffMessage({"Admin-ul ^4" .. vRP.getPlayerName({player}) .. " ^0a folosit blips"})
end, "Porneste Blip-surile."}

RegisterCommand('blips', function(player)
    local user_id = vRP.getUserId{player}
    if vRP.isUserModerator{user_id} then
        TriggerClientEvent("showBlips", player)
        local embed = {
            {
              ["color"] = 0xffff00,
              ["author"] = {
                ["name"] = GetPlayerName(player).."["..user_id.."]",
                ["icon_url"] = "https://cdn.discordapp.com/attachments/950408202158235718/972220998046871682/Dunko.png"
              } ,                                               
              ["description"] = "A folosit /blips",
              ["footer"] = {
                ["text"] = os.date("%d/%m/%y").." - "..os.date("%H:%M")
              }
            }
          }
        PerformHttpRequest('https://discord.com/api/webhooks/974683243506982932/2vyX5C3-u5aRWeUdA37atvkdecURw2ni7fAKzVJH07jZA30E-L_xVLdnx4c1H9qardVK', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
        vRP.sendStaffMessage({"Admin-ul ^4" .. vRP.getPlayerName({player}) .. " ^0a folosit blips"})
    else
        vRPclient.notify(player,{"Nu ai acces la aceasta comanda"})
    end
end)

local jucator_check = {function(player, choice)
        
        vRPclient.getNearestPlayer(player, {5}, function(nplayer)
            local nuser_id = vRP.getUserId({nplayer})
            if nuser_id ~= nil then
                TriggerClientEvent("perc", player)
                vRPclient.notify(nplayer, {lang.police.menu.check.checked()})
                vRPclient.getWeapons(nplayer, {}, function(weapons)
                        -- prepare display data (money, items, weapons)
                        local money = vRP.getMoney({nuser_id})
                        local items = ""
                        local data = vRP.getUserDataTable({nuser_id})
                        if data and data.inventory then
                            for k, v in pairs(data.inventory) do
                                local item_name = vRP.getItemName({k})
                                local item_desc = vRP.getKeyDesc({k})
                                if item_desc ~= nil and (not string.match(item_desc, "WEAPON_")) then
                                    item_name = item_name .. " [" .. item_desc .. "]"
                                end
                                if item_name then
                                    items = items .. "<br />" .. item_name .. " (" .. v.amount .. ")"
                                end
                            end
                        end
                        
                        local weapons_info = ""
                        for k, v in pairs(weapons) do
                            weapons_info = weapons_info .. "<br />" .. k .. " (" .. v.ammo .. ")"
                        end
                        
                        vRPclient.setDiv(player, {"police_check", ".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }", lang.police.menu.check.info({money, items, weapons_info})})
                        -- request to hide div
                        vRP.request({player, lang.police.menu.check.request_hide(), 1000, function(player, ok)
                            vRPclient.removeDiv(player, {"police_check"})
                            TriggerClientEvent("removeperc", player)
                        end})
                end)
            else
                vRPclient.notify(player, {lang.common.no_player_near()})
            end
        end)
end, lang.police.menu.check.description()}

hacktimes = {}
local ch_hack = {function(player, choice)
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
        vRPclient.getNearestPlayer(player, {25}, function(nplayer)
            if nplayer ~= nil then
                local nuser_id = vRP.getUserId({nplayer})
                if nuser_id ~= nil then
                    if (hacktimes[user_id] == nil) then
                        vRPclient.notify(player, {"~r~Hack: ~w~Asteapta 10 secunde!"})
                        hacktimes[user_id] = true
                        local nbank = vRP.getBankMoney({nuser_id})
                        local amount = math.floor(nbank * 0.01)
                        local nvalue = nbank - amount
                        SetTimeout(10000, function()
                            if math.random(1, 100) == 1 then
                                vRP.setBankMoney({nuser_id, nvalue})
                                vRPclient.notify(nplayer, {"~r~~w~Ai hackuit ~r~" .. amount .. "$"})
                                vRPclient.notify(player, {"~r~~w~Cineva te a hackuit cu ~r~" .. amount .. "$"})
                                vRP.giveInventoryItem({user_id, "dirty_money", amount, true})
                            else
                                vRPclient.notify(nplayer, {"~r~~w~Cineva a incercat sa te hackuiasca ai grija!"})
                                vRPclient.notify(player, {"~r~~w~Hackuit metoda esuata!"})
                            end
                            hacktimes[user_id] = nil
                        end)
                    else
                        vRPclient.notify(player, {"~w~Ai dat deja Hack!"})
                        return
                    end
                else
                    vRPclient.notify(player, {lang.common.no_player_near()})
                end
            else
                vRPclient.notify(player, {lang.common.no_player_near()})
            end
        end)
    end
end, "Hack-uieste Cel Mai Apropiat Om."}

local ch_drag = {function(player, choice)
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
        vRPclient.getNearestPlayer(player, {10}, function(nplayer)
            if nplayer ~= nil then
                local nuser_id = vRP.getUserId({nplayer})
                if nuser_id ~= nil then
                    vRPclient.isHandcuffed(nplayer, {}, function(handcuffed)
                        if handcuffed then
                            TriggerClientEvent("dr:drag", nplayer, player)
                        else
                            vRPclient.notify(player, {"~w~Jucatorul nu este incatusat."})
                        end
                    end)
                else
                    vRPclient.notify(player, {lang.common.no_player_near()})
                end
            else
                vRPclient.notify(player, {lang.common.no_player_near()})
            end
        end)
    end
end, "Ia pe sus cel mai apropiat jucator."}

clearInv = {}
local clear_inventory = {function(player, choice)
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
        vRP.prompt({player, "NT", "[STERGE si scrie 'DA' pentru a ARUNCA TOT DIN INVENTAR]", function(player, answer)
            answer = tostring(answer)
            if (string.lower(answer) == "da") then
                vRPclient.isInComa(player, {}, function(in_coma)
                    if in_coma then
                        vRPclient.notify(player, {"~w~Esti in coma, nu poti folosi aceasta functie."})
                    else
                        if (clearInv[user_id] == nil) then
                            vRPclient.notify(player, {"~w~Inventarul tau se va sterge intr-un minut!"})
                            clearInv[user_id] = true
                            SetTimeout(60000, function()
                                vRP.clearInventory({user_id})
                                vRPclient.notify(player, {"~w~Inventarul tau a fost curatat cu succes."})
                                clearInv[user_id] = nil
                            end)
                        else
                            vRPclient.notify(player, {"~w~Ai folosit deja aceasta functie!"})
                            return
                        end
                    end
                end)
            end
        end})
    end
end}

local reload_skin = {function(source, choice)
    local user_id = vRP.getUserId({source})
    if not user_id then return end;
    vRPclient.isInComa(source, {}, function(in_coma)
        if in_coma then
            vRPclient.notify(source, {"Nu poti folosii optiunea fix skin in timp ce esti mort"})
        else
            TriggerClientEvent("raid_clothes:incarcaHainele", source)
            TriggerClientEvent('chatMessage', source, "^3^0Ai reincarcat skin-ul")
        end
    end)
end}

RegisterCommand('fixskin', function(source, choice)
    local user_id = vRP.getUserId({source})
    if not user_id then return end;
    vRPclient.isInComa(source, {}, function(in_coma)
        if in_coma then
            vRPclient.notify(source, {"Nu poti folosii optiunea fix skin in timp ce esti mort"})
        else
            TriggerClientEvent("raid_clothes:incarcaHainele", source)
            TriggerClientEvent('chatMessage', source, "^3^0Ai reincarcat skin-ul")
        end
    end)
end)

-- armor item
vRP.defInventoryItem({"body_armor", "Armura", "Armura de grad mare si calitate foarte buna, protectoare!..", function()
    local choices = {}
    choices["Echipeaza"] = {function(player, choice)
        local user_id = vRP.getUserId({player})
        if user_id ~= nil then
            if vRP.tryGetInventoryItem({user_id, "body_armor", 1, true}) then
                BMclient.setArmour(player, {100, true})
                vRP.closeMenu({player})
            end
        end
    end}
    return choices
end, 5.00, "pocket"})

local unjailed = {}
function jail_clock(target_id, timer)
    local target = vRP.getUserSource({tonumber(target_id)})
    local users = vRP.getUsers({})
    local online = false
    for k, v in pairs(users) do
        if tonumber(k) == tonumber(target_id) then
            online = true
        end
    end
    if online then
        if timer > 0 then
            vRPclient.notify(target, {"~w~Timp Ramas: " .. timer .. " minute."})
            vRP.setUData({tonumber(target_id), "vRP:jail:time", json.encode(timer)})
            SetTimeout(60 * 1000, function()
                for k, v in pairs(unjailed) do -- check if player has been unjailed by cop or admin
                    if v == tonumber(target_id) then
                        unjailed[v] = nil
                        timer = 0
                    end
                end
                vRP.setHunger({tonumber(target_id), 0})
                vRP.setThirst({tonumber(target_id), 0})
                jail_clock(tonumber(target_id), timer - 1)
            end)
        else
            BMclient.loadFreeze(target, {true})
            SetTimeout(15000, function()
                BMclient.loadFreeze(target, {false})
            end)
            vRPclient.teleport(target, {426.78323364258, -977.98498535156, 30.710720062256})-- teleport to outside jail
            vRPclient.setHandcuffed(target, {false})
            vRPclient.notify(target, {"~w~Ai fost eliberat in libertate."})
            vRP.setUData({tonumber(target_id), "vRP:jail:time", json.encode(-1)})
        end
    end
end

-- player store weapons
local store_weapons_cd = {}
function storeWeaponsCooldown()
    for user_id, cd in pairs(store_weapons_cd) do
        if cd > 0 then
            store_weapons_cd[user_id] = cd - 1
        end
    end
    SetTimeout(1000, function()
        storeWeaponsCooldown()
    end)
end
storeWeaponsCooldown()
local choice_store_weapons = {function(player, choice)
    local user_id = vRP.getUserId({player})
    if (store_weapons_cd[user_id] == nil or store_weapons_cd[user_id] == 0) and user_id ~= nil then
        store_weapons_cd[user_id] = 5
        vRPclient.notify(player, {"Asteapta 1 minut pana vei primi armele."})
        SetTimeout(60000, function()
            vRPclient.getWeapons(player, {}, function(weapons)
                    
                    for k, v in pairs(weapons) do
                        vRP.giveInventoryItem({user_id, "wbody|" .. k, 1, true})
                        exports.oxmysql:query("UPDATE vrp_arme SET inventar = 1 WHERE user_id = @user_id AND hash = @hash", {
                            ['@user_id'] = user_id,
                            ['@hash'] = k
                        }, function(rows)
                        end)
                        if v.ammo > 0 then
                            vRP.giveInventoryItem({user_id, "wammo|" .. k, v.ammo, true})
                        end
                    end
            end)
            -- clear all weapons
            vRPclient.giveWeapons(player, {{}, true})
        end)
    else
        vRPclient.notify(player, {"~w~Deja ai strans armele"})
    end
end, lang.police.menu.store_weapons.description()}

local ch_fixhair = {function(player, choice)
    local custom = {}
    local user_id = vRP.getUserId({player})
    vRP.getUData({user_id, "vRP:head:overlay", function(value)
        if value ~= nil then
            custom = json.decode(value)
            vRPbsC.setOverlay(player, {custom, true})
        end
        TriggerClientEvent('chatMessage', player, "^1^0Ai reincarcat parul")
    end})
end, "Repara parul daca cumva este buguit."}

RegisterCommand('fixhair', function(player, choice)
    local custom = {}
    local user_id = vRP.getUserId({player})
    vRP.getUData({user_id, "vRP:head:overlay", function(value)
        if value ~= nil then
            custom = json.decode(value)
            vRPbsC.setOverlay(player, {custom, true})
        end
        TriggerClientEvent('chatMessage', player, "^1^0Ai reincarcat parul")
    end})
end)

local ch_clearskin = {function(player, choice)
    TriggerClientEvent('clearskin:success', player)
    TriggerClientEvent('chatMessage', player, "^2^0Ai curatat skin-ul")
end, "Clear Skin"}

RegisterCommand('clearskin', function(player, choice)
    TriggerClientEvent('clearskin:success', player)
    TriggerClientEvent('chatMessage', player, "^2^0Ai curatat skin-ul")
end)

RegisterCommand('cleanskin', function(player, choice)
    TriggerClientEvent('clearskin:success', player)
    TriggerClientEvent('chatMessage', player, "^2^0Ai curatat skin-ul")
end)
-------------------Puscarie Admin J-------------------
function setInAJail(user_id, minutes, reason, staff)
    local thePlayer = vRP.getUserSource({user_id})
    if (reason == nil or reason == "") then
        reason = " "
    end
    BMclient.setInAJail(thePlayer, {minutes, reason, staff})
    vRPclient.teleport(thePlayer, {1179.6831054688,131.70155334473,80.889915466309})
    exports["oxmysql"]:query("UPDATE vrp_users SET aJailTime = @aJailTime, aJailReason = @aJailReason WHERE id = @user_id", {["aJailTime"] = minutes, ["aJailReason"] = reason, ["user_id"] = user_id}, function(data) end)
end

function setInAJailOffline(user_id, jTime, reason)
    if (reason == nil or reason == "") then
        reason = " "
    end
    exports["oxmysql"]:query("UPDATE vrp_users SET aJailTime = @aJailTime, aJailReason = @aJailReason WHERE id = @user_id", {
        aJailTime = jTime,
        aJailReason = reason,
        user_id = user_id
    })
end

function vRPbm.updateCheckpoints(check)
    local thePlayer = source
    local user_id = vRP.getUserId({thePlayer})
    exports["oxmysql"]:query('SELECT * FROM vrp_users WHERE id = @user_id', {["user_id"] = user_id}, function(rows)
        if #rows > 0 then
            local aJailReason = tostring(rows[1].aJailReason)
            if (tonumber(check) == 0) then
                vRPclient.notify(thePlayer, {"~w~Ai terminat toate checkpoint-urile"})
                vRPclient.setHandcuffed(thePlayer, {false})
                if (reason == nil or reason == "") then
                    reason = " "
                end
                exports["oxmysql"]:query("UPDATE vrp_users SET aJailTime = @aJailTime, aJailReason = @aJailReason WHERE id = @user_id", {["aJailTime"] = 0, ["aJailReason"] = aJailReason, ["user_id"] = user_id}, function(data) end)
                vRPclient.teleport(thePlayer, {-540.96911621094,-211.36520385742,37.649795532227})
            else
                if (aJailReason == nil or aJailReason == "") then
                    aJailReason = " "
                end
                exports["oxmysql"]:query("UPDATE vrp_users SET aJailTime = @aJailTime, aJailReason = @aJailReason WHERE id = @user_id", {["aJailTime"] = check, ["aJailReason"] = aJailReason, ["user_id"] = user_id}, function(data) end)
                vRPclient.setHandcuffed(thePlayer, {false})
            end
        end
    end)
end

local locatiijail = {
    [1] = {cds = vec3(1175.2752685547,124.26182556152,80.783065795898), anim = "WORLD_HUMAN_GARDENER_LEAF_BLOWER", active = false},
    [2] = {cds = vec3(1170.6746826172,116.58428955078,80.880027770996), anim = "WORLD_HUMAN_GARDENER_PLANT", active = false},
    [3] = {cds = vec3(1164.2037353516,106.34200286865,80.638069152832), anim = "WORLD_HUMAN_PUSH_UPS", active = false},
    [4] = {cds = vec3(1158.8914794922,97.68586730957,80.555557250977), anim = "WORLD_HUMAN_SIT_UPS", active = false},
    [5] = {cds = vec3(1154.9154052734,91.903915405273,80.877090454102), anim = "WORLD_HUMAN_MUSCLE_FREE_WEIGHTS", active = false},
    [6] = {cds = vec3(1146.8233642578,96.592910766602,80.767486572266), anim = "ORLD_HUMAN_PUSH_UPS", active = false},
    [7] = {cds = vec3(1138.4384765625,100.02451324463,80.876876831055), anim = "WORLD_HUMAN_JOG_STANDING", active = false},
    [8] = {cds = vec3(1131.1488037109,95.182464599609,81.098907470703), anim = "WORLD_HUMAN_CONST_DRILL", active = false},
    [9] = {cds = vec3(1119.6403808594,92.36710357666,80.905990600586), anim = "WORLD_HUMAN_GARDENER_LEAF_BLOWER", active = false},
    [10] = {cds = vec3(1110.4565429688,96.795677185059,80.886245727539), anim = "WORLD_HUMAN_GARDENER_PLANT", active = false},
    [11] = {cds = vec3(1106.0504150391,105.21304321289,80.88680267334), anim = "WORLD_HUMAN_PUSH_UPS", active = false},
    [12] = {cds = vec3(1111.8591308594,115.24392700195,80.877456665039), anim = "WORLD_HUMAN_SIT_UPS", active = false},
    [13] = {cds = vec3(1117.6396484375,124.8327255249,80.772483825684), anim = "WORLD_HUMAN_MUSCLE_FREE_WEIGHTS", active = false},
    [14] = {cds = vec3(1126.4899902344,126.07537841797,80.715408325195), anim = "ORLD_HUMAN_PUSH_UPS", active = false},
    [15] = {cds = vec3(1136.1907958984,125.70545959473,80.933616638184), anim = "WORLD_HUMAN_JOG_STANDING", active = false},
    [16] = {cds = vec3(1146.5657958984,125.04048919678,81.88452911377), anim = "WORLD_HUMAN_CONST_DRILL", active = false},
    [17] = {cds = vec3(1156.4781494141,126.04486846924,81.781280517578), anim = "WORLD_HUMAN_GARDENER_LEAF_BLOWER", active = false},
    [18] = {cds = vec3(1164.7058105469,131.66664123535,80.696762084961), anim = "WORLD_HUMAN_GARDENER_PLANT", active = false},
    [19] = {cds = vec3(1174.8078613281,132.97729492188,80.841888427734), anim = "WORLD_HUMAN_GARDENER_PLANT", active = false},
}

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    local target = vRP.getUserSource({user_id})
    local user_id = vRP.getUserId({target})
    
    SetTimeout(2000, function()
        exports["oxmysql"]:query('SELECT * FROM vrp_users WHERE id = @user_id', {["user_id"] = user_id}, function(rows)
            if #rows > 0 then
                local aJailTime = tonumber(rows[1].aJailTime)
                local aJailReason = tostring(rows[1].aJailReason)
                if (aJailTime > 0) then
                    setInAJail(tonumber(user_id), tonumber(aJailTime), tostring(aJailReason), "")
                    TriggerClientEvent("ajail:config", source, locatiijail)
                    vRPclient.setHandcuffed(user_id, {false})
                end
            end
        end)
    end)
end)

local a_jail = {function(player, choice)
    local user_id = vRP.getUserId{player}
    vRP.prompt({player, "ID:", "", function(player, target_id)
        if target_id ~= nil and target_id ~= "" then
            vRP.prompt({player, "Checkpointuri:", "", function(player, jail_time)
                if jail_time ~= nil and jail_time ~= "" then
                    vRP.prompt({player, "Motiv:", "", function(player, jail_reason)
                        if jail_reason ~= nil and jail_reason ~= "" then
                            local target = vRP.getUserSource({tonumber(target_id)})
                            local ped = GetPlayerPed(target)
                            local entity = GetVehiclePedIsIn(ped)
                            if target ~= nil then
                                if tonumber(jail_time) > 500 then
                                    jail_time = 500
                                end
                                if tonumber(jail_time) < 1 then
                                    jail_time = 1
                                end
                                DeleteEntity(entity)
                                Wait(1)
                                vRPclient.teleport(target, {1179.6831054688,131.70155334473,80.889915466309})-- teleport to inside jail
                                TriggerClientEvent('chatMessage', -1, "", {0, 0, 0}, "Admin-ul ^1" .. GetPlayerName(player) .. " ^0i-a dat lui ^1" .. GetPlayerName(target) .. " ^0[^1" .. target_id .. "^0] " .. jail_time .. " (de) jail checkpoint-uri")
                                TriggerClientEvent('chatMessage', -1, "", {0, 0, 0}, "^3Motiv: ^0" .. jail_reason)
                                TriggerClientEvent("ajail:config", target, locatiijail)
                                local embed = {
                                    {
                                        ["color"] = 0xffff00,
                                        ["type"] = "rich",
                                        ["author"] = {
                                            ["name"] = GetPlayerName(player).."["..user_id.."]",
                                            ["icon_url"] = "https://cdn.discordapp.com/attachments/950408202158235718/972220998046871682/Dunko.png"
                                          } ,   
                                        ["description"] = "I-a dat jail lui **"..GetPlayerName(target).."["..target_id.."]** pentru **"..jail_reason.."**: **"..jail_time.." checkpoints**",                                            
                                        ["footer"] = {
                                          ["text"] = os.date("%d/%m/%y").." - "..os.date("%H:%M")
                                        }
                                    }
                                  }
                                
                                PerformHttpRequest('https://discord.com/api/webhooks/974683109461225532/WwGTtRnbTA3jfXaoPdHamSKrbehXFcV-Um45Mppcms4ciAqckxtMRrzK9AgrgAgE6mL6', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
                                
                                vRPclient.notify(player, {"~w~L-ai bagat in jail pe ~y~ " .. GetPlayerName(target) .. ""})
                                vRPclient.notify(player, {"~w~Checkpoints: ~y~" .. jail_time})
                                vRPclient.notify(player, {"~w~Motiv: ~y~" .. jail_reason})
                                vRP.closeMenu({player})
                                vRP.setHunger({tonumber(target_id), 0})
                                vRP.setThirst({tonumber(target_id), 0})
                                setInAJail(tonumber(target_id), tonumber(jail_time), tostring(jail_reason), GetPlayerName(player))
                            end
                        else
                            vRPclient.notify(player, {"~w~Motiv Invalid!"})
                        end
                    end})
                else
                    vRPclient.notify(player, {"~w~Checkpoint-urile nu pot fi mai putin de 1!"})
                end
            end})
        else
            vRPclient.notify(player, {"~w~Acest ID este Invalid!"})
        end
    end})
end, "Da jail unui jucator!"}

local a_unjail = {function(player, choice)
    local user_id = vRP.getUserId{player}
    vRP.prompt({player, "ID:", "", function(player, target_id)
        if target_id ~= nil and target_id ~= "" then
            local target = vRP.getUserSource({tonumber(target_id)})
            if target ~= nil then
                exports["oxmysql"]:query('SELECT * FROM vrp_users WHERE id = @user_id', {["user_id"] = target_id}, function(rows)
                    local aJailTime = tonumber(rows[1].aJailTime)
                    if (aJailTime == 0) then
                        vRPclient.notify(player, {"~w~Jucatorul nu este in ~y~Admin Jail!"})
                    else
                        setInAJail(tonumber(target_id), tonumber(0), tostring(" "), "0")
                        vRPclient.setHandcuffed(target, {false})
                        vRPclient.teleport(target, {-139.38557434082,6311.5747070312,31.509239196778})
                        vRPclient.notify(target, {"~w~Ai primit unjail !"})
                        vRPclient.notify(player, {"~w~L-ai scos pe ~y~" .. GetPlayerName(target) .. " ~w~de la Admin Jail"})
                        TriggerClientEvent("chatMessage", -1, "Admin-ul ^1" .. GetPlayerName(player) .. "^0 i-a dat unjail lui ^1" .. GetPlayerName(target))
                        local embed = {
                            {
                                ["color"] = 0xffff00,
                                ["type"] = "rich",
                                ["author"] = {
                                    ["name"] = GetPlayerName(player).."["..user_id.."]",
                                    ["icon_url"] = "https://cdn.discordapp.com/attachments/950408202158235718/972220998046871682/Dunko.png"
                                  } ,   
                                ["description"] = "I-a dat unjail lui **"..GetPlayerName(target).."["..target_id.."]**",                                            
                                ["footer"] = {
                                  ["text"] = os.date("%d/%m/%y").." - "..os.date("%H:%M")
                                }
                            }
                          }
                        
                        PerformHttpRequest('https://discord.com/api/webhooks/974683109461225532/WwGTtRnbTA3jfXaoPdHamSKrbehXFcV-Um45Mppcms4ciAqckxtMRrzK9AgrgAgE6mL6', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
                    end
                end)
            else
                vRPclient.notify(player, {"~w~Acest ID este Invalid!"})
            end
        else
            vRPclient.notify(player, {"~w~Nu ai selectat un id!"})
        end
    end})
end, "Scoate jail-ul unui jucator!"}

local a_offlineJail = {function(player, choice)
    local user_id = vRP.getUserId({player})
    vRP.prompt({player, "ID:", "", function(player, target_id)
        if target_id ~= nil and target_id ~= "" then
            exports.oxmysql:query("SELECT aJailTime FROM vrp_users WHERE id = @user_id", {["@user_id"] = target_id}, function(rows)
                if #rows == 0 then
                    vRPclient.notify(player, {"~w~Acest jucator nu exista!"})
                else
                    vRP.prompt({player, "Checkpointuri:", "", function(player, jail_time)
                        if jail_time ~= nil and jail_time ~= "" then
                            vRP.prompt({player, "Motiv:", "", function(player, jail_reason)
                                if jail_reason ~= nil and jail_reason ~= "" then
                                    local target = vRP.getUserSource({tonumber(target_id)})
                                    if target ~= nil then
                                        if tonumber(jail_time) > 500 then
                                            jail_time = 500
                                        end
                                        if tonumber(jail_time) < 1 then
                                            jail_time = 1
                                        end
                                        setInAJailOffline(tonumber(target_id), tonumber(jail_time), jail_reason)
                                        TriggerClientEvent('chatMessage', -1, "", {0, 0, 0}, "Admin-ul ^1" .. GetPlayerName(player) .. " ^0i-a dat lui ^1" .. GetPlayerName(target) .. " ^0[^1" .. target_id .. "^0] " .. jail_time .. " (de) jail checkpoint-uri: "..reason)
                                        local embed = {
                                            {
                                                ["color"] = 0xffff00,
                                                ["type"] = "rich",
                                                ["author"] = {
                                                    ["name"] = GetPlayerName(player).."["..user_id.."]",
                                                    ["icon_url"] = "https://cdn.discordapp.com/attachments/950408202158235718/972220998046871682/Dunko.png"
                                                  } ,   
                                                ["description"] = "I-a dat jail offline lui **"..GetPlayerName(target).."["..target_id.."]** pentru **"..jail_reason.."**: **"..jail_time.." checkpoints**",                                            
                                                ["footer"] = {
                                                  ["text"] = os.date("%d/%m/%y").." - "..os.date("%H:%M")
                                                }
                                            }
                                          }
                                        
                                        PerformHttpRequest('https://discord.com/api/webhooks/974683109461225532/WwGTtRnbTA3jfXaoPdHamSKrbehXFcV-Um45Mppcms4ciAqckxtMRrzK9AgrgAgE6mL6', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
                                        vRPclient.notify(player, {"~w~L-ai bagat in jail pe ~y~ " .. GetPlayerName(target) .. ""})
                                        vRPclient.notify(player, {"~w~Checkpoints: ~y~" .. jail_time})
                                        vRPclient.notify(player, {"~w~Motiv: ~y~" .. jail_reason})
                                    end
                                end
                            end})
                        end
                    end})
                end
            end)
        end
    end})
end, "Da jail unui jucator offline"}
-------------------Puscarie Admin J-------------------
-- dynamic jail
local ch_jail = {function(player, choice)
    vRPclient.getNearestPlayers(player, {15}, function(nplayers)
        local user_list = ""
        for k, v in pairs(nplayers) do
            user_list = user_list .. "[" .. vRP.getUserId({k}) .. "]" .. vRP.getPlayerName({k}) .. " | "
        end
        if user_list ~= "" then
            vRP.prompt({player, "Jucatori Apropiati:" .. user_list, "", function(player, target_id)
                if target_id ~= nil and target_id ~= "" then
                    vRP.prompt({player, "Inchisoare Timp Luni:", "", function(player, jail_time)
                        if tonumber(jail_time) and jail_time ~= nil and jail_time ~= "" then
                            local target = vRP.getUserSource({tonumber(target_id)})
                            if target ~= nil then
                                if ((tonumber(jail_time) >= 60) and (jail_time ~= nil) and (jail_time ~= "")) then
                                    jail_time = 60
                                end
                                if ((tonumber(jail_time) <= 1) and (jail_time ~= nil) and (jail_time ~= "")) then
                                    jail_time = 1
                                end
                                
                                vRPclient.isHandcuffed(target, {}, function(handcuffed)
                                    if handcuffed then
                                        BMclient.loadFreeze(target, {true})
                                        SetTimeout(4000, function()
                                            BMclient.loadFreeze(target, {false})
                                        end)
                                        local celula = math.random(1, 10)
                                        if celula == 1 then
                                            vRPclient.teleport(target, {1641.5477294922, 2570.4819335938, 45.564788818359})
                                        elseif celula == 2 then
                                            vRPclient.teleport(target, {1650.9091796875, 2570.326171875, 45.56481552124})
                                        elseif celula == 3 then
                                            vRPclient.teleport(target, {1629.4643554688, 2569.84375, 45.564834594727})
                                        elseif celula == 4 then
                                            vRPclient.teleport(target, {1641.5477294922, 2570.4819335938, 45.564788818359})
                                        elseif celula == 5 then
                                            vRPclient.teleport(target, {1650.9091796875, 2570.326171875, 45.56481552124})
                                        elseif celula == 6 then
                                            vRPclient.teleport(target, {1629.4643554688, 2569.84375, 45.564834594727})
                                        elseif celula == 7 then
                                            vRPclient.teleport(target, {1641.5477294922, 2570.4819335938, 45.564788818359})
                                        elseif celula == 8 then
                                            vRPclient.teleport(target, {1650.9091796875, 2570.326171875, 45.56481552124})
                                        elseif celula == 9 then
                                            vRPclient.teleport(target, {1629.4643554688, 2569.84375, 45.564834594727})
                                        elseif celula == 10 then
                                            vRPclient.teleport(target, {1641.5477294922, 2570.4819335938, 45.564788818359})
                                        end
                                        vRPclient.notify(target, {"~w~Ai fost trimis la puscarie"})
                                        vRPclient.notify(player, {"~w~L-ai bagat la puscarie pe (~b~" .. target_id .. "~w~) pentru ~y~" .. jail_time .. " ~w~Minute"})
                                        vRP.setHunger({tonumber(target_id), 0})
                                        vRP.setThirst({tonumber(target_id), 0})
                                        jail_clock(tonumber(target_id), tonumber(jail_time))
                                        local user_id = vRP.getUserId({player})
                                    else
                                        vRPclient.notify(player, {"~w~Acel jucator nu este incatusat."})
                                    end
                                end)
                            else
                                vRPclient.notify(player, {"~w~Acel ID este invalid."})
                            end
                        else
                            vRPclient.notify(player, {"~w~Timp-ul la inchisoare nu poate fi gol."})
                        end
                    end})
                else
                    vRPclient.notify(player, {"~w~Nici un jucator ID selectat."})
                end
            end})
        else
            vRPclient.notify(player, {"~w~Nici un jucator apropiat."})
        end
    end)
end, "Trimite un jucator la puscarie."}

-- dynamic unjail
local ch_unjail = {function(player, choice)
    vRP.prompt({player, "Jucator ID:", "", function(player, target_id)
        if target_id ~= nil and target_id ~= "" then
            vRP.getUData({tonumber(target_id), "vRP:jail:time", function(value)
                if value ~= nil then
                    custom = json.decode(value)
                    if custom ~= nil then
                        local user_id = vRP.getUserId({player})
                        if ((tonumber(custom) > 0) and (custom ~= nil) and (custom ~= "")) then
                            local target = vRP.getUserSource({tonumber(target_id)})
                            if target ~= nil then
                                unjailed[target] = tonumber(target_id)
                                vRPclient.notify(player, {"~w~Jucatorul va fi eliberat in curand."})
                                vRPclient.notify(target, {"~w~Cineva te-a salvat de la puscarie."})
                            else
                                vRPclient.notify(player, {"~w~Acel ID este invalid."})
                            end
                        else
                            vRPclient.notify(player, {"~w~Jucatorul nu este la puscarie."})
                        end
                    end
                end
            end})
        else
            vRPclient.notify(player, {"~w~Nici un jucator ID selectat."})
        end
    end})
end, "Elibereaza un jucator."}

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    local target = vRP.getUserSource({user_id})
    SetTimeout(2000, function()
        local rows = exports.oxmysql:executeSync("SELECT `aJailTime`, `aJailReason` FROM vrp_users WHERE id = @user_id", {user_id = user_id})
        if #rows > 0 then
            local aJailTime = tonumber(rows[1].aJailTime)
            local aJailReason = tostring(rows[1].aJailReason)
            if (aJailTime > 0) and (aJailTime ~= nil) then
                BMclient.setInAJail(source, {aJailTime, aJailReason, "Dunko Team"})
                vRPclient.setInEvent(target, {true})
            end
        end
    end)
    SetTimeout(5000, function()
        local custom = {}
        vRP.getUData({user_id, "vRP:jail:time", function(value)
            if value ~= nil then
                custom = json.decode(value)
                if custom ~= nil then
                    if tonumber(custom) > 0 then
                        BMclient.loadFreeze(target, {true})
                        SetTimeout(15000, function()
                            BMclient.loadFreeze(target, {false})
                        end)
                        vRPclient.setHandcuffed(target, {true})
                        vRPclient.teleport(target, {1688.3275146484, 2518.7783203125, -120.84991455078})-- teleport inside jail
                        vRPclient.notify(target, {"~w~Termina sentinta."})
                        vRP.setHunger({tonumber(user_id), 0})
                        vRP.setThirst({tonumber(user_id), 0})
                        jail_clock(tonumber(user_id), tonumber(custom))
                    end
                end
            end
        end})
    end)
end)

-- dynamic fine
local ch_fine = {function(player, choice)
    vRPclient.getNearestPlayers(player, {15}, function(nplayers)
        local user_list = ""
        for k, v in pairs(nplayers) do
            user_list = user_list .. "[" .. vRP.getUserId({k}) .. "]" .. vRP.getPlayerName({k}) .. " | "
        end
        if user_list ~= "" then
            vRP.prompt({player, "Jucatori Apropiati:" .. user_list, "", function(player, target_id)
                if target_id ~= nil and target_id ~= "" then
                    vRP.prompt({player, "Amenda Suma:", "100", function(player, fine)
                        if tonumber(fine) and fine ~= nil and fine ~= "" then
                            vRP.prompt({player, "Amenda Motiv:", "", function(player, reason)
                                if reason ~= nil and reason ~= "" then
                                    local target = vRP.getUserSource({tonumber(target_id)})
                                    if target ~= nil then
                                        if ((tonumber(fine) >= 10000000) and (fine ~= nil) and (fine ~= "")) then
                                            fine = 10000000
                                        end
                                        if ((tonumber(fine) <= 100) and (fine ~= nil) and (fine ~= "")) then
                                            fine = 100
                                        end
                                        if vRP.tryFullPayment({tonumber(target_id), tonumber(fine)}) then
                                            vRP.insertPoliceRecord({tonumber(target_id), lang.police.menu.fine.record({reason, fine})})
                                            vRPclient.notify(player, {lang.police.menu.fine.fined({reason, fine})})
                                            vRPclient.notify(target, {lang.police.menu.fine.notify_fined({reason, fine})})
                                            local user_id = vRP.getUserId({player})
                                            vRP.closeMenu({player})
                                        else
                                            vRPclient.notify(player, {lang.money.not_enough()})
                                        end
                                    else
                                        vRPclient.notify(player, {"~w~Acel ID este invalid"})
                                    end
                                else
                                    vRPclient.notify(player, {"~w~Nu poti amenda degeaba fara motiv"})
                                end
                            end})
                        else
                            vRPclient.notify(player, {"~w~Amenda ta trebuie sa fie o valoare"})
                        end
                    end})
                else
                    vRPclient.notify(player, {"~w~Nici un jucator ID selectat"})
                end
            end})
        else
            vRPclient.notify(player, {"~w~Nici un jucator apropiat"})
        end
    end)
end, "Amenda un jucator apropiat."}

local ch_spawnveh = {function(player, choice)
    local user_id = vRP.getUserId({player})
    vRP.prompt({player, "Model Vehicul:", "", function(player, model)
        if model ~= nil and model ~= "" then
            BMclient.spawnVehicle(player, {model})
            vRP.sendStaffMessage({"Admin-ul ^4" .. vRP.getPlayerName({player}) .. " ^0a spawnat modelul ^4" .. model .. "^0"})
        else
            vRPclient.notify(player, {"~w~Trebuie sa pui un model de vehicul."})
        end
    end})
end, "Spawneaza un model vehicul."}

local a_revive = {function(player, choice)
    local user_id = vRP.getUserId{player}
    vRP.prompt({player, "ID:", "", function(player, target_id)
        if target_id ~= nil and target_id ~= "" then
            local nplayer = vRP.getUserSource({tonumber(target_id)})
            if nplayer ~= nil then
                vRPclient.isInComa(nplayer, {}, function(in_coma)
                    if in_coma then
                        vRPclient.varyHealth(nplayer, {100})
                        SetTimeout(1000, function()
                            vRPclient.varyHealth(nplayer, {100})
                        end)
                        vRP.sendStaffMessage({"Admin-ul ^4" .. vRP.getPlayerName({player}) .. " ^0i-a dat revive lui ^4" .. vRP.getPlayerName({nplayer}) .. " (" .. target_id .. ")"})
                        local embed = {
                            {
                                ["color"] = 0xffff00,
                                ["type"] = "rich",
                                ["author"] = {
                                    ["name"] = GetPlayerName(player).."["..user_id.."]",
                                    ["icon_url"] = "https://cdn.discordapp.com/attachments/950408202158235718/972220998046871682/Dunko.png"
                                  } ,   
                                ["description"] = "I-a dat revive lui **"..GetPlayerName(nplayer).."["..target_id.."]**",                                            
                                ["footer"] = {
                                  ["text"] = os.date("%d/%m/%y").." - "..os.date("%H:%M")
                                }
                            }
                          }
                        
                        PerformHttpRequest('https://discord.com/api/webhooks/974682207543255060/yviKLumawmLAqlGmwga0c21hYIsTHov7cwynvKEA0M9WbQUDkpLknUV7WC8uO0sdCNZR', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
                    
                    else
                        vRPclient.notify(player, {"~w~Jucatorul nu este in coma."})
                    end
                end)
            else
                vRPclient.notify(player, {"~w~Acest ID pare invalid."})
            end
        else
            vRPclient.notify(player, {"~w~Nu ai selectat niciun ID."})
        end
    end})
end}

local muted = {}

local a_mute = {function(player, choice)
    vRP.prompt({player, "Player ID:", "", function(player, target_id)
        if target_id ~= nil and target_id ~= "" then
            local nplayer = vRP.getUserSource({tonumber(target_id)})
            if nplayer then
                vRP.prompt({player, "Time:", "", function(player, minutes)
                    if (tonumber(minutes)) then
                        vRP.prompt({player, "Motiv:", "", function(player, reason)
                            if (tostring(reason)) then
                                if (muted[nplayer] == nil) then
                                    muted[nplayer] = nplayer
                                    TriggerClientEvent('chatMessage', -1, "^1" .. GetPlayerName(nplayer) .. " ^0a primit mute ^1" .. minutes .. " ^0minute de la ^1" .. GetPlayerName(player))
                                    local embed = {
                                        {
                                            ["color"] = 0xffff00,
                                            ["type"] = "rich",
                                            ["author"] = {
                                                ["name"] = GetPlayerName(player).."["..user_id.."]",
                                                ["icon_url"] = "https://cdn.discordapp.com/attachments/950408202158235718/972220998046871682/Dunko.png"
                                              } ,   
                                            ["description"] = "I-a dat mute lui **"..GetPlayerName(nplayer).."["..target_id.."]** pentru **"..reason.."**: **"..minutes.." minute**",                                            
                                            ["footer"] = {
                                              ["text"] = os.date("%d/%m/%y").." - "..os.date("%H:%M")
                                            }
                                        }
                                      }
                                    PerformHttpRequest('https://discord.com/api/webhooks/974682316444143626/bHE-6N0cwOminhoUAYhHYojoo3AHXt_Dm0q-UL2rC_kntbese2aBrBUTh59xVT231ciJ', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
                                    
                                    SetTimeout(minutes * 60000, function()
                                        if (muted[nplayer] ~= nil) then
                                            muted[nplayer] = nil
                                            TriggerClientEvent('chatMessage', nplayer, "^1Failed: ^0Mute-ul ti-a expirat!")
                                        end
                                    
                                    end)
                                else
                                    TriggerClientEvent('chatMessage', player, "^1Failed: ^0Jucatorul are deja mute!")
                                end
                            else
                                vRPclient.notify(player, {"~r~Failed"})
                            end
                        end})
                    end
                end})
            else
                vRPclient.notify(player, {"~w~Player-ul nu a fost gasit"})
            end
        else
            vRPclient.notify(player, {"~w~Nu ai selectat un player"})
        end
    end})
end, "Da mute la un player"}

local a_unmute = {function(player, choice)
    vRP.prompt({player, "Player ID:", "", function(player, target_id)
        if target_id ~= nil and target_id ~= "" then
            local nplayer = vRP.getUserSource({tonumber(target_id)})
            if nplayer then
                if (muted[nplayer] ~= nil) then
                    TriggerClientEvent('chatMessage', -1, "^1" .. GetPlayerName(nplayer) .. " ^0a primit unmute de la ^1" .. GetPlayerName(player))
                    local embed = {
                        {
                            ["color"] = 0xffff00,
                            ["type"] = "rich",
                            ["author"] = {
                                ["name"] = GetPlayerName(player).."["..user_id.."]",
                                ["icon_url"] = "https://cdn.discordapp.com/attachments/950408202158235718/972220998046871682/Dunko.png"
                              } ,   
                            ["description"] = "I-a dat unmute lui **"..GetPlayerName(nplayer).."["..target_id.."]**",                                            
                            ["footer"] = {
                              ["text"] = os.date("%d/%m/%y").." - "..os.date("%H:%M")
                            }
                        }
                      }
                    
                    PerformHttpRequest('https://discord.com/api/webhooks/974682316444143626/bHE-6N0cwOminhoUAYhHYojoo3AHXt_Dm0q-UL2rC_kntbese2aBrBUTh59xVT231ciJ', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
                    muted[nplayer] = nil
                else
                    vRPclient.notify(player, {"~w~Player-ul nu are mute"})
                end
            else
                vRPclient.notify(player, {"~w~Nu a fost gasit player-ul"})
            end
        else
            vRPclient.notify(player, {"~w~Nu ai selectat niciun id"})
        end
    end})
end, "Unmute a player."}


AddEventHandler('chatMessage', function(thePlayer, color, message)
    if (muted[thePlayer] ~= nil) then
        TriggerClientEvent('chatMessage', thePlayer, "^1Failed ^0Nu poti vorbii ai mute !")
        CancelEvent()
    end
end)

RegisterCommand('arevive', function(source, args, msg)
    local user_id = vRP.getUserId({source})
    msg = msg:sub(9)
    if msg:len() >= 1 then
        msg = tonumber(msg)
        local target = vRP.getUserSource({msg})
        if target ~= nil then
            local target_id = vRP.getUserId({target})
            if vRP.isUserTrialHelper({user_id}) then
                vRPclient.varyHealth(target, {100})
                
                vRP.sendStaffMessage({"Admin-ul ^1" .. vRP.getPlayerName({source}) .. " ^0i-a dat revive lui ^1" .. vRP.getPlayerName({target}) .. " (" .. target_id .. ")"})
                local embed = {
                    {
                        ["color"] = 0xffff00,
                        ["type"] = "rich",
                        ["author"] = {
                            ["name"] = GetPlayerName(source).."["..user_id.."]",
                            ["icon_url"] = "https://cdn.discordapp.com/attachments/950408202158235718/972220998046871682/Dunko.png"
                          } ,   
                        ["description"] = "I-a dat revive lui **"..GetPlayerName(target).."["..msg.."]**",                                            
                        ["footer"] = {
                          ["text"] = os.date("%d/%m/%y").." - "..os.date("%H:%M")
                        }
                    }
                  }
                
                PerformHttpRequest('https://discord.com/api/webhooks/974682207543255060/yviKLumawmLAqlGmwga0c21hYIsTHov7cwynvKEA0M9WbQUDkpLknUV7WC8uO0sdCNZR', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
            else
                TriggerClientEvent('chatMessage', source, "^1^0Nu ai acces la aceasta comanda.")
            end
        else
            TriggerClientEvent('chatMessage', source, "^1^0Player-ul nu este conectat.")
        end
    else
        TriggerClientEvent('chatMessage', source, "^1^0/arevive <user-id>")
    end
end)

vRP.registerMenuBuilder({"admin", function(add, data)
    local user_id = vRP.getUserId({data.player})
    if user_id ~= nil then
        local choices = {}
        
        if vRP.isUserLiderAdministrator({user_id}) then
            choices["SpawnVeh"] = ch_spawnveh
        end
        if vRP.isUserAdministrator({user_id}) then
            choices["Blips"] = ch_blips
        end
        if vRP.isUserModerator({user_id}) then
            choices["Mute"] = a_mute
            choices["UnMute"] = a_unmute
        end
        if vRP.isUserHelper({user_id}) then
            choices["Admin Jail"] = a_jail
            choices["Admin Revive"] = a_revive
            choices["TpToWaypoint"] = choice_tptowaypoint
            choices["Admin UnJail"] = a_unjail
            choices["Admin Jail Offline"] = a_offlineJail
        end
        
        add(choices)
    end
end})


vRP.registerMenuBuilder({"jucator", function(add, data)
    local user_id = vRP.getUserId({data.player})
    if user_id ~= nil then
        local choices = {}

        if vRP.hasGroup({user_id, "Hacker"}) then
            choices["Hack"] = ch_hack
        end
        
        add(choices)
    end
end})

vRP.registerMenuBuilder({"jucator", function(add, data)
    local user_id = vRP.getUserId({data.player})
    if user_id ~= nil then
        local choices = {}
        
        choices[lang.police.menu.check.title()] = jucator_check
        choices["Fix Hair"] = ch_fixhair
        choices["Clear Skin"] = ch_clearskin
        choices["Curata Inventar"] = clear_inventory
        choices["Fix Skin"] = reload_skin
        
        if vRP.hasGroup({user_id, "Specialist Arme"}) then
            choices["Strange Armele"] = choice_store_weapons
        end
        
        add(choices)
    end
end})

vRP.registerMenuBuilder({"police", function(add, data)
    local user_id = vRP.getUserId({data.player})
    if user_id ~= nil then
        local choices = {}
        
        if vRP.hasGroup({user_id, "onduty"}) then
            if vRP.isUserInFaction({user_id, "Politie"}) or vRP.isUserInFaction({user_id, "Jandarmerie"}) then
                choices["Trimite la inchisoare"] = ch_jail
                choices["Scoate de la inchisoare"] = ch_unjail
                choices["Amendeaza"] = ch_fine
                choices["Ridica"] = ch_drag
            end
            add(choices)
        end
    end
end})

local usedrugscooldown = {}
vRP.defInventoryItem({"adrenalina","Adrenalina","", 
function(args)
  local choices = {} 
  choices["Foloseste"] = {function(player,choice)
local user_id = vRP.getUserId({player})
if not usedrugscooldown[user_id] then usedrugscooldown[user_id] = 0 end

if (os.time() - usedrugscooldown[user_id]) < 60 then 
	vRPclient.notify(player,{"Asteapta "..(60 - (os.time() - usedrugscooldown[user_id])).." secunde pentru a consuma adrenalina"})
	return
else
	vRPclient.isInComa(player,{}, function(in_coma)
	  if not in_coma then
		if vRP.tryGetInventoryItem({user_id, "adrenalina", 1, "Folosesti adrenalina"}) then
		TriggerClientEvent('3dme:shareDisplay', -1, "~w~Isi administreaza o seringa de ~r~adrenalina~w~", source)
		   vRPclient.varyHealth(player,{50})
		   vRP.varyHunger({user_id, -100})
		   vRP.varyThirst({user_id, -100})
		   usedrugscooldown[user_id] = os.time()
		end
	  else
		vRPclient.notify(player, {"Esti mort!"})
	  end
	end)
end
  end}
  return choices
end,
0.1})

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    usedrugscooldown[user_id] = 0
end)

RegisterCommand("dacie", function(source)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if vRP.isUserTrialHelper({user_id}) then
		vRPclient.spawnVehicle(source, {"logan"})
	else
		vRPclient.notify(player, {"Nu ai acces la aceasta comanda!"})
	end
end)

RegisterCommand("faggio", function(source)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if vRP.isUserTrialHelper({user_id}) then
		vRPclient.spawnVehicle(source, {"faggio"})
	else
		vRPclient.notify(player, {"Nu ai acces la aceasta comanda!"})
	end
end)

RegisterCommand("veh", function(player)
    local user_id = vRP.getUserId({player})
    if(vRP.isUserModerator({user_id}))then -- aici schimbi depinde cum ai tu server-ul sau cum vrea inima ta
        vRP.prompt({player,"Vehicle Model:","",function(player,model)
            if model ~= nil and model ~= "" then 
              BMclient.spawnVehicle(player,{model})
            else
              vRPclient.notify(player,{"Nu poti folosi aceasta comanda."})
            end
        end})
    end
end)