local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")


RegisterNetEvent('core:updateInfo')
AddEventHandler('core:updateInfo', function()
    local source = source
    local uID = vRP['getUserId']{source}
    if not uID then return end 
    local onlinePlayers = GetNumPlayerIndices()
    local ping = GetPlayerPing(source)
    TriggerClientEvent('core:updateHud', -1, 'online', onlinePlayers)
    TriggerClientEvent('core:updateHud',source, 'uId', uID)
    TriggerClientEvent('core:updateHud', source, 'ping', ping)
end)