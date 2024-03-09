local htmlEntities = module("lib/htmlEntities")
local Tools = module("lib/Tools")

local titles = {"Trial Helper", "Helper", "Helper Avansat", "Moderator", "Super Moderator", "Lider Moderator", "Administrator", "Super Administrator", "Lider Administrator", "Head of Staff", "Co Fondator", "Fondator", "Developer"}
local onduty = {0}
function vRP.getUserAdminLevel(user_id)
    local tmp = vRP.getUserTmpTable(user_id)
    if tmp then
        adminLevel = tmp.adminLevel
    end
    return adminLevel or 0
end

function vRP.isAdmin(user_id)
    local tmp = vRP.getUserTmpTable(user_id)
    if tmp then
        adminLevel = tmp.adminLevel
    end
    if (adminLevel > 0) then
        return true
    else
        return false
    end
end

function vRP.isUserTrialHelper(user_id)
    local adminLevel = vRP.getUserAdminLevel(user_id)
    if (adminLevel >= 1) then
        return true
    else
        return false
    end
end

function vRP.isUserHelper(user_id)
    local adminLevel = vRP.getUserAdminLevel(user_id)
    if (adminLevel >= 2) then
        return true
    else
        return false
    end
end

function vRP.isUserHelperAvansat(user_id)
    local adminLevel = vRP.getUserAdminLevel(user_id)
    if (adminLevel >= 3) then
        return true
    else
        return false
    end
end

function vRP.isUserModerator(user_id)
    local adminLevel = vRP.getUserAdminLevel(user_id)
    if (adminLevel >= 4) then
        return true
    else
        return false
    end
end

function vRP.isUserSuperModerator(user_id)
    local adminLevel = vRP.getUserAdminLevel(user_id)
    if (adminLevel >= 5) then
        return true
    else
        return false
    end
end

function vRP.isUserLiderModerator(user_id)
    local adminLevel = vRP.getUserAdminLevel(user_id)
    if (adminLevel >= 6) then
        return true
    else
        return false
    end
end

function vRP.isUserAdministrator(user_id)
    local adminLevel = vRP.getUserAdminLevel(user_id)
    if (adminLevel >= 7) then
        return true
    else
        return false
    end
end

function vRP.isUserSuperAdministrator(user_id)
    local adminLevel = vRP.getUserAdminLevel(user_id)
    if (adminLevel >= 8) then
        return true
    else
        return false
    end
end

function vRP.isUserLiderAdministrator(user_id)
    local adminLevel = vRP.getUserAdminLevel(user_id)
    if (adminLevel >= 9) then
        return true
    else
        return false
    end
end

function vRP.isUserHeadofStaff(user_id)
    local adminLevel = vRP.getUserAdminLevel(user_id)
    if (adminLevel >= 10) then
        return true
    else
        return false
    end
end

function vRP.isUserCoFondator(user_id)
    local adminLevel = vRP.getUserAdminLevel(user_id)
    if (adminLevel >= 11) then
        return true
    else
        return false
    end
end

function vRP.isUserFondator(user_id)
    local adminLevel = vRP.getUserAdminLevel(user_id)
    if (adminLevel >= 12) then
        return true
    else
        return false
    end
end

function vRP.isUserDeveloper(user_id)
    local adminLevel = vRP.getUserAdminLevel(user_id)
    if (adminLevel >= 13) then
        return true
    else
        return false
    end
end

function vRP.getUserAdminTitle(user_id)
    local text = titles[vRP.getUserAdminLevel(user_id)] or "Admin"
    return text
end

function vRP.setUserAdminLevel(user_id, admin)
    local tmp = vRP.getUserTmpTable(user_id)
    if tmp then
        tmp.adminLevel = admin
    end
    exports.oxmysql:query("UPDATE vrp_users SET adminLvl = @adminLevel WHERE id = @user_id", {user_id = user_id, adminLevel = admin})
end

function vRP.getOnlineAdmins()
    local oUsers = {}
    for k, v in pairs(vRP.rusers) do
        if vRP.isUserAdmin(tonumber(k)) then table.insert(oUsers, tonumber(k)) end
    end
    return oUsers
end

function vRP.getOnlineStaff()
    local onStaff = {}
    local users = vRP.getUsers()
    for k, v in pairs(users) do
        if vRP.isUserTrialHelper(tonumber(k)) then
            table.insert(onStaff, tonumber(k))
        end
    end
    return onStaff
end

function vRP.sendStaffMessage(msg)
    for k, v in pairs(vRP.rusers) do
        local ply = vRP.getUserSource(tonumber(k))
        if vRP.isUserTrialHelper(k) and ply then
            TriggerClientEvent("chatMessage", ply, msg)
        end
    end
end

local function ch_addgroup(player, choice)
    local user_id = vRP.getUserId(player)
    local numestaff = vRP.getPlayerName(player)
    
    if user_id   then
        vRP.prompt(player, "User id: ", "", function(player, id)
            id = parseInt(id)
            vRP.prompt(player, "Group to add: ", "", function(player, group)
                vRP.addUserGroup(id, group)
                Wait(150)
                vRP.sendStaffMessage("^1Staff: ^0Admin-ul ^1" .. vRP.getPlayerName(player) .. " ^0i-a dat add group lui ID ^1" .. id .. "")
                vRP.sendStaffMessage("^1Group: ^0" .. group)
                vRPclient.notify(player, {"Succes: Grupa " .. group .. " a fost adaugata lui " .. id})
                local embed = {
                    {
                        ["color"] = 0xcf0000,
                        ["title"] = "" .. "ADD-GROUPS" .. "",
                        ["description"] = "**Groups:** " .. GetPlayerName(player) .. " i-a dat add groups lui id " .. id .. " \n **Groups:** " .. group .. "",
                        ["thumbnail"] = {
                            ["url"] = "https://i.imgur.com/L6Tm8Rx.png",
                        },
                    }
                }
                PerformHttpRequest('https://discord.com/api/webhooks/923552930483826788/r-Mad2tnq27A3uRiuAK9qukQ_WOyLLBBNkeUzpnvYthcOwD_NlNFLwpaMmha67XL5PpQ', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
            end)
        end)
    end
end

local function ch_removegroup(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id   then
        vRP.prompt(player, "ID: ", "", function(player, id)
            id = parseInt(id)
            nplayer = vRP.getUserSource(tonumber(id))
            if (tonumber(id)) and (id > 0) and (id ~= "") and (id  ) then
                if nplayer   then
                    vRP.prompt(player, "Grad de scos: ", "", function(player, group)
                        if group   then
                            vRP.removeUserGroup(id, group)
                            vRPclient.notify(player, {"Succes: Grad-ul " .. group .. " a fost scos pentru id-ul " .. id})
                            vRP.sendStaffMessage("^1Staff: ^0Admin-ul ^1" .. vRP.getPlayerName(player) .. " ^0i-a dat remove group lui ID ^1" .. id .. "")
                            vRP.sendStaffMessage("^1Group: ^0" .. group)
                        end
                    end)
                else
                    vRPclient.notify(player, {"Eroare: Jucatorul nu este online!"})
                end
            else
                vRPclient.notify(player, {"Eroare: ID-ul pare invalid!"})
            end
        end)
    end
end

local function ch_kick(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id   then
        vRP.prompt(player, "ID: ", "", function(player, id)
            id = parseInt(id)
            local source = vRP.getUserSource(id)
            if (tonumber(id) and (id ~= "") and (id > 0)) then
                if (id == 1 or id == 2 or id == 3) then
                    vRPclient.notify(player, {"Eroare: Nu ai cum sa imi dai kick fraiere!"})
                    if (source  ) then
                        TriggerClientEvent('chatMessage', -1, "^3Shop: ^0Pripasul asta ^1" .. vRP.getPlayerName(player) .. "^0 a incercat sa ii dea kick lui id 1,2,3")
                    end
                else
                    vRP.prompt(player, "Motiv: ", "", function(player, reason)
                        if reason ~= "" then
                            local source = vRP.getUserSource(id)
                            if source   then
                                TriggerClientEvent("chatMessage", -1, "^3Shop: ^1" .. vRP.getPlayerName(source) .. " ^0a primit kick de la ^1" .. vRP.getPlayerName(player))
                                TriggerClientEvent("chatMessage", -1, "^3Motiv: ^0" .. reason)
                                local embed = {
                                    {
                                        ["color"] = 0xcf0000,
                                        ["title"] = "" .. "KICK" .. "",
                                        ["description"] = "**Kick:** " .. GetPlayerName(player) .. " i-a dat kick lui " .. id .. " \n **Motiv:** " .. reason .. "",
                                        ["thumbnail"] = {
                                            ["url"] = "https://i.imgur.com/L6Tm8Rx.png",
                                        },
                                    }
                                }
                                PerformHttpRequest('https://discord.com/api/webhooks/923553216136892426/d9kRR7EksnL1GsV91K1AurSnEK5NAsM8--_-ZSfAuWARlDE6MzA-xG4aRS8iG047RWto', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})vRP.kick(source, reason)
                            else
                                vRPclient.notify(player, {"Eroare: Jucatorul nu este online!"})
                            end
                        else
                            vRPclient.notify(player, {"Eroare: Trebuie sa completezi motivul."})
                        end
                    end)
                end
            else
                vRPclient.notify(player, {"Eroare: ID-ul pare invalid!"})
            end
        end)
    end
end

local function ch_ban(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id   then
        vRP.prompt(player, "ID (BAN PERMANENT): ", "", function(player, id)
            id = parseInt(id)
            local source = vRP.getUserSource(id)
            if (tonumber(id) and (id ~= "") and (id > 0)) then
                if (id == 1 or id == 2 or id == 3) then
                    if (source  ) then
                        TriggerClientEvent('chatMessage', -1, "^3Shop: ^0Pripasul asta ^1" .. vRP.getPlayerName(player) .. "^0 a incercat sa ii dea ban lui id 1,2,3")
                    end
                else
                    vRP.prompt(player, "Motiv: ", "", function(player, reason)
                        if reason ~= "" then
                            local embed = {
                                {
                                    ["color"] = 0xcf0000,
                                    ["title"] = "" .. "BAN-PERMANENT" .. "",
                                    ["description"] = "**Ban:** " .. GetPlayerName(player) .. " i-a dat ban online lui " .. id .. " \n **Motiv:** " .. reason .. "",
                                    ["thumbnail"] = {
                                        ["url"] = "https://i.imgur.com/L6Tm8Rx.png",
                                    },
                                }
                            }
                            PerformHttpRequest('https://discord.com/api/webhooks/923553457326141451/Y9kxP5lzjD27_hVhQ98nEDCREDkcz7yQgkvO-0qFuFMa5r7pjT43yt4KK-0Jm1b-ZxRX', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
                            local source = vRP.getUserSource(id)
                            if source   then
                                theFaction = vRP.getUserFaction(id)
                                if (theFaction ~= "user") then
                                    vRP.removeUserFaction(id, theFaction)
                                    vRP.removeUserGroup(id, "onduty")
                                end
                                TriggerClientEvent("chatMessage", -1, "^3Shop: ^1" .. vRP.getPlayerName(source) .. " (" .. id .. ") ^0a fost banat permanent de ^1" .. vRP.getPlayerName(player) .. " (" .. user_id .. ")")
                                TriggerClientEvent("chatMessage", -1, "^3Motiv: ^0" .. reason)
                                vRP.ban(source, reason, player)
                            else
                                local rows = exports.oxmysql:executeSync("SELECT username FROM vrp_users WHERE id = @user_id", {user_id = id})
                                TriggerClientEvent("chatMessage", -1, "^3Shop: ^1" .. tostring(rows[1].username) .. " (" .. id .. ") ^0a fost banat permanent de ^1" .. vRP.getPlayerName(player) .. " (" .. user_id .. ")")
                                TriggerClientEvent("chatMessage", -1, "^3Motiv: ^0" .. reason)
                                vRP.setBanned(id, true, reason, player)
                            end
                        else
                            vRPclient.notify(player, {"Eroare: Trebuie sa completezi motivul."})
                        end
                    end)
                end
            else
                vRPclient.notify(player, {"Eroare: ID-ul pare invalid!"})
            end
        end)
    end
end

local function ch_banTemp(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id   then
        vRP.prompt(player, "Jucator ID de BANAT TEMPORAR: ", "", function(player, id)
            id = parseInt(id)
            local source = vRP.getUserSource(id)
            if (tonumber(id) and (id ~= "") and (id > 0)) then
                if (id == 1 or id == 2 or id == 3) then
                    vRPclient.notify(player, {"Eroare: Nu ai cum sa banezi id-urile astea"})
                    if (source  ) then
                        vRPclient.notify(source, {"Eroare: " .. vRP.getPlayerName(player) .. " ~w~a incercat sa te baneze!"})
                    end
                else
                    vRP.prompt(player, "Motiv: ", "", function(player, reason)
                        if reason ~= "" then
                            vRP.prompt(player, "Timp (zile): ", "", function(player, timp)
                                timp = parseInt(timp)
                                if tonumber(timp) and (timp ~= "") then
                                    if (timp >= 2) and (timp <= 90) then
                                        local expireDate = vRP.getBannedExpiredDate(timp)
                                        local source = vRP.getUserSource(id)
                                        if source   then
                                            if (timp == 90) then
                                                theFaction = vRP.getUserFaction(id)
                                                if (theFaction ~= "user") then
                                                    vRP.removeUserFaction(id, theFaction)
                                                end
                                            end
                                            TriggerClientEvent("chatMessage", -1, "^3Shop: ^1" .. vRP.getPlayerName(source) .. " (" .. id .. ") ^0a fost banat temporar de ^1" .. vRP.getPlayerName(player) .. " (" .. user_id .. ") ^0pentru ^3" .. timp .. " zile")
                                            TriggerClientEvent("chatMessage", -1, "^3Motiv: ^0" .. reason)
                                            vRP.banTemp(source, reason, player, timp)
                                        else
                                            exports.oxmysql:query("SELECT username FROM vrp_users WHERE id = @user_id", {user_id = id}, function(rows)
                                                TriggerClientEvent("chatMessage", -1, "^3Shop: ^1" .. tostring(rows[1].username) .. " (" .. id .. ") ^0a fost banat temporar de ^1" .. vRP.getPlayerName(player) .. " (" .. user_id .. ") ^0pentru ^3" .. timp .. " zile")
                                                TriggerClientEvent("chatMessage", -1, "^3Motiv: ^0" .. reason)
                                                vRP.setBannedTemp(id, true, reason, player, timp)
                                                local embed = {
                                                    {
                                                        ["color"] = 0xcf0000,
                                                        ["title"] = "" .. "BAN-TEMPORAR" .. "",
                                                        ["description"] = "**Ban:** " .. vRP.getPlayerName(player) .. " i-a dat ban temporar lui " .. id .. "\n**Timp:** " .. timp .. "\n**Motiv:** " .. reason .. "",
                                                        ["thumbnail"] = {
                                                            ["url"] = "https://i.imgur.com/L6Tm8Rx.png",
                                                        },
                                                    }
                                                }
                                                PerformHttpRequest('https://discord.com/api/webhooks/923553582056357898/8bLDAN4_J3hinaEqVGmFq_ve6hURgNOI8YyYVhFiqgl0OpP7kH7HlWdV6joMiqyfRiON', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
                                            end)
                                        end
                                    else
                                        vRPclient.notify(player, {"Eroare: ~w~Maxim 90 de zile (3 luni)"})
                                    end
                                else
                                    vRPclient.notify(player, {"Eroare: ~w~Timp-ul nu poate fi gol"})
                                end
                            end)
                        else
                            vRPclient.notify(player, {"Eroare: ~w~Motiv-ul nu poate fi gol"})
                        end
                    end)
                end
            else
                vRPclient.notify(player, {"Eroare: ~w~Acest ID este INVALID!"})
            end
        end)
    end
end

local function ch_checkplayer(player, choice)
    check_menu = {name = "Check Player", css = {top = "75px", header_color = "rgba(0,125,255,0.75)"}}
    vRP.prompt(player, "User ID:", "", function(player, user_id)
        user_id = tonumber(user_id)
        usrID = vRP.getUserId(player)
        if (user_id == 1) and (user_id ~= 2) and (user_id ~= 3) then
            vRPclient.notify(player, {"Eroare: Nu ai cum sa dai check pe id 1,2 si 3"})
            return
        else
            theTarget = vRP.getUserSource(user_id)
            if (theTarget) then
                user_id = vRP.getUserId(theTarget)
                wallet = vRP.getMoney(user_id)
                ore = vRP.getUserHoursPlayed(user_id)
                bank = vRP.getBankMoney(user_id)
                steamID = GetPlayerIdentifier(theTarget) or "Invalid"
                rsLicense = GetPlayerIdentifier(theTarget, 1) or "Invalid"
                theIP = GetPlayerEndpoint(theTarget) or "Invalid"
                vRP.sendStaffMessage("^1Staff: ^0Admin-ul ^1" .. vRP.getPlayerName(player) .. " ^0a folosit check player")
                
                check_menu["[1] Bani"] = {function() end, "Buzunar: <font color='red'>$" .. vRP.formatMoney(wallet) .. "</font><br>Banca: <font color='red'>$" .. vRP.formatMoney(bank)}
                check_menu["[2] Ore"] = {function() end, "Ore: <font color='red'>" .. ore .. "</font>"}
                check_menu["[3] Nume"] = {function() end, "Nume: <font color='red'>" .. GetPlayerName(theTarget) .. "</font>"}
                check_menu["[4] Vehicule"] = {function(player, choice)playerVehs(player, user_id) end, "Vezi masinile jucatorilui"}
                vRP.closeMenu(player)
                SetTimeout(200, function()
                    vRP.openMenu(player, check_menu)
                end)
            end
        end
    end)
end

local function ch_food(player, choice)
    local user_id = vRP.getUserId(player)
    vRP.setThirst(user_id, -100)
    vRP.setHunger(user_id, -100)
end

local function ch_unban(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id   then
        vRP.prompt(player, "ID (UNBAN): ", "", function(player, id)
            id = parseInt(id)
            if (tonumber(id) and (id ~= "") and (id > 0)) then
                exports.oxmysql:query("SELECT * FROM vrp_users WHERE id = @user_id", {user_id = id}, function(rows)
                    warnuri = tonumber(rows[1].warns)
                    if (warnuri == 3) then
                        exports.oxmysql:query("UPDATE vrp_users SET warnr1 = @warnr1, warnr2 = @warnr2, warnr3 = @warnr3, warnid1 = @warnid1, warnid2 = @warnid2, warnid3 = @warnid3, warns = 0, finalSansa = 0 WHERE id = @user_id", {user_id = id, warnr1 = "none", warnr2 = "none", warnr3 = "none", warnid1 = "none", warnid2 = "none", warnid3 = "none"}, function() end)
                    end
                    TriggerClientEvent('chatMessage', -1, "^3Shop: ^1" .. tostring(rows[1].username) .. " (" .. id .. ") ^0a primit unban de la ^1" .. vRP.getPlayerName(player) .. " (" .. user_id .. ")")
                    local embed = {
                        {
                            ["color"] = 0xcf0000,
                            ["title"] = "" .. "UNBAN" .. "",
                            ["description"] = "**Unban:** " .. GetPlayerName(player) .. " i-a dat unban lui " .. id .. "",
                            ["thumbnail"] = {
                                ["url"] = "https://i.imgur.com/L6Tm8Rx.png",
                            },
                        }
                    }
                    PerformHttpRequest('https://discord.com/api/webhooks/923553705238867999/4FkM5a4N9dCxuRTYLaT7Plo353wiCPUqqLXszaL6_KycVbwosgvYBcMxyH6K4XFrhTF8', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
                    vRP.setBannedTemp(id, false, "", "", 0)
                end)
            else
                vRPclient.notify(player, {"Eroare: ID-ul pare invalid."})
            end
        end)
    end
end

local function ch_tptoplace(player, choice)
    local user_id = vRP.getUserId(source)
    vRP.prompt(player, "ID: ", "", function(player, id)
        local id = parseInt(id)
        vRP.prompt(player, "Unde vrei sa te teleportezi", "[1] showroom, [2] spawn, [3] politie, [4] spital", function(player, raspuns)
            tp = parseInt(raspuns)
            if id   then
                local thePlayer = vRP.getUserSource(id)
                if thePlayer   then
                    if tp == 1 then
                        vRPclient.notify(player, {"Succes: L-ai teleportat pe " .. GetPlayerName(thePlayer) .. " la Showroom"})
                        vRPclient.notify(thePlayer, {"Succes: Ai fost teleporat la Showroom de catre adminul " .. GetPlayerName(player)})
                        vRPclient.teleport(thePlayer, {-38.905174255371, -1110.2645263672, 26.438343048096})
                    elseif tp == 2 then
                        vRPclient.notify(player, {"Succes: L-ai teleportat pe " .. GetPlayerName(thePlayer) .. " la Spawn"})
                        vRPclient.notify(thePlayer, {"Succes: Ai fost teleporat la Spawn de catre adminul " .. GetPlayerName(player)})
                        vRPclient.teleport(thePlayer, {-310.6628112793, 223.70266723633, 87.924606323242})
                    elseif tp == 3 then
                        vRPclient.notify(player, {"Succes: L-ai teleportat pe " .. GetPlayerName(thePlayer) .. " la Politie"})
                        vRPclient.notify(thePlayer, {"Succes: Ai fost teleporat la Politie de catre adminul " .. GetPlayerName(player)})
                        vRPclient.teleport(thePlayer, {426.77401733398, -981.39434814453, 30.710090637207})
                    elseif tp == 4 then
                        vRPclient.notify(player, {"Succes: L-ai teleportat pe " .. GetPlayerName(thePlayer) .. " la Spital"})
                        vRPclient.notify(thePlayer, {"Succes: Ai fost teleporat la Spital de catre adminul " .. GetPlayerName(player)})
                        vRPclient.teleport(thePlayer, {294.42080688477, -591.26116943359, 43.084869384766})
                    end
                else
                    vRPclient.notify(player, {"Eroare: ~w~Jucatorul nu este online!"})
                end
            else
                vRPclient.notify(player, {"Eroare: ~w~Jucatorul nu este online!"})
            end
        end)
    end)
end

local function ch_tptome(player, choice)
    vRPclient.getPosition(player, {}, function(x, y, z)
        vRP.prompt(player, "ID:", "", function(player, user_id)
            local tplayer = vRP.getUserSource(tonumber(user_id))
            local target = vRP.getUserSource(user_id)
            local numestaff = vRP.getPlayerName(player)
            if tplayer   then
                vRPclient.teleport(tplayer, {x, y, z})
                vRP.sendStaffMessage("^1Staff: ^0Admin-ul ^1" .. numestaff .. " ^0a dat tptome lui ^1" .. tplayer)
                local embed = {
                    {
                        ["color"] = 0xcf0000,
                        ["title"] = "" .. "TpToMe" .. "",
                        ["description"] = "**TptoMe:** " .. GetPlayerName(player) .. " i-a dat tp la el lui id " .. user_id .. "",
                        ["thumbnail"] = {
                        },
                    }
                }
                PerformHttpRequest('https://discord.com/api/webhooks/923553868862877706/qrXgOsLvnEJEb6mdeTZPYwmmmj7luoAZ2VB-DuJaaKo2NnBY8QjOlOj3zcA1DJj-o0yH', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
            end
        end)
    end)
end

local function ch_tpto(player, choice)
    vRP.prompt(player, "ID:", "", function(player, user_id)
        local tplayer = vRP.getUserSource(tonumber(user_id))
        local numestaff = vRP.getPlayerName(player)
        if tplayer   then
            vRPclient.getPosition(tplayer, {}, function(x, y, z)
                vRPclient.teleport(player, {x, y, z})
                vRPclient.teleport(player, {x, y, z})
                vRP.sendStaffMessage("^1Staff: ^0Admin-ul ^1" .. numestaff .. " ^0a dat tpto la ID ^1" .. tplayer)
                local embed = {
                    {
                        ["color"] = 0xcf0000,
                        ["title"] = "" .. "TpTo" .. "",
                        ["description"] = "**Tpto:** " .. GetPlayerName(player) .. " si-a dat tp la id " .. user_id .. "",
                        ["thumbnail"] = {
                        },
                    }
                }
                PerformHttpRequest('https://discord.com/api/webhooks/923553992141865020/5xDB1M_skokXW9VBedzY_v9kSdTc0r1X2-KvV78IFtWH8bMxegTMqtrd5XEokXp20sbc', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
            end)
        end
    end)
end

local function ch_tptocoords(player, choice)
    vRP.prompt(player, "Coordonate X,Y,Z:", "", function(player, fcoords)
        local coords = {}
        for coord in string.gmatch(fcoords or "0,0,0", "[^,]+") do
            table.insert(coords, tonumber(coord))
        end
        
        local x, y, z = 0, 0, 0
        if coords[1]   then x = coords[1] end
        if coords[2]   then y = coords[2] end
        if coords[3]   then z = coords[3] end
        
        vRPclient.teleport(player, {x, y, z})
        local embed = {
            {
                ["color"] = 0xcf0000,
                ["title"] = "" .. "TpToCoords" .. "",
                ["description"] = "**TpToCoords:** " .. GetPlayerName(player) .. " a folosit TpToCoords",
                ["thumbnail"] = {
                },
            }
        }
        PerformHttpRequest('https://discord.com/api/webhooks/923554078540333056/ekQRdWqMwIyj52guISi9-PmVUEyOiLlaZQuylRD8wPmHhEKuvB71Pxak5o4QeLKBI4DT', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
    end)
end

local function ch_givemoney(player, choice)
    local ID = vRP.getUserId(player)
    vRP.prompt(player, "ID:", "", function(player, user_id)
        user_id = tonumber(user_id)
        local target = vRP.getUserSource(user_id)
        if target   then
            vRP.prompt(player, "Suma:", "", function(player, amount)
                amount = parseInt(amount)
                if (tonumber(amount)  ) and (tonumber(amount) ~= "") then
                    if (tonumber(amount) > 0) and (tonumber(amount) <= 100000000) then
                        vRP.giveMoney(user_id, amount)
                        vRP.sendStaffMessage("^1Staff: ^0Admin-ul ^1" .. vRP.getPlayerName(player) .. " ^0i-a dat givemoney lui ^1" .. vRP.getPlayerName(target) .. " (" .. target .. ")")
                        vRP.sendStaffMessage("^1Money: ^0" .. amount)
                        vRPclient.notify(player, {"Succes: I-ai dat lui " .. vRP.getPlayerName(target) .. " suma de " .. vRP.formatMoney(amount) .. " (de) €."})
                        vRPclient.notify(target, {"Info: " .. vRP.getPlayerName(player) .. " ti-a dat " .. vRP.formatMoney(amount) .. " (de) €."})
                        local embed = {
                            {
                                ["color"] = 0xcf0000,
                                ["title"] = "" .. "GIVE-MONEY" .. "",
                                ["description"] = "**Money:** " .. GetPlayerName(player) .. " i-a dat bani lui id " .. user_id .. " \n **Bani:** " .. vRP.formatMoney(amount) .. "",
                                ["thumbnail"] = {
                                    ["url"] = "https://cdn.discordapp.com/attachments/840212063258542090/840230432313442314/Bi2iC6K.png",
                                },
                            }
                        }
                        PerformHttpRequest('https://discord.com/api/webhooks/923554282102460477/PHMW_zA2jo5ganYhTz4X9gS2SENZTiQEqrNQyo6Nw6DjWLLxTg42x1UhPhtpeldRBfvQ', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
                    else
                        vRPclient.notify(player, {"Eroare: ~w~Maxim 100.000.000 coco"})
                    end
                else
                    vRPclient.notify(player, {"Eroare: ~w~Suma introdusa trebuie sa fie formata doar din numere"})
                end
            end)
        else
            vRPclient.notify(player, {"Eroare: ~w~Jucatorul nu este online."})
        end
    end)
end

local function ch_takemoney(player, choice)
    local ID = vRP.getUserId(player)
    vRP.prompt(player, "ID:", "", function(player, user_id)
        user_id = tonumber(user_id)
        local target = vRP.getUserSource(user_id)
        if target   then
            vRP.prompt(player, "Suma: ", "", function(player, amount)
                amount = parseInt(amount)
                local tBani = tonumber(vRP.getMoney(user_id))
                if (tonumber(amount)) then
                    amount = tonumber(amount)
                    if (tBani >= amount) then
                        vRP.takeMoney(user_id, amount)
                        vRPclient.notify(player, {"Succes: ~w~I-ai luat lui ~r~" .. vRP.getPlayerName(target) .. " ~w~suma de ~r~" .. vRP.formatMoney(amount) .. " ~w~(de) €."})
                        vRPclient.notify(target, {"Info: ~r~" .. vRP.getPlayerName(player) .. "~w~ ti-a luat ~r~" .. vRP.formatMoney(amount) .. " ~w~(de) €."})
                        vRP.sendStaffMessage("^1Staff: ^0Admin-ul ^1" .. vRP.getPlayerName(player) .. " ^0i-a dat take-money lui ^1" .. vRP.getPlayerName(target) .. " (" .. target .. ")")
                        vRP.sendStaffMessage("^1Take-Money: ^0" .. amount)
                    else
                        vRPclient.notify(player, {"Eroare: ~w~Jucatorul are doar ~b~" .. vRP.formatMoney(tBani) .. " ~w~€."})
                    end
                else
                    vRPclient.notify(player, {"Eroare: ~w~Suma introdusa trebuie sa fie formata doar din numere."})
                end
            end)
        else
            vRPclient.notify(player, {"Eroare: ~w~Jucatorul nu este online."})
        end
    end)
end

local function ch_takegiftpoints(player, choice)
    local ID = vRP.getUserId(player)
    vRP.prompt(player, "ID:", "", function(player, user_id)
        user_id = tonumber(user_id)
        local target = vRP.getUserSource(user_id)
        if target   then
            vRP.prompt(player, "Suma: ", "", function(player, amount)
                amount = parseInt(amount)
                local tBani = tonumber(vRP.getGiftpoints(user_id))
                if (tonumber(amount)) then
                    amount = tonumber(amount)
                    if (tBani >= amount) then
                        vRP.takeCoins(user_id, amount)
                        vRPclient.notify(player, {"Succes ~w~I-ai luat lui ~r~" .. vRP.getPlayerName(target) .. " ~w~suma de ~r~" .. vRP.formatMoney(amount) .. " ~w~(de) Giftpoints."})
                        vRPclient.notify(target, {"Succes: ~w~" .. vRP.getPlayerName(player) .. " ti-a luat ~r~" .. vRP.formatMoney(amount) .. " ~w~(de) Giftpoints."})
                        vRP.sendStaffMessage("^1Staff: ^0Admin-ul ^1" .. vRP.getPlayerName(player) .. " ^0i-a luat Shop-coins lui ^1" .. vRP.getPlayerName(target) .. " (" .. target .. ")")
                        vRP.sendStaffMessage("^1Coins: ^0" .. amount)
                    else
                        vRPclient.notify(player, {"Eroare: ~w~Jucatorul are doar ~b~" .. vRP.formatMoney(tBani) .. " ~w~€."})
                    end
                else
                    vRPclient.notify(player, {"Eroare: ~w~Suma introdusa trebuie sa fie formata doar din numere."})
                end
            end)
        else
            vRPclient.notify(player, {"Eroare: ~w~Jucatorul nu este online."})
        end
    end)
end

local function ch_giveGiftpoints(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id   then
        vRP.prompt(player, "ID:", "", function(player, nplayer)
            if nplayer ~= "" or nplayer   then
                target = vRP.getUserSource(tonumber(nplayer))
                if target then
                    vRP.prompt(player, "Suma:", "", function(player, amount)
                        amount = parseInt(amount)
                        vRP.giveGiftpoints(tonumber(nplayer), amount)
                        vRPclient.notify(player, {"Succes: I-ai dat lui " .. vRP.getPlayerName(target) .. ", " .. vRP.formatMoney(amount) .. " (de) giftpoints"})
                        vRP.sendStaffMessage("^1Staff: ^0Admin-ul ^1" .. vRP.getPlayerName(player) .. " ^0i-a dat Shop-coins lui ^1" .. vRP.getPlayerName(target) .. " (" .. target .. ")")
                        vRP.sendStaffMessage("^1Coins: ^0" .. amount)
                        local embed = {
                            {
                                ["color"] = 0xcf0000,
                                ["title"] = "" .. "GIVE-GIFTPOINTS-COINS" .. "",
                                ["description"] = "**Giftpoints:** " .. GetPlayerName(player) .. " i-a dat Shop Coins lui id " .. nplayer .. " \n **Numar:** " .. vRP.formatMoney(amount) .. "",
                                ["thumbnail"] = {
                                    ["url"] = "https://cdn.discordapp.com/attachments/840212063258542090/840230432313442314/Bi2iC6K.png",
                                }
                            }
                        }
                        PerformHttpRequest('https://discord.com/api/webhooks/923554436096335882/pSgrMS92aSqWCGL9_SFmBEy7AJoGLxfH3Vl-hd-KpKpi40dCbQw75PXjgRxNh0PwRtMs', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
                    end)
                else
                    vRPclient.notify(player, {"Eroare: ~w~Jucatorul nu a fost gasit."})
                end
            end
        end)
    end
end

local function ch_giveitem(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id   then
        vRP.prompt(player, "ID:", "", function(player, userID)
            userID = tonumber(userID)
            theTarget = vRP.getUserSource(userID)
            if (theTarget) then
                vRP.prompt(player, "Nume item:", "", function(player, idname)
                    idname = idname or ""
                    vRP.prompt(player, "Cantitate:", "", function(player, amount)
                        amount = parseInt(amount)
                        local embed = {
                            {
                                ["color"] = 0xcf0000,
                                ["title"] = "" .. "GIVE-ITEM" .. "",
                                ["description"] = "**Item:** " .. GetPlayerName(player) .. " i-a dat item lui id " .. userID .. " \n **Nume item:** " .. idname .. " \n **Numar:** " .. amount .. "",
                                ["thumbnail"] = {
                                    ["url"] = "https://cdn.discordapp.com/attachments/840212063258542090/840230432313442314/Bi2iC6K.png",
                                },
                            }
                        }
                        PerformHttpRequest('https://discord.com/api/webhooks/923554605458137088/a-48UDDRJbNrGLq9t7AC2RkVc4IVMhWSI1kNNIM5C60Jue9EXQNuNdjEQ0Csq8ToVZGT', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
                        vRP.giveInventoryItem(userID, idname, amount, true)
                    end)
                end)
            end
        end)
    end
end

local function ch_takeitem(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id   then
        vRP.prompt(player, "ID:", "", function(player, userID)
            userID = tonumber(userID)
            theTarget = vRP.getUserSource(userID)
            if (TheTarget) then
                vRP.prompt(player, "Nume item:", "", function(player, idname)
                    idname = idname or ""
                    vRP.prompt(player, "Cantitate:", "", function(player, amount)
                        amount = parseInt(amount)
                        vRP.tryGetInventoryItem(userID, idname, amount, true)
                    end)
                end)
            end
        end)
    end
end

local function ch_takedonationCoins(player, choice)
    local ID = vRP.getUserId(player)
    vRP.prompt(player, "ID:", "", function(player, user_id)
        user_id = tonumber(user_id)
        local target = vRP.getUserSource(user_id)
        if target   then
            vRP.prompt(player, "Suma: ", "", function(player, amount)
                amount = parseInt(amount)
                local tBani = tonumber(vRP.getdonationCoins(user_id))
                if (tonumber(amount)) then
                    amount = tonumber(amount)
                    if (tBani >= amount) then
                        vRP.takeDonationCoins(user_id, amount)
                        vRPclient.notify(player, {"Succes ~w~I-ai luat lui ~r~" .. vRP.getPlayerName(target) .. " ~w~suma de ~r~" .. vRP.formatMoney(amount) .. " ~w~(de) Diamante."})
                        vRPclient.notify(target, {"Succes: ~w~" .. vRP.getPlayerName(player) .. " ti-a luat ~r~" .. vRP.formatMoney(amount) .. " ~w~(de) Diamante."})
                    else
                        vRPclient.notify(player, {"Eroare: ~w~Jucatorul are doar ~b~" .. vRP.formatMoney(tBani) .. " ~w~€."})
                    end
                else
                    vRPclient.notify(player, {"Eroare: ~w~Suma introdusa trebuie sa fie formata doar din numere."})
                end
            end)
        else
            vRPclient.notify(player, {"Eroare: ~w~Jucatorul nu este online."})
        end
    end)
end

local function ch_givedonationCoins(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id   then
        vRP.prompt(player, "ID:", "", function(player, nplayer)
            if nplayer ~= "" or nplayer   then
                target = vRP.getUserSource(tonumber(nplayer))
                if target then
                    vRP.prompt(player, "Suma:", "", function(player, amount)
                        amount = parseInt(amount)
                        vRP.givedonationCoins(tonumber(nplayer), amount)
                        vRPclient.notify(player, {"Succes: ~w~I-ai dat lui ~r~" .. vRP.getPlayerName(target) .. ", " .. vRP.formatMoney(amount) .. " ~w~(de) Diamante"})
                        local embed = {
                            {
                                ["color"] = 0xcf0000,
                                ["title"] = "" .. "GIVE-DIAMANTE-COINS" .. "",
                                ["description"] = "**Diamante:** " .. GetPlayerName(player) .. " i-a dat Donation Diamante lui id " .. nplayer .. " \n **Numar:** " .. vRP.formatMoney(amount) .. "",
                                ["thumbnail"] = {
                                    ["url"] = "https://cdn.discordapp.com/attachments/840212063258542090/840230432313442314/Bi2iC6K.png",
                                },
                            }
                        }
                        PerformHttpRequest('https://discord.com/api/webhooks/923554717957763093/_vY-YQqYJxlHk82HooALFwbkE3UsczfZUQAvH4mnYfwtDr_eMySvbf_6aKHL458J8qR1', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
                    end)
                else
                    vRPclient.notify(player, {"Eroare: ~w~Jucatorul nu a fost gasit."})
                end
            end
        end)
    end
end

local cfg_inventory = module("cfg/inventory")

function playerVehs(player, user_id)
    check_menu2 = {name = "Vehicule", css = {top = "75px", header_color = "rgba(0,125,255,0.75)"}}
    local theVehicles = exports.oxmysql:executeSync("SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id", {user_id = user_id})
    for i, v in pairs(theVehicles) do
        vehName, vehPrice = vRP.checkVehicleName(v.vehicle)
        check_menu2[vehName] = {function(player, choice)
            local chestname = "u" .. user_id .. "veh_" .. string.lower(v.vehicle)
            local max_weight = cfg_inventory.vehicle_chest_weights[string.lower(v.vehicle)] or cfg_inventory.default_vehicle_chest_weight
            
            vRP.adminCheckInventory(player, chestname, max_weight)
        end, "Model: <font color='green'>" .. v.vehicle .. "</font><br>Placuta: " .. v.vehicle_plate .. "<br>"}
    end
    vRP.closeMenu(player)
    SetTimeout(400, function()
        vRP.openMenu(player, check_menu2)
    end)
end

local function ch_noclip(player, choice)
    vRPclient.toggleNoclip(player, {})
    local embed = {
        {
            ["color"] = "15158332",
            ["type"] = "rich",
            ["title"] = "Noclip",
            ["description"] = "**Noclip: ** " .. vRP.getPlayerName(player) .. " a folosit noclip din k",
        }
    }
    
    PerformHttpRequest('https://discord.com/api/webhooks/923554821267673128/K9YWZKBQOAnlDXyDMJdz2kJtGuh4tWY7h3I-g18SjmuDHJlqss_op0BhAqhB0h908bIt', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
end

RegisterCommand('invisiblemod', function(player, args)
    if vRP.isUserFondator(user_id) then
        vRPclient.invisiblemod(player, {})
        vRPclient.notify(player, {"Succes: ~w~Invisible Mod"})
    end
end)

AddEventHandler("vRP:playerJoin", function(user_id, source, name, last_login)
    local rows = exports.oxmysql:executeSync("SELECT adminLvl FROM vrp_users WHERE id = @user_id", {user_id = user_id})
    local adminLevel = tonumber(rows[1].adminLvl)
    local tmp = vRP.getUserTmpTable(user_id)
    if tmp then
        tmp.adminLevel = adminLevel
    end
end)

local function ch_addAdmin(player, choice)
    local user_id = vRP.getUserId(player)
    local numestaff = vRP.getPlayerName(player)
    local adminlvl = vRP.getUserAdminTitle(user_id)
    if user_id   then
        vRP.prompt(player, "ID:", "", function(player, id)
            id = parseInt(id)
            local target = vRP.getUserSource(id)
            if (target) then
                vRP.prompt(player, "Admin Rank:", "", function(player, rank)
                    rank = parseInt(rank)
                    if (tonumber(rank)) then
                        if (rank <= 8) and (0 < rank) then
                            if (target) then
                                vRP.setUserAdminLevel(id, rank)
                                Wait(150)
                                vRPclient.notify(player, {"Succes: ~w~I-ai dat up lui ~r~" .. vRP.getPlayerName(target) .. " ~w~la ~r~" .. vRP.getUserAdminTitle(id) .. "~w~!"})
                                vRPclient.notify(target, {"Succes: ~w~Ai primit up la ~r~" .. vRP.getUserAdminTitle(id) .. " ~w~de catre ~r~" .. vRP.getPlayerName(player)})
                                vRP.sendStaffMessage("^1Staff: ^0Admin-ul ^1" .. numestaff .. " ^0i-a dat admin lui ^1" .. vRP.getPlayerName(target) .. " (" .. target .. ")")
                                vRP.sendStaffMessage("^1Admin: ^0" .. vRP.getUserAdminTitle(id))
                                local embed = {
                                    {
                                        ["color"] = 0xcf0000,
                                        ["title"] = "" .. "ADD-ADMIN" .. "",
                                        ["description"] = "**Admin:** " .. GetPlayerName(player) .. " i-a dat admin lui " .. id .. " \n **Admin Level:** " .. rank .. "",
                                        ["thumbnail"] = {
                                            ["url"] = "https://i.imgur.com/L6Tm8Rx.png",
                                        },
                                    }
                                }
                                PerformHttpRequest('https://discord.com/api/webhooks/923554934987833394/g01kMVgZpuNdUja7zHCIpyZLsS0_yzxLVFCVZXV5lvi0vA5kLvtj4arUjD8uX8aJw8yI', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
                            else
                                exports.oxmysql:query("UPDATE vrp_users SET adminLvl = @adminLevel WHERE id = @user_id", {user_id = id, adminLevel = rank}, function() end)
                                vRPclient.notify(player, {"Succes: ~w~I-ai dat up lui ~r~" .. id .. " ~w~la grad-ul ~r~" .. rank .. "~w~!"})
                            end
                        elseif (rank == 0) then
                            if (target) then
                                vRP.setUserAdminLevel(id, rank)
                                Wait(150)
                                vRPclient.notify(target, {"Eroare: ~w~Staff-ul ti-a fost scos de catre ~r~" .. vRP.getPlayerName(player) .. "~w~!"})
                                vRPclient.notify(player, {"Succes: ~w~I-ai scos staff-ul lui ~r~" .. vRP.getPlayerName(target)})
                            else
                                exports.oxmysql:query("UPDATE vrp_users SET adminLvl = @adminLevel WHERE id = @user_id", {user_id = id, adminLevel = rank}, function() end)
                                vRPclient.notify(player, {"Succes: ~w~I-ai scos functia staff lui ~r~" .. id})
                            end
                        end
                    end
                end)
            else
                vRPclient.notify(player, {"Eroare: ~w~Acest ID nu a fost gasit."})
            end
        end)
    end
end

local function ch_ann(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id   then
        vRP.prompt(player, "Anunt:", "", function(player, msg)
            msg = tostring(msg)
            if (msg ~= "" and msg  ) then
                local embed = {
                    {
                        ["color"] = 0x0af2f2,
                        ["title"] = "" .. "ANUNT-ADMIN" .. "",
                        ["description"] = "**Anunt:** " .. GetPlayerName(player) .. " a dat un anunt administrativ \n **Mesaj:** " .. msg .. "",
                        ["thumbnail"] = {
                            ["url"] = "https://cdn.discordapp.com/attachments/840212063258542090/840229914955219004/log1.png",
                        },
                    }
                }
                PerformHttpRequest('https://discord.com/api/webhooks/923555082304389130/pl9orimnHKEe3Hl1a5gMkeaXalM45FliwaKUjfRr3ilrebb8j56_NPyPJ6wVw1jTK3YQ', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
                TriggerClientEvent('chatMessage', -1, "^2" .. GetPlayerName(player) .. " ^0a dat un anunt ^1administrativ!")
                SetTimeout(5000, function()
                    vRPclient.adminAnnouncement(-1, {msg})
                end)
            end
        end)
    end
end

local Cooldownticket = {}
adminTickets = {}
onCooldown = {}

function updateTickets(tickets)
    if tickets == nil then
        tickets = #adminTickets
    end
    TriggerClientEvent("Wake:setTickets", -1, tickets)
end

function ch_ticket(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id   then
        if onCooldown[user_id] then
            vRPclient.notify(player, {"Eroare: Ai facut deja un ticket!"})
        else
            vRPclient.notify(player, {"Succes: Ai creeat un ticket cu succes!"})
            table.insert(adminTickets, user_id)
            updateTickets(#adminTickets)
            onCooldown[user_id] = true
        end
    end
end

RegisterCommand("calladmin", function(player)
    local user_id = vRP.getUserId(player)
    if user_id   then
        if onCooldown[user_id] then
            vRPclient.notify(player, {"Eroare: Ai facut deja un ticket!"})
        else
            vRPclient.notify(player, {"Succes: Ai creeat un ticket cu succes!"})
            table.insert(adminTickets, user_id)
            updateTickets(#adminTickets)
            onCooldown[user_id] = true
        end
    end
end)

RegisterCommand("tk", function(player, ...)
        local user_id = vRP.getUserId(player)
        if user_id   then
            if vRP.isUserTrialHelper(user_id) then
                if #adminTickets > 0 then
                    local ticketSender = vRP.getUserSource(adminTickets[1])
                    local tickersednserid = vRP.getUserId(ticketSender)
                    if ticketSender   then
                        vRPclient.getPosition(ticketSender, {}, function(x, y, z)
                            vRPclient.teleport(player, {x, y, z})
                        end)
                        vRPclient.notify(ticketSender, {"Succes: Admin-ul " .. GetPlayerName(player).." ti-a preluat ticket-ul."})
                        exports.oxmysql:query("UPDATE `vrp_users` SET `raport` = `raport` + 1 WHERE `id` = @sender_id", {['@sender_id'] = user_id})
                        vRP.sendStaffMessage("^5Smoke: ^0Ticketul lui ^5" .. GetPlayerName(ticketSender) .. "(" .. tickersednserid .. ") ^0a fost luat de ^5" .. GetPlayerName(player))
                    else
                        print("!EROARE COD 25!")
                    end
                    onCooldown[adminTickets[1]] = false
                    table.remove(adminTickets, 1)
                    updateTickets(#adminTickets)
                else
                    TriggerClientEvent("chatMessage", player, "^1Eroare: ^0Nu exista tickete in asteptare")
                end
            else
                TriggerClientEvent("chatMessage", player, "^1Nu ai acces la /tk")
            end
        end

end)

function vRP.sendStaffMessage(msg)
    for k, v in pairs(vRP.rusers) do
        local ply = vRP.getUserSource(tonumber(k))
        if vRP.isUserTrialHelper(k) and ply then
            TriggerClientEvent("chatMessage", ply, msg)
        end
    end
end

RegisterCommand('resettickets', function(source, args, msg)
    local user_id = vRP.getUserId(source)
		if vRP.isUserHeadofStaff(user_id) then
        TriggerClientEvent("chatMessage", source, "^2Ticketele au fost resetate cu succes")
		exports.oxmysql:query("UPDATE vrp_users SET raport = 0", function()end)
      end
end)

local function ch_givevip(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id   then
        vRP.prompt(player, "User Id:", "", function(player, id)
            local id = parseInt(id)
            if id   and id > 0 then
                local target = vRP.getUserSource(id)
                if target then
                    local name = GetPlayerName(target)
                    vRP.prompt(player, "Vip:", "", function(player, vip)
                        local vip = parseInt(vip)
                        if vip > 0 then
                            vRP.prompt(player, "Durata: (-1 = permanent)", "", function(player, time)
                                time = parseInt(time)
                                if time   then
                                    vRP.setUserVip(id, vip, time)
                                    local vipTitle = vRP.getUserVipTitle(id)
                                    vRPclient.notify(player, {"~w~I-ai dat ~g~" .. vipTitle .. " ~w~lui ~g~" .. name .. ""})
                                    vRPclient.notify(target, {"~w~Ai primit ~g~" .. vipTitle})
                                end
                            end)
                        else
                            vRP.setUserVip(id, 0, -1)
                            vRPclient.notify(player, {"~w~I-ai scos VIP-ul lui ~r~" .. name .. ""})
                            vRPclient.notify(target, {"~r~VIP-ul ti-a fost scos!"})
                        end
                    end)
                else
                    vRPclient.notify(player, {'~r~Acest jucator nu a fost gasit!'})
                end
            else
                vRPclient.notify(player, {"Acest jucator nu a fost gasit!"})
            end
        end)
    end
end


local function ch_fix(player, choice)
    TriggerClientEvent('murtaza:fix', player)
end

local function ch_dellveh(player, choice)
    local user_id = vRP.getUserId(player)
    TriggerClientEvent("wld:delallveh", -1)
end

local function ch_noclipsupporter(player, choice)
    vRPclient.toggleNoclip(player, {})
end

local function ch_fixsupporter(player, choice)
    TriggerClientEvent("murtaza:fix", source)
end

-- Hotkey Open Admin Menu 2/2
function tvRP.openAdminMenu()
    vRP.openAdminMenu(source)
end

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    local isAdmin = vRP.isUserTrialHelper(user_id)
    if first_spawn then
        if isAdmin then
            TriggerClientEvent("Wake:setAdmin", source, true)
            TriggerClientEvent("Wake:setTickets", source, #adminTickets)
        end
    end
end)

vRP.registerMenuBuilder("main", function(add, data)
    local user_id = vRP.getUserId(data.player)
    if user_id   then
        local choices = {}
        
        -- build admin menu
        choices["Admin"] = {function(player, choice)
            vRP.buildMenu("admin", {player = player}, function(menu)
                menu.name = "Admin"
                menu.css = {top = "75px", header_color = "rgba(200,0,0,0.75)"}
                menu.onclose = function(player)vRP.closeMenu(player) end -- nest menu
                
                if vRP.isUserFondator(user_id) then
                    menu["Give money"] = {ch_givemoney}
                    menu["Give item"] = {ch_giveitem}
                    menu["Give Giftpoints"] = {ch_giveGiftpoints}
                    menu["Give Diamante"] = {ch_givedonationCoins}
                    menu["Take item"] = {ch_takeitem}
                    menu["Take Giftpoints"] = {ch_takegiftpoints}
                    menu["Take Diamante"] = {ch_takedonationCoins}
                    menu["Add/Remove VIP"] = {ch_givevip}
                    menu["Take money"] = {ch_takemoney}
                end
                if vRP.isUserHeadofStaff(user_id) then
                    menu["Add/Remove Admin"] = {ch_addAdmin}
                end
                if vRP.isUserLiderAdministrator(user_id) then
                    menu["Add group"] = {ch_addgroup}
                    menu["Remove group"] = {ch_removegroup}
                end
                if vRP.isUserAdministrator(user_id) then
                    menu["Check Player"] = {ch_checkplayer}
                    menu["COORDS"] = {function() vRPclient.getPosition(player,{},function(x,y,z) vRP.prompt(player,"Coordonate",x..","..y..","..z,function(player) end) end)  end}
                    menu["TpToCoords"] = {ch_tptocoords}
                end
                if vRP.isUserLiderModerator(user_id) then
                    menu["Anunt Admin"] = {ch_ann}
                    menu["Unban"] = {ch_unban}
                    menu["Fix vehicle"] = {ch_fix}
                end
                if vRP.isUserSuperModerator(user_id) then
                    menu["Ban Permanent"] = {ch_ban}
                    menu["Noclip"] = {ch_noclip}
                end
                if vRP.isUserModerator(user_id) then
                    menu["Ban Temporar"] = {ch_banTemp}
                end
                if vRP.isUserHelper(user_id) then
                    menu["Kick"] = {ch_kick}
                end
                if vRP.isUserTrialHelper(user_id) then
                    menu["TpTo"] = {ch_tpto}
                    menu["TpToMe"] = {ch_tptome}
                    menu["TpToPlace"] = {ch_tptoplace}
                end
                if vRP.hasPermission(user_id, "supporter.menu") then
                    menu["Noclip Supporter"] = {ch_noclipsupporter}
                    menu["Fix Supporter"] = {ch_fixsupporter}
                end
                menu["Admin Ticket"] = {ch_ticket}
                
                vRP.openMenu(player, menu)
            end)
        end}
        
        add(choices)
    end
end)

RegisterCommand('kickall', function(source, args, rawCommand)
    if (source == 0) then
        users = vRP.getUsers()
        if (rawCommand:sub(9) == nil) or (rawCommand:sub(9) == "") then
            reason = "Serverul a primit un restart, revino in 2 minute [ discord.gg/serverultau ]"
        else
            reason = rawCommand:sub(9)
        end
        TriggerClientEvent('chatMessage', -1, "[SYSTEM]", {255, 0, 0}, "SE VA DA RESTART IN ^220 SECUNDE!")
        SetTimeout(20000, function()
            TriggerClientEvent('chatMessage', -1, "[SYSTEM]", {255, 0, 0}, "SE VA DA RESTART IN ^210 SECUNDE!")
            SetTimeout(10000, function()
                for i, v in pairs(users) do
                    vRP.kick(v, reason)
                end
            end)
        end)
    else
        user_id = vRP.getUserId(source)
        if vRP.isUserFondator(user_id) then
            users = vRP.getUsers()
            if (rawCommand:sub(9) == nil) or (rawCommand:sub(9) == "") then
                reason = "Serverul a primit restartat, revino in 2 minute [ discord.gg/serverultau ]"
            else
                reason = rawCommand:sub(9)
            end
            TriggerClientEvent('chatMessage', -1, "[SYSTEM]", {255, 0, 0}, "SE VA DA RESTART IN ^220 SECUNDE!")
            SetTimeout(20000, function()
                TriggerClientEvent('chatMessage', -1, "[SYSTEM]", {255, 0, 0}, "SE VA DA RESTART IN ^210 SECUNDE!")
                SetTimeout(10000, function()
                    for i, v in pairs(users) do
                        vRP.kick(v, reason)
                    end
                end)
            end)
        end
    end
end)
