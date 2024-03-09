--bind client tunnel interface
vRPbm = {}
Tunnel.bindInterface("vRP_basic_menu", vRPbm)
vRPserver = Tunnel.getInterface("vRP", "vRP_basic_menu")
HKserver = Tunnel.getInterface("vrp_hotkeys", "vRP_basic_menu")
BMserver = Tunnel.getInterface("vRP_basic_menu", "vRP_basic_menu")
vRP = Proxy.getInterface("vRP")

local fontsLoaded = false
local fontId
Citizen.CreateThread(function()
    Citizen.Wait(1000)
    RegisterFontFile('wmk')
    fontId = RegisterFontId('Freedom Font')
    fontsLoaded = true
end)

checkpoints = 0
local stage = 1
aJailReason = " "


local frozen = false
local unfrozen = false
local freeze = false
function vRPbm.loadFreeze(freeze)
    freeze = not freeze
    frozen = true
end

function vRPbm.setInAJail(jailTime, jailReason, staff)
    staff2 = staff
    aJailReason = jailReason
    checkpoints = jailTime
end

local locatiijail = {}
RegisterNetEvent("ajail:config", function(tbl)
    if type(tbl) == "table" then 
        locatiijail = tbl
    end
end)

function start(task)
    vRP.playAnim({false, {task = task.anim}, false})
    FreezeEntityPosition(ped,true)
    SetTimeout(15000, function()
        vRP.stopAnim({false})
        FreezeEntityPosition(ped,false)
        EnableControlAction(0, 311, true)
        task.active = true
        SetTimeout(100 * 10, function()task.active = false; end)
    end)
end

function adminjailtxt(text, font, centre, x, y, scale, r, g, b, a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

Citizen.CreateThread(function()
    local x2, y2, z2 = 1179.6831054688,131.70155334473,80.889915466309
    local mainloc = vec3(1140.0036621094,119.85138702393,81.082542419434)
    local ticks = 1000
    while true do
        Wait(30)
        while (checkpoints > 0) do
            Wait(0)
            local playerPos = GetEntityCoords(PlayerPedId(), true)
            local px, py, pz = playerPos.x, playerPos.y, playerPos.z
            for k, v in pairs(locatiijail) do
                local once = false;
                ticks = 1
                while not v.active and checkpoints > 0 do
                    local playerPos = GetEntityCoords(PlayerPedId(), true)
                    if #(playerPos - mainloc) > 100.0 then
                        SetEntityCoords(PlayerPedId(), mainloc.x, mainloc.y, mainloc.z)
                        vRP.notify({"Nu mai incerca :("})
                    end
                    Wait(1)
                    SetEntityHealth(PlayerPedId(), 200)
                    DisableControlAction(0, 21, true)
                    DisableControlAction(0, 22, true)
                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 25, true)
                    DisableControlAction(0, 47, true)
                    DisableControlAction(0, 58, true)
                    DisableControlAction(0, 263, true)
                    DisableControlAction(0, 23, true)
                    DisableControlAction(0, 264, true)
                    DisableControlAction(0, 29, true)
                    DisableControlAction(0, 121, true)
                    DisableControlAction(0, 311, true)
                    DisableControlAction(0, 20, true)
                    DisableControlAction(0, 73, true)
                    DisableControlAction(0, 257, true)
                    DisableControlAction(0, 36, true)
                    DisableControlAction(0, 140, true)
                    DisableControlAction(0, 141, true)
                    DisableControlAction(0, 142, true)
                    DisableControlAction(0, 249, true)
                    DisableControlAction(0, 245, true)
                    DisableControlAction(0, 246, true)
                    DisableControlAction(0, 288, true)
                    DisableControlAction(0, 143, true)
                    DisableControlAction(0, 75, true)
                    DisableControlAction(27, 75, true)
                    adminjailtxt("~r~Admin Jail", 4, 1, 0.5, 0.808, 0.60, 255, 255, 255, 200)
                    adminjailtxt("~w~Mai ai de parcurs ~r~" .. checkpoints .. " checkpoint-uri", 4, 1, 0.5, 0.84, 0.60, 255, 255, 255, 200)
                    adminjailtxt("~w~Motiv: ~b~" .. aJailReason.." ~w~| ~b~"..staff2, 4, 1, 0.5, 0.872, 0.60, 255, 255, 255, 200)
                    local playerPos = GetEntityCoords(PlayerPedId(), true)
                    DrawMarker(0, v.pos, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 50.00, 97, 195, 0, 90, 1, 0, 0, 0)
                    DrawMarker(0, locatiijail[stage].cds.x, locatiijail[stage].cds.y, locatiijail[stage].cds.z, 0, 0, 0, 0, 0, 0, 2.8, 2.8, 9.8, 0, 153, 51, 100, 0, 0, 0, 0)
                    DrawMarker(0, locatiijail[stage + 1].cds.x, locatiijail[stage + 1].cds.y, locatiijail[stage + 1].cds.z, 0, 0, 0, 0, 0, 0, 2.8, 2.8, 9.8, 255, 51, 0, 100, 0, 0, 0, 0)
                    if #(playerPos - locatiijail[stage].cds) <= 0.5 and not once then
                        once = true
                        locatiijail[stage].active = true
                        checkpoints = checkpoints - 1
                        BMserver.updateCheckpoints({checkpoints})
                        start(v)
                        SetTimeout(1, function()locatiijail[stage].active = false; stage = stage + 1; if stage == 19 then stage = 1 end; end)
                    end
                end
                Wait(ticks)
            end
            if #(vector3(x2, y2, z2) - vector3(px, py, pz)) > 40.0 then
                SetEntityCoords(PlayerPedId(), x2, y2, z2)
            end
        end
    end
end)

local frozen = false
local unfrozen = false
function vRPbm.loadFreeze(freeze)
    if freeze then
        frozen = true
        unfrozen = false
    else
        unfrozen = true
    end
end

local playerMask = GetPedDrawableVariation(PlayerPedId(), 1) or 0
local playerMaskColor = GetPedTextureVariation(PlayerPedId(), 1) or 0


function vRPbm.spawnVehicle(model)
    -- load vehicle model
    local i = 0
    local mhash = GetHashKey(model)
    while not HasModelLoaded(mhash) and i < 1000 do
        if math.fmod(i, 100) == 0 then
            vRP.notify({"~y~Masina se incarca"})
        end
        RequestModel(mhash)
        Citizen.Wait(800)
        i = i + 1
    end
    
    if HasModelLoaded(mhash) then
        local x, y, z = vRP.getPosition({})
        local nveh = CreateVehicle(mhash, x, y, z + 0.5, GetEntityHeading(PlayerPedId()), true, false)
        SetVehicleOnGroundProperly(nveh)
        SetEntityInvincible(nveh, false)
        SetPedIntoVehicle(PlayerPedId(), nveh, -1)
        Citizen.InvokeNative(0xAD738C3085FE7E11, nveh, true, true)
        SetVehicleHasBeenOwnedByPlayer(nveh, true)
        SetModelAsNoLongerNeeded(mhash)
        SetVehicleNumberPlateText(nveh, "SPAWNVEH")
        vRP.notify({"~g~Masina spawnata cu succes"})
    else
        vRP.notify({"~r~Model masina invalid"})
    end
end

local maleModel = GetHashKey("mp_m_freemode_01")
local femaleModel = GetHashKey("mp_f_freemode_01")

function vRPbm.getArmour()
    return GetPedArmour(PlayerPedId())
end

function vRPbm.setArmour(armour, vest)
    local ped = PlayerPedId()
    if vest then
        
        RequestAnimDict("clothingtie")
        while not HasAnimDictLoaded("clothingtie") do
            Citizen.Wait(3)
        end
        TaskPlayAnim(ped, "clothingtie", "try_tie_negative_a", 3.0, 3.0, 2000, 01, 0, false, false, false)
        
        local model = GetEntityModel(ped)
        
        if model == maleModel then
            SetPedComponentVariation(ped, 9, 6, 1, 2)--Bulletproof Vest
        elseif model == femaleModel then
            SetPedComponentVariation(ped, 9, 6, 1, 2)
        end
    end
    local n = math.floor(armour)
    SetPedArmour(ped, n)
end

local state_ready = false

AddEventHandler("playerSpawned", function()
    state_ready = false
    Citizen.CreateThread(function()
        Citizen.Wait(30000)
        state_ready = true
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000)
        if IsPlayerPlaying(PlayerId()) and state_ready then
            if vRPbm.getArmour() == 0 then
                if (GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01")) or (GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01")) then
                    SetPedComponentVariation(PlayerPedId(), 9, 0, 1, 2)
                end
            end
        end
    end
end)



RegisterNetEvent('clearskin:success')
AddEventHandler('clearskin:success', function()
    local ped = PlayerPedId({player})
    ClearPedBloodDamage(ped)
    ResetPedVisibleDamage(ped)
    ClearPedWetness(ped)
end)
