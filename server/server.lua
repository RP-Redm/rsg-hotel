local RSGCore = exports['rsg-core']:GetCoreObject()

--------------------------------------------------------------------------------------------------

-- rent room
RegisterNetEvent('rsg-hotel:server:RentRoom', function(data)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local roomid = RSGCore.Player.CreateRoomId()
    local location = data.location
    local date = os.date()
    MySQL.insert('INSERT INTO player_rooms (citizenid, location, roomid, date) VALUES (?, ?, ?, ?)', {
        citizenid,
        location,
        roomid,
        date
    })
end)

--------------------------------------------------------------------------------------------------

-- get player room
RSGCore.Functions.CreateCallback('rsg-hotel:server:GetOwnedRoom', function(source, cb, cid)
    if cid ~= nil then
        local result = MySQL.query.await('SELECT * FROM player_rooms WHERE citizenid = ?', { cid })
        if result[1] ~= nil then
            return cb(result[1])
        end
        return cb(nil)
    else
        local src = source
        local Player = RSGCore.Functions.GetPlayer(src)
        local result = MySQL.query.await('SELECT * FROM player_rooms WHERE citizenid = ?', { Player.PlayerData.citizenid })
        if result[1] ~= nil then
            return cb(result[1])
        end
        return cb(nil)
    end
end)

--------------------------------------------------------------------------------------------------

-- set room bucket
RegisterNetEvent('rsg-hotel:server:setroombucket', function(roomid)
    local src = source
    local bucket = roomid
    SetPlayerRoutingBucket(src, tonumber(bucket))
    local currentbucket = GetPlayerRoutingBucket(src)
    if Config.Debug == true then
        print('Current Bucket:'..currentbucket)
    end
end)

-- set player default bucket
RegisterNetEvent('rsg-hotel:server:setdefaultbucket', function()
    local src = source
    SetPlayerRoutingBucket(src, 0)
    local currentbucket = GetPlayerRoutingBucket(src)
    if Config.Debug == true then
        print('Current Bucket:'..currentbucket)
    end
end)

--------------------------------------------------------------------------------------------------

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
