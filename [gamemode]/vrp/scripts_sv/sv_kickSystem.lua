limitPing = 500

RegisterServerEvent("verificaPing")
AddEventHandler("verificaPing", function()
    local ping = GetPlayerPing(source)
    if ping >= limitPing then
        DropPlayer(src, "Ai avut prea mult ping!")
    end
end)

RegisterServerEvent("kickAfk")
AddEventHandler("kickAfk", function()
DropPlayer(source, "Ai stat AFK prea mult timp!")
end)
