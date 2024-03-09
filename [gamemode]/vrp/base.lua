local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")
local Lang = module("lib/Lang")
Debug = module("lib/Debug")

local config = module("cfg/base")
local version = module("version")
Debug.active = config.debug

vRP = {}
Proxy.addInterface("vRP", vRP)

tvRP = {}
Tunnel.bindInterface("vRP", tvRP)

local dict = module("cfg/lang/" .. config.lang) or {}
vRP.lang = Lang.new(dict)

vRPclient = Tunnel.getInterface("vRP", "vRP")

vRPsb = Proxy.getInterface("vrp_scoreboard")
vRPjobs = Proxy.getInterface("vRP_jobs")
vRPin = Proxy.getInterface("vrp_hud_inventory")
vRPbiz = Proxy.getInterface("vRP_biz")

vRP.users = {}
vRP.rusers = {}
vRP.user_tables = {}
vRP.user_tmp_tables = {}
vRP.user_sources = {}

hoursPlayed = {}

print("Server is starting...")

--- sql.
-- cbreturn user id or nil in case of error (if not found, will create it)
function vRP.getUserIdByIdentifiers(ids, cbr)
    local task = Task(cbr)
    
    if ids   and #ids then
        local i = 0
  
    local function search()
        i = i+1
        if i <= #ids then
            if(string.match(ids[i], "ip:"))then
                search()
            else
                exports.oxmysql:query("SELECT user_id FROM vrp_user_ids WHERE identifier = @identifier", {['@identifier'] = ids[i]}, function (rows)
                      if #rows > 0 then
                          task({rows[1].user_id})
                      else
                          search()
                      end
                end)
            end
        else
          exports.oxmysql:query("INSERT INTO vrp_users(whitelisted,banned,faction,isFactionLeader,isFactionCoLeader,factionRank,username) VALUES(false,false,'user',0,0,'none','Username')",{['@whitelisted'] = 0, ['@banned'] = 0}, function (rows)
            if rows  then
                    local user_id = rows["insertId"]
                    for l,w in pairs(ids) do
                            exports.oxmysql:query("INSERT INTO vrp_user_ids(identifier,user_id) VALUES(@identifier,@user_id)", {['@user_id'] = user_id, ['@identifier'] = w})
                    end
  
                    task({user_id})
                else
                    task()
                end
            end)
          end
        end
        search()
    else
        task()
     end
  end
  
function vRP.ReLoadChar(source)
    local name = GetPlayerName(source)
    local ids = GetPlayerIdentifiers(source)
    vRP.getUserIdByIdentifiers(ids, function(user_id)
        if user_id   then
            if vRP.rusers[user_id] == nil then -- not present on the server, init
                vRP.users[ids[1]] = user_id
                vRP.rusers[user_id] = ids[1]
                vRP.user_tables[user_id] = {}
                vRP.user_tmp_tables[user_id] = {}
                vRP.user_sources[user_id] = source
                vRP.getUData(user_id, "vRP:datatable", function(sdata)
                    local data = json.decode(sdata)
                    if type(data) == "table" then vRP.user_tables[user_id] = data end
                    local tmpdata = vRP.getUserTmpTable(user_id)
                    vRP.getLastLogin(user_id, function(last_login)
                        tmpdata.last_login = last_login or ""
                        tmpdata.spawns = 0
                        local ep = vRP.getPlayerEndpoint(source)
                        local last_login_stamp = ep .. " " .. os.date("%H:%M:%S %d/%m/%Y")
                        exports.oxmysql:query("UPDATE vrp_users SET last_login = @last_login WHERE id = @user_id", {['@user_id'] = user_id, ['@last_login'] = last_login_stamp})
                        TriggerEvent("vRP:playerJoin", user_id, source, name, tmpdata.last_login)
                        TriggerClientEvent("VRP:CheckIdRegister", source)
                    end)
                end)
            else
                TriggerEvent("vRP:playerRejoin", user_id, source, name)
                TriggerClientEvent("VRP:CheckIdRegister", source)
                local tmpdata = vRP.getUserTmpTable(user_id)
                tmpdata.spawns = 0
            end
        end
    end)
end

RegisterNetEvent("VRP:CheckID")
AddEventHandler("VRP:CheckID", function()
    local user_id = vRP.getUserId(source)
    if not user_id then
        vRP.ReLoadChar(source)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200000)
        for _, playerId in ipairs(GetPlayers()) do
            Wait(1000)
            local u_id = vRP.getUserId(playerId)
            if u_id == nil then
                DropPlayer(playerId, "White: Reintra pe server , ai intrat fara id!")
            end
        end
    end
end)

Citizen.CreateThread(function()
    local uptimeMinute, uptimeHour = 0, 0
    
    while true do
        Citizen.Wait(1000 * 60)-- every minute
        uptimeMinute = uptimeMinute + 1
        
        if uptimeMinute == 60 then
            uptimeMinute = 0
            uptimeHour = uptimeHour + 1
        end
        
        ExecuteCommand(string.format("sets UpTime \"%02dh %02dm\"", uptimeHour, uptimeMinute))
    end
end)

-- return identification string for the source (used for non vRP identifications, for rejected players)
function vRP.getSourceIdKey(source)
    local ids = GetPlayerIdentifiers(source)
    local idk = "idk_"
    for k, v in pairs(ids) do
        idk = idk .. v
    end
    
    return idk
end

function vRP.getUserIdentifiers(player, type)
    if (type == "*") then
        local steamid = "Invalid-Steam"
        local license = "Invalid-License"
        local discord = "Invalid-User"
        local xbl = "Invalid-Xbox"
        local liveid = "Invalid-Live"
        for k, v in pairs(GetPlayerIdentifiers(player)) do
            if v:match("steam") then
                steamid = v:gsub("steam:", "")
            elseif v:match("license") then
                license = v:gsub("license:", "")
            elseif v:match("xbl") then
                xbl = v:gsub("xbl:", "")
            elseif v:match("ip") then
                ip = v:gsub("ip:", "")
            elseif v:match("discord") then
                discord = v:gsub("discord:", "")
            elseif v:match("live") then
                liveid = v:gsub("live:", "")
            end
        end
        return steamid, license, discord, xbl, liveid
    else
        local which = "Invalid-" .. type
        for k, v in pairs(GetPlayerIdentifiers(player)) do
            if v:match(type) then
                which = v:gsub(type .. ":", "")
            end
        end
        return which
    end
end

function vRP.getPlayerEndpoint(player)
    return GetPlayerEP(player) or "0.0.0.0"
end

function vRP.getPlayerName(player)
    return GetPlayerName(player) or "Unknown"
end

function vRP.formatMoney(amount)
    local left, num, right = string.match(tostring(amount), '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1.'):reverse()) .. right
end

function vRP.getBannedExpiredDate(time)
    local ora = os.date("%H:%M:%S")
    local creation_date = os.date("%d/%m/%Y")
    local dayValue, monthValue, yearValue = string.match(creation_date, '(%d+)/(%d+)/(%d+)')
    dayValue, monthValue, yearValue = tonumber(dayValue), tonumber(monthValue), tonumber(yearValue)
    return "" .. os.date("%d/%m/%Y", os.time{year = yearValue, month = monthValue, day = dayValue} + time * 24 * 60 * 60) .. " : " .. ora .. ""
end

--sql
function vRP.isBanned(user_id, cbr)
    local task = Task(cbr, {false})
    
    exports.oxmysql:query("SELECT banned FROM vrp_users WHERE id = @user_id", {user_id = user_id}, function(rows)
        if #rows > 0 then
            task({rows[1].banned})
        else
            task()
        end
    end)
end

function vRP.setBanned(user_id, banned, reason, by)
    if (banned == false) then
        exports.oxmysql:query("UPDATE vrp_users SET banned = @banned, bannedReason = @reason, bannedBy = @bannedBy WHERE id = @user_id", {user_id = user_id, banned = banned, reason = reason, bannedBy = ""}, function() end)
    else
        if (tostring(by) ~= "Consola") then
            theAdmin = vRP.getUserId(by)
            adminName = vRP.getPlayerName(by)
            banBy = adminName .. " [" .. theAdmin .. "]"
        else
            banBy = "Consola"
        end
        exports.oxmysql:query("UPDATE vrp_users SET banned = @banned, bannedReason = @reason, bannedBy = @bannedBy WHERE id = @user_id", {user_id = user_id, banned = banned, reason = reason, bannedBy = banBy}, function() end)
    end
end

function vRP.setBannedTemp(user_id, banned, reason, by, timp)
    if (banned == false) then
        exports.oxmysql:query("UPDATE vrp_users SET banned = @banned, bannedTemp = 0, bannedReason = @reason, bannedBy = @bannedBy, BanTempZile = 0, BanTempData = @date, BanTempExpire = @expireDate WHERE id = @user_id", {user_id = user_id, banned = banned, reason = "", bannedBy = "", date = "", expireDate = ""}, function() end)
    else
        banTimp = os.time() + timp * 24 * 60 * 60 --[os.time() + day * hours_in_a_day * minutes_in_an_hour * seconds_in_an_minute *]
        data = os.date("%d/%m/%Y : %H:%M:%S")
        expireDate = vRP.getBannedExpiredDate(timp)
        if (tostring(by) ~= "Consola") then
            theAdmin = vRP.getUserId(by)
            adminName = vRP.getPlayerName(by)
            banBy = adminName .. " [" .. theAdmin .. "]"
        else
            banBy = "Consola"
        end
        exports.oxmysql:query("UPDATE vrp_users SET bannedTemp = @durata, bannedReason = @reason, bannedBy = @bannedBy, BanTempZile = @time, BanTempData = @date, BanTempExpire = @expireDate WHERE id = @user_id", {user_id = user_id, durata = banTimp, reason = reason, bannedBy = banBy, time = timp, date = data, expireDate = expireDate}, function() end)
    end
end

function vRP.isWhitelisted(user_id, cbr)
    local task = Task(cbr, {false})
    
    exports.oxmysql:query("SELECT whitelisted FROM vrp_users WHERE id = @user_id", {user_id = user_id}, function(rows)
        if #rows > 0 then
            task({rows[1].whitelisted})
        else
            task()
        end
    end)
end

function vRP.setWhitelisted(user_id, whitelisted)
    exports.oxmysql:query("UPDATE vrp_users SET whitelisted = @whitelisted WHERE id = @user_id", {user_id = user_id, whitelisted = whitelisted}, function() end)
end

function vRP.getLastLogin(user_id, cbr)
    local task = Task(cbr, {""})
    
    exports.oxmysql:query("SELECT last_login FROM vrp_users WHERE id = @user_id", {user_id = user_id}, function(rows)
        if #rows > 0 then
            task({rows[1].last_login})
        else
            task()
        end
    end)
end

function vRP.setUData(user_id, key, value)
    exports.oxmysql:query("REPLACE INTO vrp_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)", {user_id = user_id, key = key, value = value}, function() end)
end

function vRP.getUData(user_id, key, cbr)
    local task = Task(cbr, {""})
    
    exports.oxmysql:query("SELECT dvalue FROM vrp_user_data WHERE user_id = @user_id AND dkey = @key", {user_id = user_id, key = key}, function(rows)
        if #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

function vRP.setSData(key, value)
    exports.oxmysql:query("REPLACE INTO vrp_srv_data(dkey,dvalue) VALUES(@key,@value)", {key = key, value = value}, function() end)
end

function vRP.getSData(key, cbr)
    local task = Task(cbr, {""})
    
    exports.oxmysql:query("SELECT dvalue FROM vrp_srv_data WHERE dkey = @key", {key = key}, function(rows)
        if #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

-- return user data table for vRP internal persistant connected user storage
function vRP.getUserDataTable(user_id)
    return vRP.user_tables[user_id]
end

function vRP.getUserTmpTable(user_id)
    return vRP.user_tmp_tables[user_id]
end

function vRP.isConnected(user_id)
    return vRP.rusers[user_id]  
end

function vRP.isFirstSpawn(user_id)
    local tmp = vRP.getUserTmpTable(user_id)
    return tmp and tmp.spawns == 1
end

function vRP.getUserId(source)
    if source   then
        local ids = GetPlayerIdentifiers(source)
        if ids   and #ids > 0 then
            return vRP.users[ids[1]]
        end
    end
    
    return nil
end

-- return map of user_id -> player source
function vRP.getUsers()
    local users = {}
    for k, v in pairs(vRP.user_sources) do
        users[k] = v
    end
    
    return users
end

-- return source or nil
function vRP.getUserSource(user_id)
    return vRP.user_sources[user_id]
end

function vRP.ban(source, reason, admin)
    local user_id = vRP.getUserId(source)
    if user_id   then
        if (tostring(admin) ~= "Consola") then
            theAdmin = vRP.getUserId(admin)
            adminName = vRP.getPlayerName(admin)
            banBy = adminName .. " [" .. theAdmin .. "]"
        else
            banBy = "Consola"
        end
        vRP.setBanned(user_id, true, reason, admin)
        motiv = "[Dunko] Ai primit BAN PERMANENT!\nBanat De: " .. banBy .. "\nMotiv: " .. reason .. "\nID-ul Tau: [" .. user_id .. "]\nACEST BAN NU EXPIRA NICIODATA\n\n⚠ Daca crezi ca ai fost banat pe nedrept, poti face cerere de unban pe discord: https://discord.gg/serverultau"
        vRP.kick(source, motiv)
    end
end

function vRP.banTemp(source, reason, admin, timp)
    local user_id = vRP.getUserId(source)
    if user_id   then
        data = os.date("%d/%m/%Y : %H:%M:%S")
        expireDate = vRP.getBannedExpiredDate(timp)
        if (tostring(admin) ~= "Consola") then
            theAdmin = vRP.getUserId(admin)
            adminName = vRP.getPlayerName(admin)
            banBy = adminName .. " [" .. theAdmin .. "]"
        else
            banBy = "Consola"
        end
        vRP.setBannedTemp(user_id, true, reason, admin, timp)
        motiv = "[Dunko] Ai primit BAN TEMPORAR!\nBanat De: " .. banBy .. "\nMotiv: " .. reason .. "\nTimp: " .. timp .. " Zile\nID-ul Tau: [" .. user_id .. "]\nBanat Pe Data De: " .. data .. "\nExpira Pe: " .. expireDate .. "\n\n⮚ Unban Automat Dupa Ce Trece Timpul ⮘\n\n⚠ Daca crezi ca ai fost banat pe nedrept, poti face cerere de unban pe discord: https://discord.gg/serverultau"
        vRP.kick(source, motiv)
    end
end

function vRP.kick(source, reason)
    DropPlayer(source, reason)
end

RegisterCommand('staff', function(source)
    local user_id = vRP.getUserId(source)
    local staff = vRP.getOnlineStaff()
    local s = 0
    for k, v in pairs(staff) do
        s = s + 1
        local player = vRP.getUserSource(v)
        local name = GetPlayerName(player)
        name = name or "Necunoscut"
        TriggerClientEvent('chatMessage', source, '^3' .. name .. ' ^0(^3' .. vRP.getUserId(player) .. '^0) -> ^1' .. vRP.getUserAdminTitle(v))
    end
    
    TriggerClientEvent('chatMessage', source, 'Staff ^0Online: ^1' .. s)
end)

RegisterCommand('politie', function(source)
    local cops = vRP.getOnlineUsersByFaction('Politie')
    local c = 0
    for _, user_id in pairs(cops) do
        c = c + 1
        local player = vRP.getUserSource(user_id)
        local name = GetPlayerName(player)
        name = name or "Necunoscut"
        TriggerClientEvent('chatMessage', source, '^3' .. name .. ' ^0(^3' .. vRP.getUserId(player) .. '^0) ^0-> ^1Gabor')
    end
    
    TriggerClientEvent('chatMessage', source, 'Politisti ^0Online: ^1' .. c)
end)

RegisterCommand('medici', function(source)
    local medici = vRP.getOnlineUsersByFaction('Smurd')
    local m = 0
    for _, user_id in pairs(medici) do
        m = m + 1
        local player = vRP.getUserSource(user_id)
        local name = GetPlayerName(player)
        name = name or "Necunoscut"
        TriggerClientEvent('chatMessage', source, '^3' .. name .. ' ^0(^3' .. vRP.getUserId(player) .. '^0) ^0-> ^1Medic')
    end
    
    TriggerClientEvent('chatMessage', source, 'Medici ^0Online: ^1' .. m)
end)

function tvRP.isPlayerCop()
    local user_id = vRP.getUserId(source)
    return vRP.isUserInFaction(user_id, "Politie")
end

ChillDown = {}

function tvRP.openGiftbox()
    local user_id = vRP.getUserId(source)
    if ChillDown[user_id] == nil then
        if vRP.tryPaymentCoins(user_id, 1) then
            ChillDown[user_id] = true
            SetTimeout(1000, function()
                ChillDown[user_id] = nil
            end)
            local chance = math.random(1, 20)
            local money = math.random(1000, 5000)
            if chance >= 1 and chance <= 19 then
                vRP.giveMoney(user_id, money)
                vRPclient.notify(source, {"Succes: Ai deschis un cadou si ai primit suma de " .. money .. " $"})
            end
            if chance == 20 then
                coins = math.random(1, 3)
                vRP.giveGiftpoints(user_id, coins)
                vRPclient.notify(source, {"Succes: Ai deschis un cadou si ai primit " .. coins .. " Diamante"})
            end
        else
            vRPclient.notify(source, {'Eroare: Nu ai destule giftboxuri!'})
        end
    end
end

function tvRP.getUserHours(PlayerId)
    local user_id = vRP.getUserId(PlayerId)
    local ore = vRP.getUserHoursPlayed(user_id)
    return ore
end

function tvRP.isPlayerMedic()
    local user_id = vRP.getUserId(source)
    return vRP.isUserInFaction(user_id, "Smurd")
end

function task_save_datatables()
    TriggerEvent("vRP:save")
    
    Debug.pbegin("vRP save datatables")
    for k, v in pairs(vRP.user_tables) do
        vRP.setUData(k, "vRP:datatable", json.encode(v))
    end
    
    Debug.pend()
    SetTimeout(config.save_interval * 1000, task_save_datatables)
end
task_save_datatables()

function vRP.getUserHoursPlayed(user_id)
    if (hoursPlayed[user_id]  ) then
        return math.floor(hoursPlayed[user_id])
    else
        return 0
    end
end

RegisterServerEvent("getOnlinePly")
AddEventHandler("getOnlinePly", function()
    local connectedPlayers = GetPlayers()
    TriggerClientEvent("getGlobalOnlinePly", -1, #connectedPlayers)
end)

function tvRP.updateHoursPlayed(hours)
    user_id = vRP.getUserId(source)
    exports.oxmysql:query("UPDATE vrp_users SET hoursPlayed = hoursPlayed + @hours WHERE id = @user_id", {hours = hours, user_id = user_id}, function() end)
    hoursPlayed[user_id] = hoursPlayed[user_id] + hours
    vRPsb.updateScoreboardPlayer({user_id, hours})
end

-- handlers
AddEventHandler("playerConnecting", function(name, setMessage, deferrals)
    deferrals.defer()
    
    local source = source
    Debug.pbegin("playerConnecting")
    local ids = GetPlayerIdentifiers(source)
    
    if ids   and #ids > 0 then
        
        deferrals.update("[Dunko] Se verifica identificarea ⭐️\n\nDiscord: discord.gg/serverultau")
        Wait(3000)
        vRP.getUserIdByIdentifiers(ids, function(user_id)
                -- if user_id   and vRP.rusers[user_id] == nil then -- check user validity and if not already connected (old way, disabled until playerDropped is sure to be called)
                if user_id   then -- check user validity
                    deferrals.update("[Dunko] Verificam tabela de ban 💫\n\nDiscord: discord.gg/serverultau")
                    Wait(3000)
                    vRP.isBanned(user_id, function(banned)
                            
                            exports.oxmysql:query("SELECT * FROM vrp_users WHERE id = @user_id", {user_id = user_id}, function(rows)
                                bannedBy = rows[1].bannedBy or ""
                                banReason = rows[1].bannedReason or ""
                                BanDate = rows[1].BanTempData or ""
                                BanExpireDate = rows[1].BanTempExpire or ""
                                BanZile = tonumber(rows[1].BanTempZile)
                                
                                if tonumber(rows[1].bannedTemp) < os.time() then
                                    if not banned then
                                        deferrals.update("[Dunko] Verificam whitelist-ul 📋")
                                        vRP.isWhitelisted(user_id, function(whitelisted)
                                            if not config.whitelist or whitelisted then
                                                Debug.pbegin("playerConnecting_delayed")
                                                if vRP.rusers[user_id] == nil then -- not present on the server, init
                                                    -- init entries
                                                    vRP.users[ids[1]] = user_id
                                                    vRP.rusers[user_id] = ids[1]
                                                    vRP.user_tables[user_id] = {}
                                                    vRP.user_tmp_tables[user_id] = {}
                                                    vRP.user_sources[user_id] = source
                                                    
                                                    -- load user data table
                                                    deferrals.update("[Dunko] Cautam informatii in baza de date 🔎")
                                                    vRP.getUData(user_id, "vRP:datatable", function(sdata)
                                                        local data = json.decode(sdata)
                                                        if type(data) == "table" then vRP.user_tables[user_id] = data end
                                                        
                                                        -- init user tmp table
                                                        local tmpdata = vRP.getUserTmpTable(user_id)
                                                        deferrals.update("[Dunko] Verificam ultima logare 📌")
                                                        vRP.getLastLogin(user_id, function(last_login)
                                                            tmpdata.last_login = last_login or ""
                                                            tmpdata.spawns = 0
                                                            
                                                            -- set last login
                                                            local ep = vRP.getPlayerEndpoint(source)
                                                            local last_login_stamp = ep .. " " .. os.date("%H:%M:%S %d/%m/%Y")
                                                            exports.oxmysql:query("UPDATE vrp_users SET last_login = @last_login WHERE id = @user_id", {user_id = user_id, last_login = last_login_stamp}, function() end)
                                                            -- trigger join
                                                            local discordIdentifier = vRP.getUserIdentifiers(source, "discord")
                                                            local time = os.date("%d/%m/%Y - %X")
                                                            local embed = {
                                                                {
                                                                    ["color"] = "56921",
                                                                    ["type"] = "rich",
                                                                    ["title"] = "" .. name .. " [" .. user_id .. "]",                                                              
                                                                    ["description"] = "Jucatorul s-a conectat",
                                                                    ["footer"] = {
                                                                        ["text"] = ""..time..""
                                                                    }
                                                                }
                                                            }
                                                            PerformHttpRequest('https://discord.com/api/webhooks/933730966738964500/i29ak6ppnxX7SqURVKsMFmhJJlws3L9W5pZOl2PMyBgLvgl3xy6ZWbqiOavn4Sa1gLRg', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
                                                            print("^2Connecting: ^0Jucatorul ^2" .. name .. " (^0" .. user_id .. "^2) ^0a intrat pe Server ^2[^0"..time.."^2]^0")
                                                            TriggerEvent("vRP:playerJoin", user_id, source, name, tmpdata.last_login)
                                                            deferrals.done()
                                                        end)
                                                    end)
                                                else -- already connected
                                                    TriggerEvent("vRP:playerRejoin", user_id, source, name)
                                                    deferrals.done()
                                                    
                                                    -- reset first spawn
                                                    local tmpdata = vRP.getUserTmpTable(user_id)
                                                    tmpdata.spawns = 0
                                                end
                                                Debug.pend()
                                            else
                                                deferrals.done("[Dunko] Whitelist ON [user_id = " .. user_id .. "] 🔒")
                                            end
                                        end)
                                    else
                                        print("^1[^0Banned^1] [^0" .. name .. "^1] ^1[^0" .. vRP.getPlayerEndpoint(source) .. "^1] ^0banat permanent ^1[^0user_id = " .. user_id .. "^1]^0")
                                        deferrals.done("[Dunko] Esti banat permanent pe server!\nBanat De: " .. bannedBy .. "\nMotiv: " .. banReason .. "\nID-ul Tau: [" .. user_id .. "]\nACEST BAN NU EXPIRA NICIODATA\n\n⚠ Daca crezi ca ai fost banat pe nedrept, poti face cerere de unban pe discord: https://discord.gg/serverultau")
                                    end
                                else
                                    print("^1[^0Banned^1] [^0" .. name .. "^1] ^1[^0" .. vRP.getPlayerEndpoint(source) .. "^1] ^0banat temporar ^1[^0user_id = " .. user_id .. "^1]^0")
                                    deferrals.done("[Dunko] Esti banat temporar pe server!\nBanat De: " .. bannedBy .. "\nMotiv: " .. banReason .. "\nTimp: " .. BanZile .. " Zile\nID-ul Tau: [" .. user_id .. "]\nBanat Pe Data De: " .. BanDate .. "\nExpira Pe: " .. BanExpireDate .. "\n\n⮚ Unban Automat Dupa Ce Trece Timpul ⮘\n\n⚠ Daca crezi ca ai fost banat pe nedrept, poti face cerere de unban pe discord: https://discord.gg/serverultau")
                                end
                            end)
                    end)
                else
                    print("^1[^0Error^1] [^0" .. name .. "^1] ^1[^0" .. vRP.getPlayerEndpoint(source) .. "^1] ^0baza de date nu functioneaza")
                    deferrals.done("[Dunko] Din pacate sunt ceva probleme la server, mai incearca odata ;) ✏️")
                end
        end)
    else
        print("^1[^0Banned^1] [^0" .. name .. "^1] ^1[^0" .. vRP.getPlayerEndpoint(source) .. "^1] ^0lipsesc identificatorii")
        deferrals.done("[Dunko] Lipsesc identificatorii 📌")
    end
    Debug.pend()
end)

AddEventHandler("playerDropped", function(reason)
    local source = source
    Debug.pbegin("playerDropped")
    
    -- remove player from connected clients
    vRPclient.removePlayer(-1, {source})
    
    
    local user_id = vRP.getUserId(source)
    local name = vRP.getPlayerName(source)
    
    if user_id   then
        local time = os.date("%d/%m/%Y - %X")
        local embed = {
            {
                ["color"] = "15158332",
                ["type"] = "rich",      
                ["title"] = "" .. name .. " [" .. user_id .. "]",                                                              
                ["description"] = "" .. reason .. "",
                ["footer"] = {
                    ["text"] = ""..time..""
                }
            }
        }
        PerformHttpRequest('https://discord.com/api/webhooks/933730966738964500/i29ak6ppnxX7SqURVKsMFmhJJlws3L9W5pZOl2PMyBgLvgl3xy6ZWbqiOavn4Sa1gLRg', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
        print("^1Disconnect: ^0Jucatorul ^1" .. name .. " (^0" .. user_id .. "^1) ^0a iesit de pe Server ^1[^0"..time.."^1]^0")
        TriggerEvent("vRP:playerLeave", user_id, source, reason)
        
        -- save user data table
        vRP.setUData(user_id, "vRP:datatable", json.encode(vRP.getUserDataTable(user_id)))
        
        vRP.users[vRP.rusers[user_id]] = nil
        vRP.rusers[user_id] = nil
        vRP.user_tables[user_id] = nil
        vRP.user_tmp_tables[user_id] = nil
        vRP.user_sources[user_id] = nil
    end
    Debug.pend()
end)

RegisterServerEvent("vRPcli:playerSpawned")
AddEventHandler("vRPcli:playerSpawned", function()
    Debug.pbegin("playerSpawned")
    -- register user sources and then set first spawn to false
    local user_id = vRP.getUserId(source)
    local player = source
    if user_id   then
        vRP.user_sources[user_id] = source
        local tmp = vRP.getUserTmpTable(user_id)
        tmp.spawns = tmp.spawns + 1
        local first_spawn = (tmp.spawns == 1)
        
        if first_spawn then
            -- first spawn, reference player
            -- send players to new player
            for k, v in pairs(vRP.user_sources) do
                vRPclient.addPlayer(source, {v})
            end
            -- send new player to all players
            vRPclient.addPlayer(-1, {source})
            
            hoursPlayed[user_id] = tonumber(exports.oxmysql:executeSync("SELECT hoursPlayed FROM vrp_users WHERE id = @user_id", {user_id = user_id})[1].hoursPlayed)
        end
        
        -- set client tunnel delay at first spawn
        Tunnel.setDestDelay(player, config.load_delay)
        
        exports.oxmysql:query("UPDATE vrp_users SET username = @username WHERE id = @user_id", {user_id = user_id, username = vRP.getPlayerName(player)}, function() end)
        SetTimeout(2000, function()-- trigger spawn event
            TriggerEvent("vRP:playerSpawn", user_id, player, first_spawn)
            SetTimeout(config.load_duration * 1000, function()-- set client delay to normal delay
                Tunnel.setDestDelay(player, config.global_delay)
                vRPclient.removeProgressBar(player, {"vRP:loading"})
            end)
        end)
    end
    
    Debug.pend()
end)

RegisterServerEvent("vRP:playerDied")
