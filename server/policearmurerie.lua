-- esx_PoliceArmory

RegisterServerEvent("esx_policeArmory:weaponTakenOut")
AddEventHandler("esx_policeArmory:weaponTakenOut", function(weapon,giveAmmo)
    local xPlayer = ESX.GetPlayerFromId(source)
    local id = ESX.GetPlayerFromId(source).getIdentifier()
	
    if xPlayer then
    local id = ESX.GetPlayerFromId(source).getIdentifier()
		MySQL.Async.fetchAll("SELECT weapons FROM user_policeArmory WHERE identifier='".. id .."'", {}, function(weapRow)
			local addWeaponToDB
			for k,v in pairs(weapRow) do
				addWeaponToDB = v.weapons
			end
			addWeaponToDB = addWeaponToDB .. weapon .. ", "
			MySQL.Async.execute("UPDATE user_policeArmory SET weapons='".. addWeaponToDB .."' WHERE identifier='".. id .."'", {}, function ()
			end)
		end)
        xPlayer.addWeapon(weapon, Config.AmmountOfAmmo)
		local DATE = os.date("%H:%M (%d.%m.%y)")
		local message = "**" ..GetPlayerName(source).. "** [" ..xPlayer.getIdentifier().. "] **|** has **taken** " .. ESX.GetWeaponLabel(weapon) .. " from the Police Armory **|** " ..DATE
		PerformHttpRequest(""..Config.DiscordWebook.."", function(err, text, headers) end, 'POST', json.encode({username = "Police Armory", content = message}), { ['Content-Type'] = 'application/json' })
		TriggerClientEvent("esx:showNotification", source, "Vous ~y~avez pris~s~ 1x ~r~" .. ESX.GetWeaponLabel(weapon).."~r~")
    end
	
end)

RegisterServerEvent("esx_policeArmory:weaponInStock")
AddEventHandler("esx_policeArmory:weaponInStock", function(weapon,ammo,giveAmmo)
    local xPlayer = ESX.GetPlayerFromId(source)
    local id = ESX.GetPlayerFromId(source).getIdentifier()

    if xPlayer then
        xPlayer.removeWeapon(weapon, ammo)
		MySQL.Async.fetchAll("SELECT weapons FROM user_policeArmory WHERE identifier='".. id .."'", {}, function(weapRow)
			for k,v in pairs(weapRow) do
				removeWeaponFromDB = string.gsub(v.weapons,weapon .. ", ", "")
			end
			MySQL.Async.execute("UPDATE user_policeArmory SET weapons='".. removeWeaponFromDB .."' WHERE identifier='".. id .."'", {}, function ()
			end)
		end)
		local DATE = os.date("%H:%M (%d.%m.%y)")
		local message = "**" ..GetPlayerName(source).. "** [" ..xPlayer.getIdentifier().. "] **|** has **put** " .. ESX.GetWeaponLabel(weapon) .. " back into the Police Armory **|** " ..DATE
		PerformHttpRequest(""..Config.DiscordWebook.."", function(err, text, headers) end, 'POST', json.encode({username = "Police Armory", content = message}), { ['Content-Type'] = 'application/json' })
        TriggerClientEvent("esx:showNotification", source, "Vous ~y~êtes revenu~s~ 1x ~r~" .. ESX.GetWeaponLabel(weapon) .. "~r~")
    end
	
end)

ESX.RegisterServerCallback("esx_policeArmory:getWeaponState", function(source, cb)
    local id = ESX.GetPlayerFromId(source).getIdentifier()
    MySQL.Async.fetchAll('SELECT weapons FROM user_policeArmory WHERE identifier = \"' .. id .. '\"', {}, function(rowsChanged)
        if next(rowsChanged) == nil then
            MySQL.Async.execute("INSERT INTO user_policeArmory (identifier,weapons) VALUES(\"" ..id .. "\",\"\")", {}, function () end)
            cb(nil)
        end
        cb(rowsChanged)
    end)
end)

ESX.RegisterServerCallback("esx_policeArmory:checkPoliceOnline", function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM user_policeArmory', {}, function(rowsChanged)
        local police = {}
        for k,v in pairs(rowsChanged) do
            local xPlayer = ESX.GetPlayerFromIdentifier(v.identifier)
            if xPlayer ~= nil then
                table.insert(police,{id = v.identifier,name = GetPlayerName(source),job = xPlayer.getJob()})
            end
        end
        cb(police)
    end)
end)

RegisterServerEvent("esx_policeArmory:restockWeapons")
AddEventHandler("esx_policeArmory:restockWeapons", function(id)
    MySQL.Async.execute("UPDATE user_policeArmory SET weapons= \"\" WHERE identifier=\"" .. id .. "\"", {}, function ()
    end)
	local xPlayer = ESX.GetPlayerFromId(source)
	local target = ESX.GetPlayerFromIdentifier(id)
	local DATE = os.date("%H:%M (%d.%m.%y)")
	local message = "**" ..GetPlayerName(source).. "** [" ..xPlayer.getIdentifier().. "] **|** a **remis** l'arme pour **" ..target.getName().. "** **|** " ..DATE
	PerformHttpRequest(""..Config.DiscordWebook.."", function(err, text, headers) end, 'POST', json.encode({username = "Police Armory", content = message}), { ['Content-Type'] = 'application/json' })	
end)
