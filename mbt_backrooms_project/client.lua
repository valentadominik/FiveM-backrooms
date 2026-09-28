local isFalling, veh = false, false
local playerCoords, playerPed, playerPed
local isNear = false
local nearestLocation

RegisterNetEvent('mbt:sendToBackrooms')
AddEventHandler('mbt:sendToBackrooms', function()
    local playerPed = PlayerPedId()
	ExecuteCommand('me Zakopl')

    SetPedToRagdoll(playerPed, 1500, 1500, 0, 0, 0, 0)
    Citizen.Wait(500) 

    
    ClearPedTasksImmediately(playerPed)
    local randomBackroom = MBT.Coords[math.random(1, #MBT.Coords)]

    teleportPlayer({
        playerPed = playerPed,
        randomBackroom = randomBackroom
    })
end)


Citizen.CreateThread(function()
	local currentLocation

	RegisterCommand('handleBackroomAction', function()
		if not isNear then return end
		if nearestLocation.Type == "Exit" then
			local playerPed = PlayerPedId()
			 
			math.randomseed(GetGameTimer()*math.random(30568, 90214))
			local randomChance = math.random(1, 100)
			print("randomChance: ", randomChance)
			if randomChance < 70 then
				local randomBackroom = MBT.Coords[math.random(1, #MBT.Coords)]
				teleportPlayer({
					playerPed = playerPed,
					randomBackroom = randomBackroom
				})
			else
				local randomExitPoint = MBT.RandomExitPoint[math.random(1, #MBT.RandomExitPoint)]
				teleportPlayer({
					playerPed = playerPed,
					randomBackroom = randomExitPoint
				})
			end
		elseif nearestLocation.Type == "Enter" then 
			local randomBackroom = MBT.Coords[math.random(1, #MBT.Coords)]
			teleportPlayer({
				playerPed = playerPed,
				randomBackroom = randomBackroom
			})
		end
	end, true)

	while true do
		sleep = 500
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		isNear = false

		for i=1, #MBT.BackRooms do
			currentLocation = MBT.BackRooms[i]
			if not isNear then
				local distance = #(playerCoords - currentLocation.Coords)
				-- print("distance is ", distance)
				isNear = true
				nearestLocation = currentLocation
				if distance > nearestLocation.Range then isNear = false; nearestLocation = nil end
			end
		end
		
		if isNear then 
			sleep = 5 
			showHelpNotification("~INPUT_CONTEXT~ "..nearestLocation.Label)
		else 
			sleep = 500
			nearestLocation = nil
		end
		Citizen.Wait(sleep)
	end
end)

RegisterKeyMapping('handleBackroomAction', 'Backroom', 'keyboard', 'E')

function teleportPlayer(data)
	FreezeEntityPosition(data.playerPed, true)
	RequestCollisionAtCoord(data.randomBackroom.x, data.randomBackroom.y, data.randomBackroom.z)
	while not HasCollisionLoadedAroundEntity(data.playerPed) do
		Wait(0)
	end
	SetEntityCoordsNoOffset(playerPed, data.randomBackroom.x, data.randomBackroom.y, data.randomBackroom.z, true, false, false)
	Wait(1200)
	FreezeEntityPosition(data.playerPed, false)
end


function showHelpNotification(text)
    BeginTextCommandDisplayHelp("THREESTRINGS")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, 5000)
end
