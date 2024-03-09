local titles = {"Vip Bronze", "Vip Silver", "Vip Gold", "Vip Diamond", "Vip Supreme"}
playerPerks = {}

local vipSalary = { 
	[1] = {1000000},
	[2] = {2000000},
	[3] = {3000000},
	[4] = {4000000},
    [5] = {5000000}
}

function formatOsTime(timp)
    if (((timp / 60) / 60) < 24) then
        return parseInt((timp / 60) / 60) .. " ore"
    else
        local zile = parseInt(((timp / 60) / 60) / 24)
        local ore = parseInt((timp / 60) / 60) - (parseInt(((timp / 60) / 60) / 24 * 24))
        return zile .. " zile"
    end
end

function toboolean(x)
    if x == 1 then
        return true
    end
    return false
end

function frombool(x)
    if x then
        return 1
    end
    return 0
end

function vRP.getUserVipRank(user_id)
    local tmp = playerPerks[user_id]
    if tmp then
        vipRank = tmp.vipLvl
    end
    return vipRank or 0
end

function vRP.isUserVip(user_id)
    local vipRank = vRP.getUserVipRank(user_id)
    if (vipRank > 0) then
        return true
    else
        return false
    end
end

function vRP.isUserVipBronze(user_id)
    local vipRank = vRP.getUserVipRank(user_id)
    if (vipRank >= 1) then
        return true
    else
        return false
    end
end

function vRP.isUserVipSilver(user_id)
    local vipRank = vRP.getUserVipRank(user_id)
    if (vipRank >= 2) then
        return true
    else
        return false
    end
end

function vRP.isUserVipGold(user_id)
    local vipRank = vRP.getUserVipRank(user_id)
    if (vipRank >= 3) then
        return true
    else
        return false
    end
end

function vRP.isUserVipDiamond(user_id)
    local vipRank = vRP.getUserVipRank(user_id)
    if (vipRank >= 4) then
        return true
    else
        return false
    end
end

function vRP.isUserVipSupreme(user_id)
    local vipRank = vRP.getUserVipRank(user_id)
    if (vipRank >= 5) then
        return true
    else
        return false
    end
end

function vRP.setUserVip(user_id, vip, time)
    local tmp = playerPerks[user_id]
    local vipHash = os.time() + (60 * 60 * ((time or 0) * 24))
    if time == -1 then
        vipHash = 0
    end
    if vip >= #titles then
        vip = 5
    end
    if tmp then
        tmp.vipLvl = vip
        tmp.vipTime = vipHash
    end
    exports.oxmysql:query('UPDATE vrp_users SET vipLvl = ' .. vip .. ', vipTime = ' .. vipHash .. ' WHERE id = ' .. user_id, {})
end

function vRP.getUserVipTitle(user_id)
    local text = titles[vRP.getUserVipRank(user_id)] or "Vip Civil :)"
    return text
end

function vRP.getVipSalary(vip)
	local salary = vipSalary[vip][1]
	return salary
end

function vRP.getOnineVips(group)
    local oUsers = {}
    for k, v in pairs(vRP.rusers) do
        if vRP.isUserVip(tonumber(k)) then table.insert(oUsers, tonumber(k)) end
    end
    return oUsers
end

AddEventHandler('vRP:playerSpawn', function(user_id, player, first_spawn)
    local time = os.time()
    if first_spawn then
        exports.oxmysql:query('SELECT vipLvl,vipTime FROM `vrp_users` WHERE id = ' .. user_id, {}, function(rows)
            if #rows > 0 then
                playerPerks[user_id] = {
                    vipLvl = tonumber(rows[1].vipLvl) or 0,
                    vipTime = tonumber(rows[1].vipTime) or 0,
                }
                if playerPerks[user_id].vipLvl > 0 then
                    vRPclient.notify(player, {"Succes: Detii statutul de " .. vRP.getUserVipTitle(user_id)})
                    if playerPerks[user_id].vipTime > 0 then
                        vRPclient.notify(player, {'Info: Statutul de VIP iti expira in ' .. formatOsTime(playerPerks[user_id].vipTime - time)})
                    end
                    if time > playerPerks[user_id].vipTime and playerPerks[user_id].vipTime > 0 then
                        if playerPerks[user_id].vipTime > 0 then
                            vRPclient.notify(player, {'Succes: Statutul de membru VIP ti-a expirat!'})
                            exports.oxmysql:query('UPDATE vrp_users SET vipLvl = 0, vipTime = 0 WHERE id = ' .. user_id, {})
                            playerPerks[user_id].vipLvl = 0
                            playerPerks[user_id].vipTime = 0
                        end
                    end
                end
            end
        end)
    end
end)