local RSGCore = exports['rsg-core']:GetCoreObject()

RegisterNetEvent('rsg-hotel:server:EnterRoom', function(data)
    print(data.enterhotel)
    local enterhotel = data.enterhotel
    local src = source
    local bucket = math.random(1,9999999999)
    SetPlayerRoutingBucket(src, tonumber(bucket))
	local currentbucket = GetPlayerRoutingBucket(src)
	print(currentbucket)
    TriggerClientEvent('rsg-hotel:client:roomteleport', src, enterhotel)
end)

RegisterNetEvent('rsg-hotel:server:LeaveRoom', function(data)
    print(data.exithotel)
    local exithotel = data.exithotel
    local src = source
    SetPlayerRoutingBucket(src, 0)
	local currentbucket = GetPlayerRoutingBucket(src)
	print(currentbucket)
    TriggerClientEvent('rsg-hotel:client:leaveroomteleport', src, exithotel)
end)

-- create unique room id / -- RSGCore.Player.CreateRoomId()
function RSGCore.Player.CreateRoomId()
    local UniqueFound = false
    local RoomId = nil
    while not UniqueFound do
        RoomId = (RSGCore.Shared.RandomInt(2) .. RSGCore.Shared.RandomInt(2))
		print(RoomId)
        local result = MySQL.prepare.await("SELECT COUNT(*) as count FROM player_rooms WHERE roomid = ?", { RoomId })
        if result == 0 then
            UniqueFound = true
        end
    end
    return RoomId
end
