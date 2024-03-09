RegisterNetEvent('core:updateHud')
AddEventHandler('core:updateHud', function(w, v)   
    SendNUIMessage({
        action = 'updateHudStats',
        what = w,
        value = v
    })
end)

Citizen.CreateThread(function()
    while true do 
        Wait(1000)
        TriggerServerEvent('core:updateInfo')
    end
end)