local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
BMclient = Tunnel.getInterface("vRP_basic_menu","vRP_chatroles")
vRPclient = Tunnel.getInterface("vRP","vRP_chatroles")
vRPsp = Proxy.getInterface("vRP_sponsor")

RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:muitzaqmessageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

RegisterServerEvent('chat:kickSpammer')
AddEventHandler('chat:kickSpammer', function()
	TriggerClientEvent('chatMessage', -1, "^1[SPAM] ^2"..GetPlayerName(source).."^8 a primit kick pentru spam!")
	DropPlayer(source, 'Nu mai spama ratatule!')
end)


AddEventHandler('_chat:muitzaqmessageEntered', function(author, color, message)
    if not message or not author then
        return
    end

    TriggerEvent('chatMessage', source, author, message)

    if not WasEventCanceled() then
		local user_id = vRP.getUserId({source})
		local player = vRP.getUserSource({user_id})
		local pName = GetPlayerName(player)
		local author = "["..user_id.."] "..author
		
		if vRP.isUserFondator({user_id}) then
			tag = "[FONDATOR]"
			rgb = {152, 0, 255}
		elseif vRP.isUserHeadofStaff({user_id}) then
			tag = "[HEAD OF STAFF]"
			rgb = {76, 195, 255}
		elseif vRP.isUserAdministrator({user_id}) then	
			tag = "[ADMINISTRATOR]"
			rgb = {216, 10, 62}
		elseif vRP.isUserSuperModerator({user_id}) then
			tag = "[MODERATOR AVANSAT]"
			rgb = {76, 195, 255}
		elseif vRP.isUserModerator({user_id}) then	
			tag = "[MODERATOR]"
			rgb = {101, 153, 51}
		elseif vRP.isUserHelperAvansat({user_id}) then
			tag = "[HELPER AVANSAT]"
			rgb = {76, 195, 255}
		elseif vRP.isUserHelper({user_id}) then	
			tag = "[HELPER]"
			rgb = {191, 28, 137}
		elseif vRP.isUserTrialHelper({user_id}) then	
			tag = "[HELPER IN TESTE]"
			rgb = {153, 0, 153}
		elseif vRP.hasGroup({user_id, "sponsors"}) then
			local theTag = vRPsp.getSponsorTag({user_id})
			if(theTag ~= false)then
				tag = theTag
			else
				tag = "[SPONSOR]"
			end
			rgb = {216, 216, 32}
		elseif (user_id == 15101) then
			tag = "[#SpargeTotðŸ˜ˆ]"
			rgb = {255, 0, 0}
		elseif (user_id == 11749) then
			tag = "[Best-Aim]"
			rgb = {255, 0, 0}
		elseif (vRP.isUserVip({user_id})) then
			vipRank = vRP.getUserVipTitle({user_id})
			tag = "["..vipRank.."]"
			rgb = {65, 239, 11}
		elseif vRP.isUserInFaction({user_id,"Politie"}) then
			tag = "[Politist]"
			rgb = {0, 97, 255}
		elseif vRP.isUserInFaction({user_id,"Avocat"}) then
			tag = "[Avocat]"
			rgb = {0, 97, 255}
		elseif vRP.isUserInFaction({user_id,"SIAS"}) then
			tag = "[Agent SIAS]"
			rgb = {50, 0, 205}
		elseif vRP.isUserInFaction({user_id,"Smurd"}) then
			tag = "[Medic]"
			rgb = {153, 0, 50}
		elseif vRP.isUserInFaction({user_id,"Hitman"}) then
			tag = "[Agent Hitman]"
			rgb = {102, 54, 6}
		elseif vRP.isUserInFaction({user_id,"SRI"}) then
			tag = "[Agent SRI]"
			rgb = {102, 54, 6}
		elseif vRP.isUserInFaction({user_id,"Bloods"}) then
			tag = "[Membru Bloods]"
			rgb = {12, 250, 255}
		elseif vRP.isUserInFaction({user_id,"Mafia Rusa"}) then
			tag = "[Membru Mafia Rusa]"
			rgb = {216, 130, 0}
		elseif vRP.isUserInFaction({user_id,"Familia Gambino"}) then
			tag = "[Membru Familia Gambino]"
			rgb = {216, 130, 0}
		elseif vRP.isUserInFaction({user_id,"Mafia Albaneza"}) then
			tag = "[Membru Albaneza]"
			rgb = {126, 79, 147}
		elseif vRP.isUserInFaction({user_id,"Cartel de Cali"}) then
			tag = "[Membru Cartel de Cali]"
			rgb = {251, 37, 91}
		elseif vRP.isUserInFaction({user_id,"Jardini"}) then
			tag = "[Membru Jardini]"
			rgb = {0, 172, 255}
		elseif vRP.isUserInFaction({user_id,"Crips"}) then
			tag = "[Membru Crips]"
			rgb = {50, 172, 255}
		elseif vRP.isUserInFaction({user_id,"Mafia AlCapone"}) then
			tag = "[Membru Mafia AlCapone]"
			rgb = {0, 172, 200}
		elseif vRP.isUserInFaction({user_id,"Cartel de Medelin"}) then
			tag = "[Membru Cartel de Medelin]"
			rgb = {0, 150, 190}
		elseif vRP.isUserInFaction({user_id,"Cosa Nostra"}) then
			tag = "[Membru Cosa Nostra]"
			rgb = {0, 20, 200}
		elseif vRP.isUserInFaction({user_id,"Bratva"}) then
			tag = "[Membru Bratva]"
			rgb = {0, 172, 190}
		elseif vRP.isUserInFaction({user_id,"Los Vagos"}) then
			tag = "[Membru Los Vagos]"
			rgb = {128, 128, 128}
		elseif vRP.isUserInFaction({user_id,"Mafia Yakuza"}) then
			tag = "[Membru Yakuza]"
			rgb = {255, 255, 255}
		elseif vRP.isUserInFaction({user_id,"Familia Zivojel"}) then
			tag = "[Familia Zivojel]"
			rgb = {255, 255, 255}
		elseif vRP.isUserInFaction({user_id,"Ballas"}) then
			tag = "[Membru Ballas]"
			rgb = {76, 195, 255}
		elseif vRP.isUserInFaction({user_id,"Mafia Columbiana"}) then
			tag = "[Membru Mafia Columbiana]"
			rgb = {128, 128, 100}
		elseif vRP.isUserInFaction({user_id,"Moldos"}) then
			tag = "[Membru Moldos]"
			rgb = {128, 100, 128}
			elseif vRP.isUserInFaction({user_id,"Camorra"}) then
			tag = "[Membru Camorra]"
			rgb = {255, 93, 0}
		elseif vRP.isUserInFaction({user_id,"Mafia Italiana"}) then
			tag = "[Membru Italiana]"
			rgb = {255, 93, 0}
		elseif(vRP.hasUserFaction({user_id}) == false)then
			tag = "[Civil]"
			rgb = {255, 204, 0}
		else
			tag = "[Civil]"
			rgb = {255, 204, 0}
		end
		
		TriggerClientEvent('chatMessage', -1, tag..""..author, rgb, " " ..  message)
		
		print(author .. ': ' .. message)
    end
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    TriggerEvent('chatMessage', source, name, '/' .. command)

    if not WasEventCanceled() then
		local user_id = vRP.getUserId({source})
		local player = vRP.getUserSource({user_id})
		local pName = GetPlayerName(player)
		local author = "["..user_id.."] "..name
		local theTag = vRPsp.getSponsorTag({user_id})
		message = "/"..command
    end

    CancelEvent()
end)

RegisterCommand('saytrf', function(source, args, rawCommand)
	if(source == 0)then
		TriggerClientEvent('chatMessage', -1, "[CONSOLA]", { 255, 0, 0 }, rawCommand:sub(5))
	end
end)

local function giveAllBankMoney(amount, sphynx)  
    local users = vRP.getUsers({})
    for user_id, source in pairs(users) do
        if not sphynx then
            vRP.giveKRCoins({user_id, tonumber(amount)})
        else
            vRP.giveSPoints({user_id, tonumber(amount), true})
        end
    end
end

RegisterCommand("bonus", function(player, args)
    if player == 0 then
        local theMoney = parseInt(args[1]) or 0
        if theMoney >= 1 then
            giveAllBankMoney(theMoney, false)
            TriggerClientEvent("chatMessage", -1, "^1Info^0: Server-ul a oferit tuturor jucatorilor ^7$"..vRP.formatMoney({theMoney}).."^0 !")
        else
            print("/bonus <suma>")
        end
    else
        local user_id = vRP.getUserId({player})
        if vRP.isUserFondator({user_id}) then 
            local theMoney = parseInt(args[1]) or 0
            if theMoney >= 1 then
                giveAllBankMoney(theMoney, false)
                TriggerClientEvent("chatMessage", -1, "^1BONUS^0: ^7"..vRP.getPlayerName({player}).."^7 a oferit tuturor jucatorilor ^1"..vRP.formatMoney({theMoney}).." ^0Krown Point-uri !")
            else
                TriggerClientEvent("chatMessage", player, "^1Krown^0: /bonus <suma>")
            end
        else
            TriggerClientEvent("chatMessage", player, "^1Krown Eroare^0: Nu ai acces la aceasta comanda")
        end
    end
end, false)

RegisterCommand('clear', function(source)
    local user_id = vRP.getUserId({source});
    if user_id ~= nil then
        if vRP.isUserHelper({user_id}) then
            TriggerClientEvent("chat:clear", -1);
            TriggerClientEvent("chatMessage", -1, "^1Server^0: Adminul ^1".. GetPlayerName(source) .."^0 a sters tot chat-ul.");
        else
            TriggerClientEvent("chatMessage", source, "^1Eroare^0: Nu ai acces la aceasta comanda.");
        end
    end
end)

RegisterCommand("reviveall", function(player)
    local user_id = vRP.getUserId({player})
    if vRP.isUserHelper({user_id}) then
        local users = vRP.getUsers({})
        for k, v in pairs(users) do 
            Citizen.Wait(20)
            if v then
                vRPclient.varyHealth(v, {100})
                SetTimeout(500, function()
                    vRPclient.varyHealth(v, {100})
                end)
            end
        end
        TriggerClientEvent("chatMessage", -1, "^1[Krown]^7: "..GetPlayerName(player).." a dat revive la tot server-ul")
    else
        vRPclient.noAccess(player, {})
    end
end)

RegisterCommand("respawnall", function(player)
    local user_id = vRP.getUserId({player})
    if vRP.isUserAdministrator({user_id}) then
        local users = vRP.getUsers({})
        for k, v in pairs(users) do 
            Citizen.Wait(20)
            if v then
                vRPclient.teleport(v, {150.90187072754,-679.77416992188,42.029479980469})
            end
        end
        TriggerClientEvent("chatMessage", -1, "^1RespawnAll^7: "..GetPlayerName(player).." a dat respawn la tot server-ul")
    else
        vRPclient.noAccess(player, {})
    end
end)

RegisterCommand("respawn", function(player, args)
	local user_id = vRP.getUserId({player})
	if vRP.isUserTrialHelper({user_id}) then
		local target_id = parseInt(args[1])
		local target_src = vRP.getUserSource({target_id})
		if target_src then
			vRPclient.teleport(target_src, {150.90187072754,-679.77416992188,42.029479980469})
		else
			TriggerClientEvent("chatMessage", player, "^1Syntax^7: /respawn <user_id>")
		end
	else
		TriggerClientEvent("chatMessage", player, "^1Eroare^7: Nu ai acces la aceasta comanda")
	end
end, false)

--------------------------EVENT-----------------------------
RegisterCommand("event", function(player)
    local user_id = vRP.getUserId({player})
    if vRP.isUserHeadofStaff({user_id}) then
        if not eventOn then
            vRPclient.getPosition(player, {}, function(x, y, z)
                evCoords = {x, y, z + 0.5}
            end)
            eventOn = true
            TriggerClientEvent("chatMessage", -1, "^1[Event]^0: Adminul "..vRP.getPlayerName({player}).." a pornit un eveniment ! Foloseste </goevent> pentru a da tp acolo")

        end
    else
        TriggerClientEvent("chatMessage", player, "^1[Eroare]^7: Nu ai acces la aceasta comanda")
    end
end, false)


RegisterCommand("goevent", function(player)
    if eventOn then
        vRPclient.teleport(player, {evCoords[1], evCoords[2], evCoords[3]})
        TriggerClientEvent("zedutz:setFreeze", player, true)
    else
        TriggerClientEvent("chatMessage", player, "^1[Eroare]^7: Nu exista nici un eveniment activ")
    end
end, false)

RegisterCommand('a', function(source, args, rawCommand)
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
        if(args[1] == nil)then
            TriggerClientEvent('chatMessage', source, "^1SYNTAXA: /"..rawCommand.." [MESAJ]") 
        else
            if(vRP.isUserTrialHelper({user_id}))then
                local users = vRP.getUsers({})
                for uID, ply in pairs(users) do
                    if vRP.isUserTrialHelper({uID}) then
                        TriggerClientEvent('chatMessage', ply, "^0[^1STAFF CHAT^0] ^0"..vRP.getPlayerName({source}).." ("..user_id..") » ^1" ..rawCommand:sub(2))
                    end
                end
            end
        end
    end
end)

RegisterCommand("startevent", function(player)
    local user_id = vRP.getUserId({player})
    if vRP.isUserHeadofStaff({user_id}) then
        if eventOn then
            evCoords = {}
            eventOn = false

            TriggerClientEvent("chatMessage", -1, "^0Event^7: Event-ul a inceput. Jucatorii nu mai pot folosi comanda /goevent !")
        else
            TriggerClientEvent("chatMessage", player, "^0Eroare^7: Nu exista nici un eveniment activ !")
        end
    else
        TriggerClientEvent("chatMessage", player, "^1Eroare^7: Nu ai acces la aceasta comanda")
    end
end, false)

RegisterCommand("fh", function(source)
    local user_id = vRP.getUserId({source})
    if vRP.isUserFondator({user_id}) then
        vRP.varyHunger({user_id, -100})
        vRP.varyThirst({user_id, -100})
        vRPclient.varyHealth(source, {100})
        vRPclient.notify(source,{"~y~[~w~KrownRP~y~]\n~g~Te-ai facut full boss!"})
   else
    vRPclient.notify(source,{"~y~[~w~KrownRP~y~]\n~r~Nu ai acces la aceasta comanda !"})
        end
	end)

	RegisterCommand("revive", function(source,args,rawCommand)
		if source == 0 then
			local target_id = args[1]
			if target_id ~= nil and target_id ~= "" then 
				local nplayer = vRP.getUserSource({tonumber(target_id)})
				vRPclient.isInComa(nplayer,{}, function(in_coma)
					if in_coma then
						vRPclient.varyHealth(nplayer,{100}) 
						SetTimeout(150, function()
							vRPclient.varyHealth(nplayer,{100})
							vRP.varyHunger({target_id,-100})
							vRP.varyThirst({target_id,-100})
						end)
						vRPclient.notify(nplayer,{"~y~[~w~KrownRP~y~]\nAi fost Inviat de catre cineva din ~r~Consola "})
						print("Ai Inviat pe ~g~"..GetPlayerName(nplayer))
					else
						print("~r~Jucatorul nu este in coma!")
					end
				end)
			else
				print("~r~Id-ul nu a fost selectat.")
			end 
		else
			print("~r~Ce incerci nene?")
		end
	end)

	RegisterCommand('anunt', function(source, args, msg)
		local anunt = table.concat(args, " ")
		local nume = GetPlayerName(source)
		local user_id = vRP.getUserId({source})
		if vRP.isUserTrialHelper({user_id}) then
			TriggerClientEvent('chatMessage', -1, "^5[PDS] ^0Adminul ^5"..nume.." ^0 Anunta : ^5"..anunt.." ^0!")
		else
			TriggerClientEvent('chatMessage', source, "^8Nu ai acces la aceasta comanda")
		end
	end)

	RegisterCommand("nc", function(player)
	local user_id = vRP.getUserId({player})
	if vRP.isUserAdministrator({user_id}) then
		vRPclient.toggleNoclip(player, {})
	else
		TriggerClientEvent("chatMessage", source, "^1Eroare^0: Nu ai acces la aceasta comanda.")
	end
end)

RegisterCommand("tp", function(player, args)
	local user_id = vRP.getUserId({player})
	if vRP.isUserTrialHelper({user_id}) then
		if args[1] and args[1] ~= "" then
			local target_id = parseInt(args[1])
			local target_src = vRP.getUserSource({target_id})
			if target_src then
				vRPclient.getPosition(target_src, {}, function(x, y, z)
					vRPclient.teleport(player, {x, y, z})
					vRPclient.notify(player, {"~y~[~w~Paradise~y~]\nTe-ai teleportat la "..vRP.getPlayerName({target_src}).." ["..target_id.."]"})
					vRPclient.notify(target_src, {"~y~[~w~Paradise~y~]\nAdminul "..vRP.getPlayerName({player}).." ["..user_id.."] s-a teleportat la tine"})
				end)
			else
				TriggerClientEvent("chatMessage", player, "^1Eroare^7: Jucatorul nu este conectat !")
			end
		else
			TriggerClientEvent("chatMessage", player, "^1Syntax^7: /tpto <user_id>")
		end
	else
		TriggerClientEvent("chatMessage", player, "^1Eroare^7: Nu ai acces la aceasta comanda !")
	end
end, false)

RegisterCommand("tpme", function(player, args)
	local user_id = vRP.getUserId({player})
	if vRP.isUserTrialHelper({user_id}) then
		if args[1] and args[1] ~= "" then
			local target_id = parseInt(args[1])
			local target_src = vRP.getUserSource({target_id})
			if target_src then
				vRPclient.getPosition(player, {}, function(x, y, z)
					vRPclient.teleport(target_src, {x, y, z})
					vRPclient.notify(player, {"~y~[~w~KrownRP~y~]\nL-ai teleportat la tine pe "..vRP.getPlayerName({target_src}).." ["..target_id.."]"})
					vRPclient.notify(target_src, {"~y~[~w~KrownRP~y~]\nAdminul "..vRP.getPlayerName({player}).." ["..user_id.."] te-a teleportat la el"})
				end)
			else
				TriggerClientEvent("chatMessage", player, "^1Eroare^7: Jucatorul nu este conectat !")
			end
		else
			TriggerClientEvent("chatMessage", player, "^1Syntax^7: /tptome <user_id>")
		end
	else
		TriggerClientEvent("chatMessage", player, "^1Eroare^7: Nu ai acces la aceasta comanda !")
	end
end, false)

RegisterCommand("tpw", function(player)
	local user_id = vRP.getUserId({player})
	if vRP.isUserModerator({user_id}) then
		TriggerClientEvent("TpToWaypoint", player)
	else
		TriggerClientEvent("chatMessage", player, "^1Eroare^7: Nu ai acces la aceasta comanda !")
	end
end, false)

RegisterCommand("banca", function(source, args, rawCommand)
	local user_id = vRP.getUserId({source})
	local bank = vRP.getBankMoney({user_id})
	TriggerClientEvent('chatMessage', source, "^3[Banca]", {0,0,0}, "^5Ai: ^7"..format_thousand(bank).." ^2$")
  end, false)
  
  RegisterCommand("bani", function(source, args, rawCommand)
	local user_id = vRP.getUserId({source})
	local wallet = vRP.getMoney({user_id})
	TriggerClientEvent('chatMessage', source, "^3[Bani]", {0,0,0}, "^5Ai: ^7"..format_thousand(wallet).." ^2$")
  end, false)
  
  function format_thousand(amount)
	local formatted = amount
	while true do  
	  formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
	  if (k==0) then
		break
	  end
	end
	return formatted
  end


	function formatMoney(amount)
		local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
		return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
	  end	

RegisterCommand("ore", function(player, args)
	local user_id = vRP.getUserId({player})
	if args[1] and args[1] ~= "" then
		local target_id = parseInt(args[1])
		local target_src = vRP.getUserSource({target_id})
		if target_src then
			local name = vRP.getPlayerName({target_src})
			local ore = vRP.getUserHoursPlayed({target_id})
			TriggerClientEvent("chatMessage", player, "^0[^9KrownRP^0] ID: ^1"..target_id.."^0 Nume: ^1"..name.."^0 Are: ^1"..ore.."^0 ore jucate!")
		else
			TriggerClientEvent("chatMessage", player, "^0[^9KrownRP^0] ^1Jucatorul nu este conectat !")
		end
	else
		TriggerClientEvent("chatMessage", player, "^0[^9KrownRP^0] ^1/ore <id>")
	end
end, false)

RegisterCommand('fix', function(source)
    local user_id = vRP.getUserId({source})
    if vRP.isUserTrialHelper({user_id}) then
        TriggerClientEvent("murtaza:fix", source)
    else
        TriggerClientEvent("chatMessage", source, "Nu ai acces la aceasta comanda sefule.")
    end
end)

RegisterCommand('staff', function(source)
    local user_id = vRP.getUserId({source})
        if vRP.isUserTrialHelper({user_id}) then
        vRPclient.teleport(source,{-1047.1185302734,-235.67240905762,44.021022796631})
        TriggerClientEvent("chatMessage", source, "Te-ai teleportat cu succes la sedinta")
    else 
        TriggerClientEvent("chatMessage", source, "Nu ai acces la aceasta comanda sefule.")
    end
end)