local RSGCore = exports['rsg-core']:GetCoreObject()

--------------------------------------------------------------------------------------------------

-- rent room
RegisterNetEvent('rsg-hotel:server:RentRoom', function(location)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local roomid = RSGCore.Player.CreateRoomId()
    local credit = Config.StartCredit
    local date = os.date()
    local cashBalance = Player.PlayerData.money["cash"]
    if cashBalance >= credit then
        MySQL.insert('INSERT INTO player_rooms (citizenid, location, credit, roomid, date) VALUES (?, ?, ?, ?, ?)', {
            citizenid,
            location,
            credit,
            roomid,
            date
        })
        Player.Functions.RemoveMoney("cash", credit, "room-rental")
        RSGCore.Functions.Notify(src, 'you rented room '..roomid, 'success')
    else
        RSGCore.Functions.Notify(src, 'not enought cash to rent a room!', 'error')
    end    
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
    local Player = RSGCore.Functions.GetPlayer(src)
    local bucket = roomid
    SetPlayerRoutingBucket(src, tonumber(bucket))
    local currentbucket = GetPlayerRoutingBucket(src)
    if Config.Debug == true then
        print('Current Bucket:'..currentbucket)
    end
    MySQL.update('UPDATE player_rooms SET active = ? WHERE roomid = ? AND citizenid = ?', { 1, roomid, Player.PlayerData.citizenid })
end)

-- set player default bucket
RegisterNetEvent('rsg-hotel:server:setdefaultbucket', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    SetPlayerRoutingBucket(src, 0)
    local currentbucket = GetPlayerRoutingBucket(src)
    if Config.Debug == true then
        print('Current Bucket:'..currentbucket)
    end
    MySQL.update('UPDATE player_rooms SET active = ? WHERE citizenid = ?', { 0, Player.PlayerData.citizenid })
end)

--------------------------------------------------------------------------------------------------

-- create unique room id / -- RSGCore.Player.CreateRoomId()
function RSGCore.Player.CreateRoomId()
    local UniqueFound = false
    local RoomId = nil
    while not UniqueFound do
        RoomId = (RSGCore.Shared.RandomInt(2) .. RSGCore.Shared.RandomInt(2))
        local result = MySQL.prepare.await("SELECT COUNT(*) as count FROM player_rooms WHERE roomid = ?", { RoomId })
        if result == 0 then
            UniqueFound = true
        end
    end
    return RoomId
end

--------------------------------------------------------------------------------------------------

-- billing loop
function BillingInterval()
    local result = MySQL.query.await('SELECT * FROM player_rooms')
    if result then
        for i = 1, #result do
            local row = result[i]
            if Config.Debug == true then
                print(row.citizenid, row.location, row.credit, row.roomid)
            end
            if row.credit >= Config.RentPerCycle then
                local creditadjust = (row.credit - Config.RentPerCycle)
                MySQL.update('UPDATE player_rooms SET credit = ? WHERE roomid = ? AND citizenid = ?', { creditadjust, row.roomid, row.citizenid })
            else
                MySQL.update('DELETE FROM player_rooms WHERE roomid = ? AND citizenid = ?', { row.roomid, row.citizenid })
                print('not enough credit - '..row.roomid..' room deleted')
            end
        end
    end
    SetTimeout(Config.BillingCycle * (60 * 1000), BillingInterval)
end

SetTimeout(Config.BillingCycle * (60 * 1000), BillingInterval) -- mins
--SetTimeout(Config.BillingCycle * (60 * 60 * 1000), BillingInterval) -- hours

--------------------------------------------------------------------------------------------------
