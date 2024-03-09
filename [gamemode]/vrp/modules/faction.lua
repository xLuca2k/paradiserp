local cfg = module("cfg/factions")
local factions = cfg.factions

--[[
	CREATE TABLE IF NOT EXISTS faction_requests(
		id INTEGER AUTO_INCREMENT,
		user_id INTEGER,
		requestedFaction VARCHAR(255),
		description VARCHAR(255),
		playerLevel INTEGER,
		playerName VARCHAR(255),
		date_requested VARCHAR(255),
		date_modified VARCHAR(255),
		ifAccepted INTEGER,
		ifNotAcceptedReason VARCHAR(255),
		PRIMARY KEY(id)
	);
]]

factionMembers = {}
factionRequests = {}

function getFactionMembers()
	for i, v in pairs(factions) do
		Wait(300)
		exports.oxmysql:query("SELECT * FROM vrp_users WHERE faction = @faction", {faction = tostring(i)}, function (rows)
			factionMembers[tostring(i)] = rows
		end)
	end
end

function getFactionRequests()
	local requests = exports.oxmysql:executeSync("SELECT * FROM faction_requests WHERE ifAccepted = 0", {})
	for k,v in pairs (requests) do 
		--factionRequests[v.requestedFaction] = {id = v.id,user_id = v.user_id,requestedFaction = v.requestedFaction,description = v.description,playerLevel = v.playerLevel,date_requested = v.date_requested, date_modified = v.date_modified,ifAccepted = v.ifAccepted,ifNotAcceptedReason = v.ifNotAcceptedReason}
		table.insert(factionRequests,{id = v.id,user_id = v.user_id,requestedFaction = v.requestedFaction,description = v.description,playerLevel = v.playerLevel,playerName = v.playerName,date_requested = v.date_requested, date_modified = v.date_modified,ifAccepted = v.ifAccepted,ifNotAcceptedReason = v.ifNotAcceptedReason})
	end
end

AddEventHandler("onResourceStart", function(rs)
	if(rs == "vrp")then
		Wait(1000)
		getFactionMembers()
		--getFactionRequests() -- requesturile in factiune
	end
end)


function vRP.getFactionColor(faction)
	if factions[faction] ~= nil then 
		return factions[faction].fHexColor or "#FFFFFF"
	else
		return "#FFFFFF"
	end
end

function vRP.getFactionBlip(faction)
    local ngroup = factions[faction]
    if ngroup then
        local fBlip = ngroup.fBlip
        return fBlip
    end
end

function vRP.getFactionCoords(grup)
	return factions[grup].fSpawnPoint
end


function vRP.getFactionRequests(group)
	count = 0
	for k,v in pairs (factionRequests) do
		if v.requestedFaction == group then 
			count = count + 1
		end		
	end
	return count
end

function vRP.getUserFactionRequests(user_id)
	for i, v in pairs(factionRequests) do
		if v.user_id == user_id then 
			return v.requestedFaction
		else
			return nil
		end
		break
	end
end

function vRP.getFactions()
	factionsList = {}
	for i, v in pairs(factions) do
		factionsList[i] = v
	end
	return factionsList
end

function vRP.getUserFaction(user_id)
	local tmp = vRP.getUserDataTable(user_id)
	if tmp then
		theFaction = tmp.fName
		return theFaction
	end
end

function vRP.getFactionRanks(faction)
	local ngroup = factions[faction]
	if ngroup then
		local factionRanks = ngroup.fRanks
		return factionRanks
	end
end

function vRP.getFactionRankSalary(faction, rank)
	local ngroup = factions[faction]
	if ngroup then
		local factionRanks = ngroup.fRanks
		for i, v in pairs(factionRanks) do
			if (v.rank == rank)then
				return v.salary - 1
			end
		end
		return 0
	end
end

function vRP.getFactionSlots(faction)
	local ngroup = factions[faction]
	if ngroup then
		local factionSlots = ngroup.fSlots
		return factionSlots
	end
end

function vRP.getFactionType(faction)
	local ngroup = factions[faction]
	if ngroup then
		local factionType = ngroup.fType
		return tostring(factionType)
	end
end

function vRP.hasUserFaction(user_id)
	local tmp = vRP.getUserDataTable(user_id)
	if tmp then
		theFaction = tmp.fName
		if(theFaction == "user")then
			return false
		else
			return true
		end
	end
end

function vRP.isUserInFaction(user_id,group)
	local tmp = vRP.getUserDataTable(user_id)
	if tmp then
		theFaction = tmp.fName
		if(theFaction == group)then
			return true
		else
			return false
		end
	end
end

function vRP.setFactionLeader(user_id)
	local tmp = vRP.getUserDataTable(user_id)
	if tmp then
		tmp.fLeader = 1
		exports.oxmysql:query("UPDATE vrp_users SET isFactionLeader = @leader WHERE id = @user_id", {['@user_id'] = user_id, ['@leader'] = 1}, function()end)
	end
end

function vRP.setFactionNonLeader(user_id)
	local tmp = vRP.getUserDataTable(user_id)
	if tmp then
		tmp.fLeader = 0
		exports.oxmysql:query("UPDATE vrp_users SET isFactionLeader = @leader WHERE id = @user_id", {['@user_id'] = user_id, ['@leader'] = 0}, function()end)
	end
end

function vRP.setFactionCoLeader(user_id)
	local tmp = vRP.getUserDataTable(user_id)
	if tmp then
		tmp.fCoLeader = 1
		exports.oxmysql:query("UPDATE vrp_users SET isFactionCoLeader = @coleader WHERE id = @user_id", {['@user_id'] = user_id, ['@coleader'] = 1}, function()end)
	end
end

function vRP.setFactionNonCoLeader(user_id)
	local tmp = vRP.getUserDataTable(user_id)
	if tmp then
		tmp.fCoLeader = 0
		exports.oxmysql:query("UPDATE vrp_users SET isFactionCoLeader = @coleader WHERE id = @user_id", {['@user_id'] = user_id, ['@coleader'] = 0}, function()end)
	end
end

function vRP.isFactionLeader(user_id,group)
	local tmp = vRP.getUserDataTable(user_id)
	if tmp then
		theFaction = tmp.fName
		isLeader = tmp.fLeader
		if(theFaction == group) and (isLeader == 1)then
			return true
		else
			return false
		end
	end
end

function vRP.isFactionCoLeader(user_id,group)
	local tmp = vRP.getUserDataTable(user_id)
	if tmp then
		theFaction = tmp.fName
		isCoLeader = tmp.fCoLeader
		if(theFaction == group) and (isCoLeader == 1)then
			return true
		else
			return false
		end
	end
end

function vRP.getFactionRank(user_id)
	local tmp = vRP.getUserDataTable(user_id)
	if tmp then
		theRank = tmp.fRank
		return theRank
	end
end

function vRP.factionRankUp(user_id)
	local theFaction = vRP.getUserFaction(user_id)
	local actualRank = vRP.getFactionRank(user_id)
	local ranks = factions[theFaction].fRanks
	local tmp = vRP.getUserDataTable(user_id)
	local rankName = tmp.fRank
	for i, v in pairs(ranks) do
		rankTitle = v.rank
		if(rankTitle == rankName)then
			if(i == #ranks)then
				return false
			else
				local theRank = tostring(ranks[i+1].rank)
				tmp.fRank = theRank
				exports.oxmysql:query("UPDATE vrp_users SET factionRank = @rank WHERE id = @user_id", {user_id = user_id, rank = theRank}, function()end)
				return true
			end
		end
	end
end

function vRP.factionRankDown(user_id)
	local theFaction = vRP.getUserFaction(user_id)
	local actualRank = vRP.getFactionRank(user_id)
	local ranks = factions[theFaction].fRanks
	local tmp = vRP.getUserDataTable(user_id)
	local rankName = tmp.fRank
	for i, v in pairs(ranks) do
		rankTitle = v.rank
		if(rankTitle == rankName)then
			if(i == 1)then
				return false
			else
				local theRank = tostring(ranks[i-1].rank)
				tmp.fRank = theRank
				exports.oxmysql:query("UPDATE vrp_users SET factionRank = @rank WHERE id = @user_id", {user_id = user_id, rank = tostring(ranks[i-1])}, function()end)
				return true
			end
		end
	end
end

function vRP.addUserFaction(user_id,theGroup)
	local player = vRP.getUserSource(user_id)
	if(player)then
		local ngroup = factions[theGroup]
		if ngroup then
			local factionRank = ngroup.fRanks[1].rank
			local tmp = vRP.getUserDataTable(user_id)
			if tmp then
				tmp.fName = theGroup
				tmp.fRank = factionRank
				tmp.fLeader = 0
				tmp.fCoLeader = 0
				exports.oxmysql:query("UPDATE vrp_users SET faction = @group, factionRank = @rank WHERE id = @user_id", {user_id = user_id, group = theGroup, rank = factionRank}, function()end)
				exports.oxmysql:query("SELECT * FROM vrp_users WHERE id = @user_id", {user_id = user_id}, function (rows)
					thePlayer = rows[1]
					table.insert(factionMembers[theGroup], thePlayer)
				end)
			end
		end
		--[[
		-- cacat de modificare
		if(theGroup == "Politie" or theGroup == "SWAT")then
			TriggerClientEvent('utk_oh:IsCop', player)
			for _, freq in pairs(PolitieJandarmerieFreq) do
				TriggerClientEvent("rp-radio:GivePlayerAccessToFrequency", player, freq)
			end
		else
			TriggerClientEvent('utk_oh:IsNOTCop', player)
		end
		if(theGroup == "Smurd")then
			for _, freq in pairs(SmurdFreq) do
				TriggerClientEvent("rp-radio:GivePlayerAccessToFrequency", player, freq)
			end
		end
		--]]
	end
end

function vRP.getUsersByFaction(group)
	return factionMembers[group] or {}
end

function vRP.getOnlineUsersByFaction(group)
	local oUsers = {}

	for k,v in pairs(vRP.rusers) do
		if vRP.isUserInFaction(tonumber(k), group) then table.insert(oUsers, tonumber(k)) end
	end

	return oUsers
end

-- return number of online members by faction callback
function tvRP.getOnlineUsersByFaction(group)
	local factionUsers = vRP.getOnlineUsersByFaction(group)
	return #factionUsers
end

-- return faction of user callback
function tvRP.getUserFaction()
	local thePlayer = source
	if thePlayer ~= nil then
		local user_id = vRP.getUserId(thePlayer)
		if user_id ~= nil then
			if(vRP.hasUserFaction(user_id))then
				local theFaction = vRP.getUserFaction(user_id)
				return theFaction
			else
				return "Civil"
			end
		end
	end
end

function tvRP.getUserID() return vRP.getUserId(source) end


-- return if is user in a government faction callback
function tvRP.isUserInGovernmentFaction()
	local thePlayer = source
	if thePlayer ~= nil then
		local user_id = vRP.getUserId(source)
		if user_id ~= nil then
			if vRP.isUserInFaction(user_id,"Politie") or vRP.isUserInFaction(user_id,"SWAT") or vRP.isUserInFaction(user_id,"Smurd") then
				return true
			end
		end
	end
end

function vRP.removeUserFaction(user_id,theGroup)
	local player = vRP.getUserSource(user_id)
	if(player)then
		local tmp = vRP.getUserDataTable(user_id)
		if tmp then
			for i, v in pairs(factionMembers[theGroup])do
				if(v.id == user_id)then
					tmp.fName = "user"
					tmp.fRank = 'none'
					tmp.fLeader = 0
					tmp.fCoLeader = 0
					exports.oxmysql:query("UPDATE vrp_users SET faction = @group, factionRank = @rank, isFactionLeader = 0, isFactionCoLeader = 0 WHERE id = @user_id", {user_id = user_id, group = "user", rank = "none"}, function()end)
					table.remove(factionMembers[theGroup], i)
				end
			end
		end

		--[[
		-- cacat de modificare
		if(theGroup == "Politie" or theGroup == "SWAT")then
			TriggerClientEvent('utk_oh:IsCop', player)
			for _, freq in pairs(PolitieJandarmerieFreq) do
				TriggerClientEvent("rp-radio:GivePlayerAccessToFrequency", player, freq)
			end
		else
			TriggerClientEvent('utk_oh:IsNOTCop', player)
		end
		if(theGroup == "Smurd")then
			for _, freq in pairs(SmurdFreq) do
				TriggerClientEvent("rp-radio:GivePlayerAccessToFrequency", player, freq)
			end
		end
		--]]
	else
		for i, v in pairs(factionMembers[theGroup])do
			if(v.id == user_id)then
				table.remove(factionMembers[theGroup], i)
				exports.oxmysql:query("UPDATE vrp_users SET faction = @group, factionRank = @rank, isFactionLeader = 0, isFactionCoLeader = 0 WHERE id = @user_id", {user_id = user_id, group = "user", rank = "none"}, function()end)
			end
		end
	end
end

function vRP.removeFactionFromUserFully(user_id,faction)
	local theFaction = ""
	if faction ~= nil then
		theFaction = tostring(faction)
	else
		theFaction = vRP.getUserFaction(user_id)
	end
	if(theFaction ~= "user")then
		vRP.removeUserFaction(user_id,theFaction)
		if(vRP.hasGroup(user_id,"onduty"))then
			vRP.removeUserGroup(user_id,"onduty")
		end
	end
end

-- FACTION MENU
local function ch_leaveGroup(player,choice)
	local user_id = vRP.getUserId(player)
	local theFaction = vRP.getUserFaction(user_id)
	if user_id ~= nil then
		vRPclient.notify(player,{"~w~Ai parasit factiunea ~r~"..theFaction.."!"})
		vRP.removeFactionFromUserFully(user_id,theFaction)
		vRP.openMainMenu(player)
	end
end

local function ch_offduty(player,choice)
	local user_id = vRP.getUserId(player)
	local theFaction = vRP.getUserFaction(user_id)
	if user_id ~= nil then
		if(vRP.hasUserFaction(user_id))then
			vRPclient.notify(player,{"~w~Te-ai Pus ~r~OFF ~w~Duty In Factiunea ~b~"..theFaction.."!"})
			if(vRP.hasGroup(user_id,"onduty"))then
				vRP.removeUserGroup(user_id,"onduty")
			end
			TriggerClientEvent("chatMessage", -1, "[^5Dunko^0] ^1["..user_id.."] "..vRP.getPlayerName(player).."^0 S-a Pus ^1OFF ^0Duty In Factiunea ^3"..theFaction)
		end
		vRP.openMainMenu(player)
	end
end

local function ch_onduty(player,choice)
	local user_id = vRP.getUserId(player)
	local theFaction = vRP.getUserFaction(user_id)
	if user_id ~= nil then
		if(vRP.hasUserFaction(user_id))then
			vRPclient.notify(player,{"~w~Te-ai Pus ~g~ON ~w~Duty In Factiunea ~b~"..theFaction.."!"})
			vRP.addUserGroup(user_id,"onduty")
			TriggerClientEvent("chatMessage", -1, "[^5Dunko^0] ^1["..user_id.."] "..vRP.getPlayerName(player).."^0 S-a Pus ^2ON ^0Duty In Factiunea ^3"..theFaction)
		end
		vRP.openMainMenu(player)
	end
end

local function ch_inviteFaction(player,choice)
	local user_id = vRP.getUserId(player)
	local theFaction = vRP.getUserFaction(user_id)
	local members = vRP.getUsersByFaction(theFaction)
	local fSlots = factions[theFaction].fSlots
	if user_id ~= nil and vRP.isFactionLeader(user_id,theFaction) or vRP.isFactionCoLeader(user_id,theFaction) then
		vRP.prompt(player,"Jucator ID: ","",function(player,id)
			id = parseInt(id)
			if(tonumber(id)) and (id > 0) and (id ~= "") and (id ~= nil)then
				if(tonumber(#members) < tonumber(fSlots))then
					local target = vRP.getUserSource(id)
					if(target)then
						if(vRP.hasUserFaction(id))then
							vRPclient.notify(player,{"~r~"..vRP.getPlayerName(target).." este deja intr-o factiune!"})
							return
						else
							vRPclient.notify(player,{"~w~L-ai adaugat pe ~g~"..vRP.getPlayerName(target).." ~w~in ~g~"..theFaction.."!"})
							vRPclient.notify(target,{"~w~Ai fost adaugat in ~g~"..theFaction.."!"})
							vRP.addUserFaction(id,theFaction)
							vRP.addUserGroup(id,"onduty")
						end
					else
						vRPclient.notify(player,{"~r~Nu s-a gasit nici un jucator online cu ID-ul "..id.."!"})
					end
				else
					vRPclient.notify(player,{"~r~Maximul de jucatori in factiune a fost atins! Sloturi: "..fSlots})
				end
			else
				vRPclient.notify(player,{"~r~Acest ID este invalid"})
			end
		end)
	end
end

local function ch_excludeFaction(player,choice)
	local user_id = vRP.getUserId(player)
	local theFaction = vRP.getUserFaction(user_id)
	if user_id ~= nil and vRP.isFactionLeader(user_id,theFaction) or vRP.isFactionCoLeader(user_id,theFaction) then
		vRP.prompt(player,"Jucator ID: ","",function(player,id)
			id = parseInt(id)
			if(tonumber(id)) and (id > 0) and (id ~= "") and (id ~= nil)then
				local target = vRP.getUserSource(id)
				if(target)then
					vRPclient.notify(player,{"~w~L-ai scos pe ~g~"..vRP.getPlayerName(target).." ~w~din ~g~"..theFaction.."~w~!"})
					vRPclient.notify(target,{"~w~Ai fost scos din ~g~"..theFaction.."!"})
				else
					vRPclient.notify(player,{"~w~L-ai scos pe ID ~g~"..id.." ~w~din ~g~"..theFaction.."~w~!"})
				end
				vRP.removeFactionFromUserFully(id,theFaction)
			else
				vRPclient.notify(player,{"~r~Acest ID este invalid"})
			end
		end)
	end
end

local function ch_promoteLeader(player,choice)
	local user_id = vRP.getUserId(player)
	local theFaction = vRP.getUserFaction(user_id)
	if user_id ~= nil and vRP.isFactionLeader(user_id,theFaction) then
		vRP.prompt(player,"Jucator ID: ","",function(player,id)
			id = parseInt(id)
			if(tonumber(id)) and (id > 0) and (id ~= "") and (id ~= nil)then
				local target = vRP.getUserSource(id)
				if(target)then
					if(vRP.isUserInFaction(id,theFaction))then
						if(vRP.isFactionLeader(id,theFaction))then
							vRPclient.notify(player,{"~w~L-ai retrogradat pe ~g~"..vRP.getPlayerName(target).." ~w~la ~g~Membru!"})
							vRPclient.notify(target,{"~w~Ai fost retrogradat la ~g~Membru ~w~in factiunea ~g~"..theFaction.."!"})
							vRP.setFactionNonLeader(id)
							Wait(450)
							vRP.openMainMenu(player)
						else
							vRPclient.notify(player,{"~w~L-ai promovat pe ~g~"..vRP.getPlayerName(target).." ~w~la ~g~Lider!"})
							vRPclient.notify(player,{"~w~Functia Lider ti s-a fost scoasa ~g~pentru ca ai dat Liderul Altcuiva!"})
							vRPclient.notify(target,{"~w~Ai fost promovat la ~g~Lider ~w~in factiunea ~g~"..theFaction.."!"})
							vRP.setFactionLeader(id)
							vRP.setFactionNonLeader(user_id)
							Wait(450)
							vRP.openMainMenu(player)
						end
					else
						vRPclient.notify(player,{"~w~Jucatorul ~g~"..vRP.getPlayerName(target).." ~w~nu este membru in factiunea ~g~"..theFaction.."!"})
					end
				else
					vRPclient.notify(player,{"~r~Nu s-a gasit nici un jucator online cu ID-ul "..id.."!"})
				end
			else
				vRPclient.notify(player,{"~r~Acest ID este invalid"})
			end
		end)
	end
end

local function ch_promoteCoLeader(player,choice)
	local user_id = vRP.getUserId(player)
	local theFaction = vRP.getUserFaction(user_id)
	if user_id ~= nil and vRP.isFactionCoLeader(user_id,theFaction) then
		vRP.prompt(player,"Jucator ID: ","",function(player,id)
			id = parseInt(id)
			if(tonumber(id)) and (id > 0) and (id ~= "") and (id ~= nil)then
				local target = vRP.getUserSource(id)
				if(target)then
					if(vRP.isUserInFaction(id,theFaction))then
						if(vRP.isFactionCoLeader(id,theFaction))then
							vRPclient.notify(player,{"~w~L-ai retrogradat pe ~g~"..vRP.getPlayerName(target).." ~w~la ~g~Membru!"})
							vRPclient.notify(target,{"~w~Ai fost retrogradat la ~g~Membru ~w~in factiunea ~g~"..theFaction.."!"})
							vRP.setFactionNonCoLeader(id)
							Wait(450)
							vRP.openMainMenu(player)
						else
							vRPclient.notify(player,{"~w~L-ai promovat pe ~g~"..vRP.getPlayerName(target).." ~w~la ~g~Co-Lider!"})
							vRPclient.notify(player,{"~w~Functia Co-Lider ti s-a fost scoasa ~g~pentru ca ai dat Co-Liderul Altcuiva!"})
							vRPclient.notify(target,{"~w~Ai fost promovat la ~g~Co-Lider ~w~in factiunea ~g~"..theFaction.."!"})
							vRP.setFactionCoLeader(id)
							vRP.setFactionNonCoLeader(user_id)
							Wait(450)
							vRP.openMainMenu(player)
						end
					else
						vRPclient.notify(player,{"~w~Jucatorul ~g~"..vRP.getPlayerName(target).." ~w~nu este membru in factiunea ~g~"..theFaction.."!"})
					end
				else
					vRPclient.notify(player,{"~r~Nu s-a gasit nici un jucator online cu ID-ul "..id.."!"})
				end
			else
				vRPclient.notify(player,{"~r~Acest ID este invalid"})
			end
		end)
	end
end

local function ch_promoteMember(player,choice)
	local user_id = vRP.getUserId(player)
	local theFaction = vRP.getUserFaction(user_id)
	if user_id ~= nil and vRP.isFactionLeader(user_id,theFaction) then
		vRP.prompt(player,"Jucator ID: ","",function(player,id)
			id = parseInt(id)
			if(tonumber(id)) and (id > 0) and (id ~= "") and (id ~= nil)then
				local target = vRP.getUserSource(id)
				if(target)then
					if(vRP.isUserInFaction(id,theFaction))then
						local oldRank = vRP.getFactionRank(id)
						if(vRP.factionRankUp(id))then
							SetTimeout(1000, function()
								local newRank = vRP.getFactionRank(id)
								vRPclient.notify(player,{"~w~L-ai promovat pe ~g~"..vRP.getPlayerName(target).." ~w~ de la ~r~"..oldRank.." ~w~la ~g~"..newRank.."!"})
								vRPclient.notify(target,{"~w~Ai fost promovat de la ~r~"..oldRank.." ~w~la ~g~"..newRank.." ~w~in factiunea ~g~"..theFaction.."!"})
							end)
						else
							vRPclient.notify(player,{"~g~"..vRP.getPlayerName(target).." ~w~are deja cel mai mare rank!"})
						end
					else
						vRPclient.notify(player,{"~w~Jucatorul ~g~"..vRP.getPlayerName(target).." ~w~nu este membru in factiunea ~g~"..theFaction.."!"})
					end
				else
					vRPclient.notify(player,{"~r~Nu s-a gasit nici un jucator online cu ID-ul "..id.."!"})
				end
			else
				vRPclient.notify(player,{"~r~Acest ID este invalid"})
			end
		end)
	end
end

local function ch_demoteMember(player,choice)
	local user_id = vRP.getUserId(player)
	local theFaction = vRP.getUserFaction(user_id)
	if user_id ~= nil and vRP.isFactionLeader(user_id,theFaction) then
		vRP.prompt(player,"Jucator ID: ","",function(player,id)
			id = parseInt(id)
			if(tonumber(id)) and (id > 0) and (id ~= "") and (id ~= nil)then
				local target = vRP.getUserSource(id)
				if(target)then
					if(vRP.isUserInFaction(id,theFaction))then
						local oldRank = vRP.getFactionRank(id)
						if(vRP.factionRankDown(id))then
							SetTimeout(1000, function()
								local newRank = vRP.getFactionRank(id)
								vRPclient.notify(player,{"~w~L-ai retrogradat pe ~g~"..vRP.getPlayerName(target).." ~w~ de la ~r~"..oldRank.." ~w~la ~g~"..newRank.."!"})
								vRPclient.notify(target,{"~w~Ai fost retrogradat la ~r~"..oldRank.." ~w~la ~g~"..newRank.." ~w~in factiunea ~g~"..theFaction.."!"})
							end)
						else
							vRPclient.notify(player,{"~g~"..vRP.getPlayerName(target).." ~w~are deja cel mai mic rank!"})
						end
					else
						vRPclient.notify(player,{"~w~Jucatorul ~g~"..vRP.getPlayerName(target).." ~w~nu este membru in factiunea ~g~"..theFaction.."!"})
					end
				else
					vRPclient.notify(player,{"~r~Nu s-a gasit nici un jucator online cu ID-ul "..id.."!"})
				end
			else
				vRPclient.notify(player,{"~r~Acest ID este invalid"})
			end
		end)
	end
end

local function ch_memberList(player,choice)
	return true
end

local function ch_membersList(player,choice)
	vRP.openMainMenu(player)
	SetTimeout(1000, function()
		vRP.buildMenu("Lista Membrii", {player = player}, function(menu2)
			menu2.name = "Lista Membrii"
			menu2.css={top="75px",header_color="rgba(200,0,0,0.75)"}
			menu2.onclose = function(player) vRP.openMainMenu(player) end
			local user_id = vRP.getUserId(player)
			local theFaction = vRP.getUserFaction(user_id)
			local members = vRP.getUsersByFaction(theFaction)
			for i, v in pairs(members) do
				if(v.isFactionLeader == 1)then
					isMLeader = "Lider"
				elseif(v.isFactionCoLeader == 1)then
					isMLeader = "Co-Lider"
				else
					isMLeader = "Membru"
				end
				local userID = v.id
				local rank = v.factionRank
				local lLogin = v.last_login
				lastLogin = {}
				for lasLogin in lLogin:gmatch("%S+") do
				   table.insert(lastLogin, lasLogin)
				end
				menu2[v.username] = {ch_memberList, "ID: <font color='green'>"..userID.."</font><br/>Rank: <font color='green'>"..rank.."</font><br/>Statut: <font color='green'>"..isMLeader.."</font><br/>Ultima Logare: <font color='red'>"..lastLogin[3].."</font>"}
			end
			vRP.openMenu(player,menu2)
		end)
	end)
end

local function ch_laveFaction(player,choice)
	vRP.request(player,"Doresti sa parasesti factiunea?", 15, function(player,ok)
		if ok then
			local user_id = vRP.getUserId(player)
			local theFaction = vRP.getUserFaction(user_id)
			if user_id ~= nil then
				vRPclient.notify(player,{"[Faction]<br>Ai parasit factiunea ~r~"..theFaction.."!"})
				vRP.removeFactionFromUserFully(user_id,theFaction)
				vRP.closeMenu(player)
			end
		end
	end)
end

local function ch_Off_Duty(player,choice)
	vRP.openMainMenu(player)
	SetTimeout(500, function()
		vRP.buildMenu("Esti sigur?", {player = player}, function(menu1)
			menu1.name = "Esti sigur?"
			menu1.css={top="75px",header_color="rgba(200,0,0,0.75)"}
			menu1.onclose = function(player) vRP.openMainMenu(player) end
			menu1["Da"] = {ch_offduty, "Punete Off Duty"}
			menu1["Nu"] = {function(player) vRP.openMainMenu(player) end}
			vRP.openMenu(player,menu1)
		end)
	end)
end

local function ch_On_Duty(player,choice)
	vRP.openMainMenu(player)
	SetTimeout(500, function()
		vRP.buildMenu("Esti sigur?", {player = player}, function(menu1)
			menu1.name = "Esti sigur?"
			menu1.css={top="75px",header_color="rgba(200,0,0,0.75)"}
			menu1.onclose = function(player) vRP.openMainMenu(player) end
			menu1["Da"] = {ch_onduty, "Punete On Duty"}
			menu1["Nu"] = {function(player) vRP.openMainMenu(player) end}
			vRP.openMenu(player,menu1)
		end)
	end)
end

local function ch_dummySalary(player,choice)
	return false
end

local function ch_ranksAndSalary(player,choice)
	vRP.openMainMenu(player)
	local user_id = vRP.getUserId(player)
	local theFaction = vRP.getUserFaction(user_id)
	local ranks = vRP.getFactionRanks(theFaction)
	SetTimeout(500, function()
		vRP.buildMenu("Rankuri & Salarii", {player = player}, function(rsMenu)
			rsMenu.name = "Rankuri & Salarii"
			rsMenu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
			rsMenu.onclose = function(player) vRP.openMainMenu(player) end
			for i, v in pairs(ranks) do
				facRank = v.rank
				local salary = vRP.getFactionRankSalary(theFaction, facRank)
				rsMenu["["..i.."] "..facRank] = {ch_dummySalary, "Salariu: <font color='green'>$"..salary.."</font>"}
			end
			vRP.openMenu(player,rsMenu)
		end)
	end)
end
local alreadyRequested = {}
local function ch_aplica(player,choice)
	local user_id = vRP.getUserId(player)
	local theFaction = vRP.getUserFaction(user_id)
	local haveRequest = vRP.getUserFactionRequests(user_id)
	if haveRequest == nil then
		if user_id ~= nil then
			if alreadyRequested[user_id] == nil then
				if choice ~= nil then
					alreadyRequested[user_id] = true
					if(theFaction == "user")then
						if #vRP.getUsersByFaction(choice) < vRP.getFactionSlots(choice) then

							text = "Esti sigur ca vrei sa aplici in factiunea "..choice.."? Nu vei mai putea trimite alte cereri in alta factiune pana ce liderul nu iti va accepta/respinge cererea!"
							vRP.request(player,text, 20, function(player,ok)
								alreadyRequested[user_id] = true
								if ok then 
									vRP.closeMenu(player)
									exampleDescription = "EXAMPLE: imi place sa trag cu arma in gabori daca vrei intr-un gang sau imi place sa trag in gangsteri daca vrei in guvernamentale."
									vRP.prompt(player,"De ce vrei sa aplici in aceasta factiune?","EXAMPLE: imi place sa trag cu arma in gabori daca vrei intr-un gang sau imi place sa trag in gangsteri daca vrei in guvernamentale.",function(player,desc) 
										desc = desc or ""
										if desc ~= nil and desc ~= "" and desc ~= exampleDescription then

											local exactDate = os.date('%x').." "..os.date('%X')
											level = 100
											exports.oxmysql:query("INSERT IGNORE INTO faction_requests(user_id,requestedFaction,description,playerLevel,playerName,date_requested,date_modified,ifAccepted,ifNotAcceptedReason) VALUES(@user_id,@requestedFaction,@description,@playerLevel,@playerName,@date_requested,@date_modified,@ifAccepted,@ifNotAcceptedReason)", {
												['@user_id'] = user_id,
												['@requestedFaction'] = choice,
												['@description'] = desc,
												['@playerLevel'] = level, -- get level
												['@playerName'] = GetPlayerName(player), -- get level
												['@date_requested'] = exactDate,
												['@date_modified'] = "FARE MODIFICARE",
												['@ifAccepted'] = 0,
												['@ifNotAcceptedReason'] = "FARA MODIFICARE",
											})
											--INSERT NEW SHIT
											table.insert(factionRequests,{id = #factionRequests+1 ,user_id = user_id,requestedFaction = choice,description = desc,playerLevel = level,playerName = GetPlayerName(player),date_requested = exactDate, date_modified = "FARE MODIFICARE",ifAccepted = 0,ifNotAcceptedReason = "FARE MODIFICARE"})

											vRPclient.notify(player,{"[CERERE IN FACTIUNE] Ai trimis o cerere de intrare in factiune catre factiunea "..choice.." cu succes"})
										else
											vRPclient.notify(player,{"[CERERE IN FACTIUNE] Trebuie sa pui un mesaj!"})
										end
									end)
									alreadyRequested[user_id] = nil
								else
									vRPclient.notify(player,{"[CERERE IN FACTIUNE] Ai refuzat sa mai aplici in factiunea "..choice.."!"})
									alreadyRequested[user_id] = nil
								end

							end)

						else
							vRPclient.notify(player,{"[CERERE IN FACTIUNE] Nu mai sunt locuri in aceasta factiune!"})
						end
					else
						vRPclient.notify(player,{"[CERERE IN FACTIUNE] Esti deja intr-o factiune, nu poti aplica in alta"})
					end
				end
			else
				vRPclient.notify(player,{"[CERERE IN FACTIUNE] Accepta sau respinge requestul daca esti sigur ca vrei sa aplici in aceasta factiune!"})
			end
		end
	else
		vRPclient.notify(player,{"[CERERE IN FACTIUNE] Ai deja o cerere facuta pentru factiunea "..haveRequest})
	end
end

local alreadyRequestedForAccOrRespingere = {}
function ch_acceptaSauRespinge(player,id)
	local user_id = vRP.getUserId(player)
	if alreadyRequestedForAccOrRespingere[user_id] == nil then
		alreadyRequestedForAccOrRespingere[user_id] = true
		text = "Doresti sa-l accepti pe "..factionRequests[id].playerName.." in factiune?<br><br> APASAND PE <span style = 'color:#48d422;'>[Y]</span> IL VEI ACCEPTA IN FACTIUNE!<br> APASAND PE <span style = 'color:rgb(199, 0, 57 );'>[N]</span> II VEI RESPINGE CEREREA!"
		vRP.request(player,text, 20, function(player,ok)
			if ok then

				doublerequesttext = "Ai selectat <span style = 'color:#48d422;'>[ ACCEPTAREA ]</span> jucatorului, esti sigur?"
				vRP.request(player,doublerequesttext, 20, function(player,ok)
					if ok then
						vRPclient.notify(player,{factionRequests[id].playerName.." a fost acceptat in factiune."})
						vRP.closeMenu(player)
						alreadyRequestedForAccOrRespingere[user_id] = nil
						factionRequests[id] = nil -- stergere request din table, paaaaaaaa
						-- TODO
						-- VERIFICARE DACA E ONLINE
						-- DACA NU-I ONLINE, O MUIE OFFLINE SI UPDATE LA TABLE IN SQL VRP_USERS
						-- UPDATE TABLE FACTION_REQUESTS
					else
						vRPclient.notify(player,{"Ai anulat acceptarea jucatorului "..factionRequests[id].playerName})
						alreadyRequestedForAccOrRespingere[user_id] = nil
					end
				end)

			else

				doublerequesttext = "Ai selectat <span style = 'color:rgb(199, 0, 57 );'>[ RESPINGEREA ]</span> jucatorului, esti sigur?"
				vRP.request(player,doublerequesttext, 20, function(player,ok)
					if ok then
						vRPclient.notify(player,{"Ai anulat cererea in factiune a jucatorului "..factionRequests[id].playerName})
						vRP.closeMenu(player)
						alreadyRequestedForAccOrRespingere[user_id] = nil
						factionRequests[id] = nil -- stergere request din table, paaaaaaaa
						-- TODO
						-- VERIFICARE DACA E ONLINE
						-- DACA NU-I ONLINE, O MUIE OFFLINE SI UPDATE LA TABLE IN SQL VRP_USERS
						-- UPDATE TABLE FACTION_REQUESTS

					else
						vRPclient.notify(player,{"Ai anulat respingerea jucatorului "..factionRequests[id].playerName})
						alreadyRequestedForAccOrRespingere[user_id] = nil
					end
				end)

			end
		end)

	else
		vRPclient.notify(player,{"[CERERE IN FACTIUNE] Accepta sau respinge requestul daca vrei sa il accepti sau respinge pe jucator!"})
	end
end

local function ch_verificaCererile(player,choice)
	local user_id = vRP.getUserId(player)
	local theFaction = vRP.getUserFaction(user_id)


	vRP.buildMenu("Cereri In Factiune", {player = player}, function(reqMenu)
		reqMenu.name = "Cereri In Factiune"
		reqMenu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
		reqMenu.onclose = function(player) vRP.closeMenu(player) end
		for k, v in pairs(factionRequests) do
			reqMenu[v.playerName.." ["..v.user_id.."]"] = {function(player,choice) ch_acceptaSauRespinge(player, k) end, "Request-ID: "..v.id.."<br>Player-ID: "..v.user_id.."<br>Player-Name: "..v.playerName.."<br>Data Cererii: "..v.date_requested.."<br>Player-Level: "..v.playerLevel.."<br><center style = '	color: rgb(53, 114, 255);'>"}
		end
		vRP.openMenu(player,reqMenu)
	end)
end


vRP.registerMenuBuilder("main", function(add, data)
	local user_id = vRP.getUserId(data.player)
	if user_id ~= nil then
		local choices = {}
		local tmp = vRP.getUserDataTable(user_id)
		if tmp then
			if(vRP.hasUserFaction(user_id))then
				local theFaction = vRP.getUserFaction(user_id)
				local rank = vRP.getFactionRank(user_id)
				local leader = vRP.isFactionLeader(user_id,theFaction)
				local coleader = vRP.isFactionCoLeader(user_id,theFaction)
				local members = vRP.getUsersByFaction(theFaction)
				local fType = vRP.getFactionType(theFaction)
				local fSlots = vRP.getFactionSlots(theFaction)
				local salary = vRP.getFactionRankSalary(theFaction, rank) or 0
				if(leader)then
					isLeader = "Lider"
				elseif(coleader)then
					isLeader = "Co-Lider"
				else
					isLeader = "Membru"
				end
				if(vRP.hasGroup(user_id,"onduty"))then
					Duty = "ON"
				else
					Duty = "OFF"
				end
				if(salary > 0)then
					if(#members == fSlots)then
						infoText = "Nume: <font color='red'>"..theFaction.."</font><br/>Membrii: <font color='red'>"..#members.."</font>/<font color='red'>"..fSlots.."</font><br/>Tip: <font color='green'>"..fType.."</font><br/>Rank: <font color='green'>"..rank.."</font><br/>Duty: <font color='green'>"..Duty.."</font><br/>Salariu: <font color='yellow'>$"..salary.."</font><br/>Statut: <font color='green'>"..isLeader.."</font>"
					else
						infoText = "Nume: <font color='red'>"..theFaction.."</font><br/>Membrii: <font color='green'>"..#members.."</font>/<font color='red'>"..fSlots.."</font><br/>Tip: <font color='green'>"..fType.."</font><br/>Rank: <font color='green'>"..rank.."</font><br/>Duty: <font color='green'>"..Duty.."</font><br/>Salariu: <font color='yellow'>$"..salary.."</font><br/>Statut: <font color='green'>"..isLeader.."</font>"
					end
				else
					if(#members == fSlots)then
						infoText = "Nume: <font color='red'>"..theFaction.."</font><br/>Membrii: <font color='red'>"..#members.."</font>/<font color='red'>"..fSlots.."</font><br/>Tip: <font color='green'>"..fType.."</font><br/>Rank: <font color='green'>"..rank.."</font><br/>Statut: <font color='green'>"..isLeader.."</font>"
					else
						infoText = "Nume: <font color='red'>"..theFaction.."</font><br/>Membrii: <font color='green'>"..#members.."</font>/<font color='red'>"..fSlots.."</font><br/>Tip: <font color='green'>"..fType.."</font><br/>Rank: <font color='green'>"..rank.."</font><br/>Statut: <font color='green'>"..isLeader.."</font>"	
					end
				end
				choices["Meniu Factiune"] = {function(player,choice)
					vRP.buildMenu(theFaction, {player = player}, function(menu)
						menu.name = theFaction
						menu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
						menu.onclose = function(player) vRP.closeMenu(player) end -- nest menu
						if (leader) then 
							menu["#Verifica Cerererile"] = {ch_verificaCererile, "Ai "..vRP.getFactionRequests(theFaction).." cereri in asteptare."}
						end
						if(leader or coleader)then
							menu["Invita Membru"] = {ch_inviteFaction, "Invita membru in factiune"}
							menu["Exclude Membru"] = {ch_excludeFaction, "Exclude membru din factiune"}
						end
						if(leader)then
							menu["Promoveaza Lider"] = {ch_promoteLeader, "Promoveaza/Retrogradeaza membru la Lider/Membru"}
							menu["Promoveaza Membru"] = {ch_promoteMember, "Promoveaza membru la un rank mai mare"}
							menu["Retrogradeaza Membru"] = {ch_demoteMember, "Retrogradeaza membru la un rank mai mic"}
						end
						if(coleader)then
							menu["Promoveaza Co-Lider"] = {ch_promoteCoLeader, "Promoveaza/Retrogradeaza membru la Co-Lider/Membru"}
						end
						if(fType == "Lege")then
							if(vRP.hasGroup(user_id,"onduty"))then
								menu["Punete Off Duty"] = {ch_Off_Duty, "Punete Off Duty In Factiunea "..theFaction}
							else
								menu["Punete On Duty"] = {ch_On_Duty, "Punete On Duty In Factiunea "..theFaction}
							end
						end
						menu["Lista Membrii"] = {ch_membersList, "Lista membrii "..theFaction}
						menu["Rankuri & Salarii"] = {ch_ranksAndSalary, "Rankuri si Salarii"}
						menu["Paraseste Factiunea"] = {ch_laveFaction, "Paraseste factiunea "..theFaction}
						vRP.openMenu(player,menu)
					end)
				end, infoText}
			else
				-- choices["Aplica intr-o factiune"] = {function(player,choice)
				-- 	vRP.buildMenu(theFaction, {player = player}, function(menu)
				-- 		menu.name = "Factiuni"
				-- 		menu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
				-- 		menu.onclose = function(player) vRP.closeMenu(player) end -- nest menu
				-- 		factiuni = vRP.getFactions()
				-- 		for factiune,v in pairs (factiuni) do
				-- 			menu[factiune] = {ch_aplica,
				-- 			[[
				-- 				<center> <font  size="4" color="]]..v.fHexColor..[[" >]]..v.fIcon..[[</font><br>
				-- 					Factiune: ]]..factiune..[[<br>
				-- 					Sloturi: ]]..#vRP.getUsersByFaction(factiune)..[[/]]..vRP.getFactionSlots(factiune)..[[<br>
				-- 					Level minim : ]]..v.fMinLevel..[[
				-- 				</center>
				-- 				<center> <font size="4" color="#3572FF"><i class="fas fa-lightbulb-exclamation"></i></font><br>
				-- 					Apasa <font color="#3572FF">[ENTER]</font> pentru a face o cerere in <font color="]]..v.fHexColor..[[" >]]..factiune..[[</font>. O sa primesti o notificare dupa ce liderul va vedea cererea ta!
				-- 				</center>
				-- 			]]}
				-- 		end
				-- 		vRP.openMenu(player,menu)
				-- 	end)
				-- end, "Nu esti intr-o factiune<br>Aplica aici intr-o factiune"}
			end
		end
		add(choices)
	end
end)

AddEventHandler("vRP:playerJoin",function(user_id,source,name,last_login)
	local tmp = vRP.getUserDataTable(user_id)
	if tmp then
		local rows = exports['oxmysql']:executeSync("SELECT faction, isFactionLeader, isFactionCoLeader, factionRank FROM vrp_users WHERE id = @user_id", {user_id = user_id})
		theFaction = tostring(rows[1].faction)
		isLeader = tonumber(rows[1].isFactionLeader)
		isCoLeader = tonumber(rows[1].isFactionCoLeader)
		factionRank = tostring(rows[1].factionRank)
		tmp.fName = theFaction
		tmp.fRank = factionRank
		tmp.fLeader = isLeader
		tmp.fCoLeader = isCoLeader
	end
end)



local function ch_addfaction(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRP.prompt(player,"Jucator ID: ","",function(player,id)
			id = parseInt(id)
			if(tonumber(id)) and (id > 0) and (id ~= "") and (id ~= nil)then
				local theTarget = vRP.getUserSource(id)
				if(theTarget)then
					vRP.prompt(player,"Factiune: ","",function(player,group)
						group = tostring(group)
						if(group ~= "") and (group ~= nil)then
							vRP.prompt(player,"Lider(1), Co-Lider(2), Membru(0): ","",function(player,lider)
								lider = parseInt(lider)
								if(tonumber(lider)) and (lider == 0 or lider == 1 or lider == 2) and (lider ~= "") and (lider ~= nil)then
									if(lider == 1) then
										vRP.addUserFaction(id,group)
										vRP.addUserGroup(id,"onduty")
										Citizen.Wait(500)
										vRP.setFactionLeader(id)
										vRPclient.notify(player,{"Jucatorul "..vRP.getPlayerName(theTarget).." a fost adaugat ca Lider in factiunea "..group})
									elseif(lider == 2) then
										vRP.addUserFaction(id,group)
										vRP.addUserGroup(id,"onduty")
										Citizen.Wait(500)
										vRP.setFactionCoLeader(id)
										vRPclient.notify(player,{"Jucatorul "..vRP.getPlayerName(theTarget).." a fost adaugat ca Co-Lider in factiunea "..group})
									else
										vRP.addUserFaction(id,group)
										vRP.addUserGroup(id,"onduty")
										vRPclient.notify(player,{"Jucatorul "..vRP.getPlayerName(theTarget).." a fost adaugat in factiunea "..group})
									end
								else
									vRPclient.notify(player,{"~r~Trebuie sa pui 1 sau 0 pentru a alege daca este Lider sau Nu!"})
								end
							end)
						else
							vRPclient.notify(player,{"~r~Factiunea pe care ai pus-o este invalida!"})
						end
					end)
				else
					vRPclient.notify(player,{"~r~Nu s-a gasit nici un jucator online cu ID-ul "..id.."!"})
				end
			else
				vRPclient.notify(player,{"~r~Acest ID este invalid"})
			end
		end)
	end
end

local function ch_removefaction(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRP.prompt(player,"Jucator ID: ","",function(player,id)
			id = parseInt(id)
			if(tonumber(id)) and (id > 0) and (id ~= "") and (id ~= nil)then
				local theTarget = vRP.getUserSource(id)
				if(theTarget)then
					local theFaction = vRP.getUserFaction(id)
					if(theFaction == "user")then
						vRPclient.notify(player,{"Jucatorul cu ID-ul "..id.." nu este intr-o factiune"})
					else
						vRP.removeFactionFromUserFully(id,theFaction)
						vRPclient.notify(player,{theFaction.." scos lui "..vRP.getPlayerName(theTarget)})
					end
				else
					local rows = exports['oxmysql']:executeSync("SELECT * FROM vrp_users WHERE id = @user_id", {user_id = id})
					if #rows > 0 then
						local faction = rows[1].faction
						if faction ~= "user" then
							vRP.removeFactionFromUserFully(id,faction)
							vRPclient.notify(player,{faction.." scos lui ID "..id})
						end
					end
				end
			else
				vRPclient.notify(player,{"~r~Acest ID este invalid"})
			end
		end)
	end
end

local function ch_factionleader(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRP.prompt(player,"Jucator ID: ","",function(player,id)
			id = parseInt(id)
			if(tonumber(id)) and (id > 0) and (id ~= "") and (id ~= nil)then
				local theTarget = vRP.getUserSource(id)
				if(theTarget)then
					vRP.prompt(player,"Lider(1), Co-Lider(2): ","",function(player,lider)
						lider = parseInt(lider)
						if(tonumber(lider)) and (lider == 1 or lider == 2) and (lider ~= "") and (lider ~= nil)then
							local theFaction = vRP.getUserFaction(id)
							if(theFaction == "user")then
								vRPclient.notify(player,{vRP.getPlayerName(theTarget).." nu este in nici o factiune!"})
							else
								if(lider == 1) then
									vRP.setFactionLeader(id)
									vRPclient.notify(player,{vRP.getPlayerName(theTarget).." a fost adaugat ca Lider in factiunea "..theFaction})
								else
									vRP.setFactionCoLeader(id)
									vRPclient.notify(player,{vRP.getPlayerName(theTarget).." a fost adaugat ca, CoLider in factiunea "..theFaction})
								end
							end
						else
							vRPclient.notify(player,{"~r~Trebuie sa pui 1 sau 0 pentru a alege daca este Lider/Co-Lider sau Nu!"})
						end
					end)
				else
					vRPclient.notify(player,{"~r~Nu s-a gasit nici un jucator online cu ID-ul "..id.."!"})
				end
			else
				vRPclient.notify(player,{"~r~Acest ID este invalid"})
			end
		end)
	end
end

vRP.registerMenuBuilder("admin", function(add, data)
	local user_id = vRP.getUserId(data.player)
	if user_id ~= nil then
		local choices = {}
		if vRP.isUserHeadofStaff(user_id) then
			choices["Add Faction Co/Leader"] = {ch_factionleader, ""}
		end
		if vRP.isUserAdministrator(user_id) then
			choices["Add Faction"] = {ch_addfaction, ""}
			choices["Remove Faction"] = {ch_removefaction, ""}
		end
		add(choices)
	end
end)



function vRP.getFactionBlip(faction) 
	local ngroup = factions[faction]
	if ngroup then 
		return ngroup.fBlip
	end
end


function vRP.getFactionFeedColor(faction) 
	local ngroup = factions[faction]
	if ngroup then 
		return ngroup.feedColor
	end
end

function vRP.getFactionColor(faction) 
	local ngroup = factions[faction]
	if ngroup then 
		return ngroup.fColor
	end
end


--function vRP.getFactionCoords(faction)
--	local ngroup = factions[faction]
--	if ngroup then 
--		return ngroup.coords
--	end
--end

function vRP.getFactionWeapons(faction)
	local key = factions[faction]
	if key then 
		return key.fWeapons or {}
	end
end
