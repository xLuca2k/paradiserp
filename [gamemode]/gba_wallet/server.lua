local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

RegisterServerEvent('get:user:data',function()
    local player = source
    local user_id = vRP.getUserId{player}
    local uMoney = vRP.getMoney{user_id}
    local uPermis = vRP.getInventoryItemAmount{user_id, 'permisidk'}
    local uCamion = true -- Sa mor de stiu la ce se refera
    local uMotor = true -- same shit si aici
    local uCard = vRP.getInventoryItemAmount{user_id, 'cardbancar'}
    TriggerClientEvent('wallet:get:data', player, uMoney, uPermis, uCamion. uMotor, user_id, uCard)
end)