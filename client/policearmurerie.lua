-- esx_PoliceArmory

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end 
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)
-- Function for 3D text:
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

local insideMarker = false

-- Core Thread Function:
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local coords = GetEntityCoords(PlayerPedId())
		
		if (ESX.PlayerData.job and ESX.PlayerData.job.name == Config.PoliceDatabaseName) then
		for k,v in pairs(Config.ArmoryZones) do
			for i = 1, #v.Pos, 1 do
				local distance = Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
				if (distance < 7.0) and insideMarker == false then
					DrawMarker(Config.ArmoryMarker, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z-0.975, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.ArmoryMarkerScale.x, Config.ArmoryMarkerScale.y, Config.ArmoryMarkerScale.z, Config.ArmoryMarkerColor.r,Config.ArmoryMarkerColor.g,Config.ArmoryMarkerColor.b,Config.ArmoryMarkerColor.a, false, true, 2, true, false, false, false)						
				end
				if (distance < 1.0) and insideMarker == false then
					DrawText3Ds(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, Config.ArmoryDraw3DText)
					if IsControlJustPressed(0, Config.KeyToOpenArmory) then
						ESX.TriggerServerCallback('esx_policeArmory:getWeaponState', function(stock) end)
						PoliceArmory()
						insideMarker = true
						Citizen.Wait(500)
					end
				end
			end
		end

		for k,v in pairs(Config.KevlarZones) do
			for i = 1, #v.Pos, 1 do
				local distance = Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
				if (distance < 7.0) and insideMarker == false then
				DrawMarker(Config.KevlarMarker, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z-0.975, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.KevlarMarkerScale.x, Config.KevlarMarkerScale.y, Config.KevlarMarkerScale.z, Config.KevlarMarkerColor.r,Config.KevlarMarkerColor.g,Config.KevlarMarkerColor.b,Config.KevlarMarkerColor.a, false, true, 2, true, false, false, false)						
				end
				if (distance < 1.0 ) and insideMarker == false then
					DrawText3Ds(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, Config.KevlarDraw3DText)
					if IsControlJustPressed(0, Config.KeyToOpenKevlar) then
						KevlarMenu()
						insideMarker = true
						Citizen.Wait(500)
					end
				end
			end
		end

		end
		
	end
end)

-- Function for Weapon Armory:
PoliceArmory = function()
	local elements = {
		{ label = Config.WeaponStorage, action = "weapon_menu" },
	}
	
	if not IsEntityPlayingAnim(GetPlayerPed(-1), 'mini@repair', 'fixing_a_player', 3) then
        ESX.Streaming.RequestAnimDict('mini@repair', function()
            TaskPlayAnim(GetPlayerPed(-1), 'mini@repair', 'fixing_a_player', 8.0, -8, -1, 49, 0, 0, 0, 0)
        end)
    end
	
	if tonumber(ESX.PlayerData.job.grade) >= Config.RestockGrade then
		table.insert(elements, {label = Config.RestockWeapon, action = "restock_menu"})
	end
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "esx_policeArmory_main_menu",
		{
			title    = Config.PoliceArmoryTitle,
			align    = "top-left",
			elements = elements
		},
	function(data, menu)
		local action = data.current.action

		if action == "weapon_menu" then
			WeaponMenu()
		elseif action == "restock_menu" then
			RestockMenu()
		end	
	end, function(data, menu)
		menu.close()
		insideMarker = false
		ClearPedSecondaryTask(GetPlayerPed(-1))
	end, function(data, menu)
	end)
end

-- Function for splitting string:
function WeapSplit(inputstr, del)
    if del == nil then
            del = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..del.."]+)") do
            table.insert(t, str)
    end
    return t
end

-- Function to check if player has weapon:
function PedHasWeapon(hash)
	for k,v in pairs(ESX.GetPlayerData().loadout) do
		if v.name == hash then
			return true
		end
	end
	return false
end

-- Function for Weapon Menu:
WeaponMenu = function()
	local storage = nil
	local elements = {}
	local ped = GetPlayerPed(-1)
	ESX.TriggerServerCallback("esx_policeArmory:getWeaponState", function(stock)	
	local weapons = WeapSplit(stock[1].weapons, ", ")
	
	for k,v in pairs(Config.WeaponsInArmory) do
		local takenOut = false
		for z,x in pairs(weapons) do
			if x == v.weaponHash then
				takenOut = true
				table.insert(elements,{label = v.label .. " --- "..('<span style="color:red;">%s</span>'):format("Taken out"), weaponhash = v.weaponHash, lendable = false})
			end
		end
		if takenOut == false then
			table.insert(elements,{label = v.label .. " --- "..('<span style="color:green;">%s</span>'):format("In Stock"), weaponhash = v.weaponHash, lendable = true})
		end
	end
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "esx_policeArmory_weapon_storage",
		{
			title    = Config.WeaponStorageTitle,
			align    = "top-left",
			elements = elements
		},
	function(data, menu)
		menu.close()
		
		if data.current.lendable == true then
			local giveAmmo = (GetWeaponClipSize(GetHashKey(data.current.weaponhash)) > 0)
			if data.current.weaponhash == "WEAPON_STUNGUN" then
				giveAmmo = false
			end
			TriggerServerEvent("esx_policeArmory:weaponTakenOut", data.current.weaponhash, giveAmmo)
		elseif PedHasWeapon(data.current.weaponhash) then
			local giveAmmo = (GetWeaponClipSize(GetHashKey(data.current.weaponhash)) > 0)
			if data.current.weaponhash == "WEAPON_STUNGUN" then
				giveAmmo = false
			end
			TriggerServerEvent("esx_policeArmory:weaponInStock", data.current.weaponhash,GetAmmoInPedWeapon(ped,GetHashKey(data.current.weaponhash)),giveAmmo)
		else
			ESX.ShowNotification(Config.ContactSuperVisor)
		end
		
	end, function(data, menu)
		menu.close()
	end, function(data, menu)
	end)
	end)
end

-- Function for Restock Menu:
function RestockMenu()
	local police = {}
	local elements = {}
	ESX.TriggerServerCallback("esx_policeArmory:checkPoliceOnline", function(list) police = list end)
	Citizen.Wait(250)
	for k,v in pairs(police) do
		if v.job.name == Config.PoliceDatabaseName then
			table.insert(elements, {label = v.name, id = v.id})
		end
	end
	if next(elements) ~= nil then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), "esx_policeArmory_restock_menu",
			{
				title    = Config.RestockWeaponTitle,
				align    = "top-left",
				elements = elements
			},
		function(data, menu)
			menu.close()
			exports['progressBars']:startUI((Config.RestockTimer * 1000), Config.Progress1)
			Citizen.Wait((Config.RestockTimer * 1000))
			TriggerServerEvent("esx_policeArmory:restockWeapons",data.current.id)
		end, function(data, menu)
			
			menu.close()
		end, function(data, menu)
		end)
	else
		ESX.ShowNotification(Config.NoPoliceOnline)
	end
end

-- Function for Kevlar Menu:
function KevlarMenu()
	local ped = GetPlayerPed(-1)
	local elements = {}
	
	if not IsEntityPlayingAnim(GetPlayerPed(-1), 'mini@repair', 'fixing_a_player', 3) then
        ESX.Streaming.RequestAnimDict('mini@repair', function()
            TaskPlayAnim(GetPlayerPed(-1), 'mini@repair', 'fixing_a_player', 8.0, -8, -1, 49, 0, 0, 0, 0)
        end)
    end
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "esx_policeArmory_kevlar_menu",
			{
				title    = Config.PoliceKevlarTitle,
				align    = "top-left",
				elements = {
					--{label = Config.Vest1, armor = 25},
					--{label = Config.Vest2, armor = 50},
					--{label = Config.Vest3, armor = 75},
					{label = Config.Vest4, armor = 100},
					{label = Config.RemoveVest, armor = 0},
			}
			},
		function(data, menu)
			SetPedArmour(ped,data.current.armor)
			if data.current.armor == 0 then
				exports['progressBars']:startUI((Config.RemoveVestTimer * 1000), Config.Progress2)
				Citizen.Wait((Config.RemoveVestTimer * 1000))
				SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 0)
			else
				exports['progressBars']:startUI((Config.WearVestTimer * 1000), Config.Progress3)
				Citizen.Wait((Config.RemoveVestTimer * 1000))
				if data.current.armor == 25 then
					SetPedComponentVariation(ped, Config.VestVariation1.componentId, Config.VestVariation1.drawableId, Config.VestVariation1.textureId, Config.VestVariation1.paletteId)
				elseif data.current.armor == 50 then
					SetPedComponentVariation(ped, Config.VestVariation2.componentId, Config.VestVariation2.drawableId, Config.VestVariation2.textureId, Config.VestVariation2.paletteId)
				elseif data.current.armor == 75 then
					SetPedComponentVariation(ped, Config.VestVariation3.componentId, Config.VestVariation3.drawableId, Config.VestVariation3.textureId, Config.VestVariation3.paletteId)
				elseif data.current.armor == 100 then
					SetPedComponentVariation(ped, Config.VestVariation4.componentId, Config.VestVariation4.drawableId, Config.VestVariation4.textureId, Config.VestVariation4.paletteId)
				end
			end
						
			menu.close()
			insideMarker = false
			ClearPedSecondaryTask(GetPlayerPed(-1))
		end, function(data, menu)
			menu.close()
			insideMarker = false
			ClearPedSecondaryTask(GetPlayerPed(-1))
		end, function(data, menu)
		end)
end