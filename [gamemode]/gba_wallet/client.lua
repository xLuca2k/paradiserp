RegisterNetEvent("wallet:get:data", function(bani, permisul, motor, camion, cnp, are_card)
	SendNuiMessage(json.encode({
		showUI = true,
		bani = bani,
		per = permisul,
		cam = camion,
		mot = motor,
		cp = cnp,
		are = are_card
	}))
	SetNuiFocus(true, true)
end)

RegisterCommand("+portofel", function()
	ExecuteCommand("e adjust")
	Citizen.Wait(700)
	TriggerServerEvent("get:user:data") 
	Citizen.Wait(500)
end)

RegisterKeyMapping("+portofel", "PORTOFEL", "KEYBOARD", "F10")
RegisterKeyMapping("vehiclemenu", "MENU", "KEYBOARD", "M")

RegisterNUICallback("close", function()
	SetNuiFocus(false, false)
end)

RegisterNUICallback("show", function()
    TriggerServerEvent("show:id")
end)