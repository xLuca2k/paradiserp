-- PINGUL JUCATORULUI 
time = 1000

Citizen.CreateThread(function()
    while true do
        Wait(time)

        TriggerServerEvent("verificaPing")
    end
end)

secundeKick = 300
warningKick = true

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        playerPed = GetPlayerPed(-1)
        if playerPed then 
            currentpos = GetEntityCoords(playerPed, true)
            if currentpos == prevpos then
                if time > 0 then 
                    if warningKick and time == math.ceil(secundeKick / 4) then
                        TriggerServerEvent("chatMessage", "Atentie", {255,0,0 }, "Vei primi kick in "..time.." pentru ca esti AFK!")
                    end
                    time = time - 1
                else
                    TriggerServerEvent("kickAfk")
                end
            else
                time = secundeKick
            end
            prevpos = currentpos
        end
    end
end)