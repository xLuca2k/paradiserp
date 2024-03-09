RegisterNetEvent("hud:updateThings", function(k, v)
  SendNUIMessage{ event = "updateHud", updateHud = "DA", cemodifica = k, valoare = v };
end);

Citizen["CreateThread"](function()
  while true do
  if lastPos ~= GetEntityCoords(PlayerPedId()) then
    -- Update lastPos
    lastPos = GetEntityCoords(PlayerPedId());
    -- Send to server
    local var1, var2 = GetStreetNameAtCoord(GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z)
    secondStreet = GetStreetNameFromHashKey(var1)
    theStreet = GetStreetNameFromHashKey(var2)
  end  

    if secondStreet:len() < 2 then
        secondStreet = "Necunoscuta"
    elseif theStreet:len() < 2 then
        theStreet = "Necunoscuta"
    end
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)/2
    local armor = GetPedArmour(ped)
    SendNUIMessage{event = "updateHud", updateHud = "DA", cemodifica = "street1", valoare = theStreet};
    SendNUIMessage{event = "updateHud", updateHud = "DA", cemodifica = "street2", valoare = secondStreet};
    SendNUIMessage{event = "updateHud", updateHud = "DA", cemodifica = "health", valoare = health};
    SendNUIMessage{event = "updateHud", updateHud = "DA", cemodifica = "armor", valoare = armor};
    Citizen["Wait"](2500)

  end
end)
