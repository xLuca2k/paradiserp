vRP.registerMenuBuilder("main", function(add, data)
	local user_id = vRP.getUserId(data.player)
	if user_id   then
		local choices = {}
	
		if(vRP.hasGroup(user_id, "youtuber"))then
			choices["🎬 YouTuber Menu"] = {function(player,choice)
				vRP.buildMenu("ytmenu", {player = player}, function(menu)
					menu.name = "YouTuber Menu"
					menu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
					menu.onclose = function(player) vRP.closeMenu(player) end
					menu["💉 Revive"] = {function(player, choice)
						vRPclient.isInComa(player,{}, function(in_coma)
							if in_coma then
								vRPclient.varyHealth(player,{100}) 
								SetTimeout(1000, function()
									vRPclient.varyHealth(player,{100})
								end)
								vRPclient.notify(player,{"Succes: ~w~Ti-ai dat revive!"})
								TriggerClientEvent("chatMessage",-1,"^1"..GetPlayerName(player).." ^0a folosit revive din ^1Youtuber Menu")
								local embed = {
									{
										["color"] = "15158332",
										["type"] = "rich",
										["title"] = "Revive Youtuber",
										["description"] = "**Youtuber: ** "..GetPlayerName(player).." a folosit revive din youtuber menu",
									}
								  }
								
								PerformHttpRequest('https://discord.com/api/webhooks/923556757387771974/TGZ5ZG8kE5cQR74SNN4blTPHFCfM90KSgB8-kfSprc4mIE2IMc-Yn0BbLk49cAckvmVL', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' }) 
							else
								vRPclient.notify(player,{"Eroare: ~w~Nu esti mort"})
							end
						end)
					end, "Da-ti revive"}
					
					menu["🔧 Fix Masina"] = {function(player, choice)
						vRPclient.fixeNearestVehicle(player,{7})
						vRPclient.notify(player, {"Succes: ~w~Ai reparat vehiculul!"})
						TriggerClientEvent("chatMessage",-1,"^1"..GetPlayerName(player).." ^0a folosit fix din ^1Youtuber Menu")
						local embed = {
							{
								["color"] = "15158332",
								["type"] = "rich",
								["title"] = "Fix Youtuber",
								["description"] = "**Youtuber: ** "..GetPlayerName(player).." a folosit fix masina",
							}
						  }
						
						PerformHttpRequest('https://discord.com/api/webhooks/923556638516998194/_-jwPXNQ2IdeI4YZ04GIQP1fgrTF0W18hERjgpa0sXQJ9Qg0mf6ol2HE8ATyQ2-O9FIn', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' }) 
					end, "Repara vehiculul in care te afli"}
					
					menu["🔫 Kit Arme"] = {function(player, choice)
						vRPclient.giveWeapons(player,{{
							["WEAPON_MACHETE"] = {ammo=1},
							["WEAPON_COMBATMG"] = {ammo=200},
							["WEAPON_ASSAULTRIFLE"] = {ammo=200},
							["WEAPON_PISTOL50"] = {ammo=200},
							["WEAPON_STUNGUN"] = {ammo=1},
						}})
						vRPclient.notify(player, {"Succes: ~w~Ti-ai dat un kit de arme!"})
						TriggerClientEvent("chatMessage",-1,"^1"..GetPlayerName(player).." ^0a folosit kit arme din ^1Youtuber Menu")
						local embed = {
							{
								["color"] = "15158332",
								["type"] = "rich",
								["title"] = "Kit Arme",
								["description"] = "**Youtuber: ** "..GetPlayerName(player).." a folosit kit arme",
							}
						  }
						
						PerformHttpRequest('https://discord.com/api/webhooks/923556508657143808/VxToe6HZp0W55ze9za3KB3USoaAoM6k7f8-YJLObShDM9j9BnFn2hT_qt6mHbZA4kG4I', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' }) 
					end, "Da-ti un kit de arme"}
					vRP.openMenu(player,menu)
				end)
			end}
		end
		add(choices)
	end
end)