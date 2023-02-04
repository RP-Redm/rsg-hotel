local RSGCore = exports['rsg-core']:GetCoreObject()

--------------------------------------------------------------------------------------------------

-- hotel prompts
Citizen.CreateThread(function()
    for hotel, v in pairs(Config.HotelLocations) do
        exports['rsg-core']:createPrompt(v.prompt, v.coords, RSGCore.Shared.Keybinds['J'], 'Open ' .. v.name, {
            type = 'client',
            event = 'rsg-hotel:client:menu',
            args = { v.name, v.location },
        })
        if v.showblip == true then
            local HotelBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.coords)
            SetBlipSprite(HotelBlip, GetHashKey(Config.Blip.blipSprite), true)
            SetBlipScale(HotelBlip, Config.Blip.blipScale)
            Citizen.InvokeNative(0x9CB1A1623062F402, HotelBlip, Config.Blip.blipName)
        end
    end
end)

-- hotel menu
RegisterNetEvent('rsg-hotel:client:menu', function(hotelname, hotellocation)
    exports['rsg-menu']:openMenu({
        {
            header = hotelname,
            isMenuHeader = true,
        },
        {
            header = 'Check-In',
            txt = '',
            icon = "fas fa-bed",
            params = {
                event = 'rsg-hotel:client:EnterHotel',
                isServer = false,
                args = { location = hotellocation }
            }
        },
        {
            header = 'Rent a Room',
            txt = '',
            icon = "fas fa-bed",
            params = {
                event = 'rsg-hotel:client:RentRoom',
                isServer = false,
                args = { location = hotellocation }
            }
        },
        {
            header = 'Close Menu',
            txt = '',
            params = {
                event = 'rsg-menu:closeMenu',
            }
        },
    })
	
end)

--------------------------------------------------------------------------------------------------

-- check players and enter room
RegisterNetEvent('rsg-hotel:client:EnterHotel', function(location)
    RSGCore.Functions.TriggerCallback('rsg-hotel:server:GetOwnedRoom', function(result)
        if result ~= nil then
            if Config.Debug == true then
                print(result.citizenid)
                print(result.location)
                print(result.roomid)
                print(result.date)
            end
            if result.location == 'valentine' then
                DoScreenFadeOut(500)
                Wait(1000)
                TriggerServerEvent('rsg-hotel:server:setroombucket', result.roomid) -- set player bucket
                Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), vector4(-323.935, 767.02294, 121.6327, 102.64147))
                Wait(1500)
                DoScreenFadeIn(1800)
            else
                RSGCore.Functions.Notify('you don\'t have a room here!', 'primary')
            end            
        end
    end)
end)

--------------------------------------------------------------------------------------------------

-- rent a room
RegisterNetEvent('rsg-hotel:client:RentRoom', function(location)
    RSGCore.Functions.TriggerCallback('rsg-hotel:server:GetOwnedRoom', function(result)
        local roomlocation = result.location
        if roomlocation == nil then
            TriggerServerEvent('rsg-hotel:server:RentRoom', roomlocation)
        else
            RSGCore.Functions.Notify('you already have a room here!', 'primary')
        end
    end)
end)

--------------------------------------------------------------------------------------------------

-- room menu prompt
Citizen.CreateThread(function()
    for hotelexit, v in pairs(Config.HotelRoom) do
        exports['rsg-core']:createPrompt(v.prompt, v.coords, RSGCore.Shared.Keybinds['J'], 'Room Menu', {
            type = 'client',
            event = 'rsg-hotel:client:roommenu',
            args = { v.location },
        })
    end
end)

-- room menu
RegisterNetEvent('rsg-hotel:client:roommenu', function(location)
    exports['rsg-menu']:openMenu({
        {
            header = 'Room Menu',
            isMenuHeader = true,
        },
        {
            header = 'Leave Room',
            txt = '',
            icon = "fas fa-concierge-bell",
            params = {
                event = 'rsg-hotel:client:leaveroom',
                isServer = false,
                args = { exitroom = location }
            }
        },
        {
            header = 'Close Menu',
            txt = '',
            params = {
                event = 'rsg-menu:closeMenu',
            }
        },
    })
    
end)

--------------------------------------------------------------------------------------------------

-- leave room
RegisterNetEvent('rsg-hotel:client:leaveroom')
AddEventHandler('rsg-hotel:client:leaveroom', function(data)
    if Config.Debug == true then
        print(data.exitroom)
    end
    local roomlocation = data.exitroom
    if roomlocation == 'valentine' then
        DoScreenFadeOut(500)
        Wait(1000)
        TriggerServerEvent('rsg-hotel:server:setdefaultbucket')
        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), vector4(-328.99, 772.95, 117.45, 13.64))
        Wait(1500)
        DoScreenFadeIn(1800)
    end
end)

--------------------------------------------------------------------------------------------------

-- lock hotel doors
Citizen.CreateThread(function()
    for k,v in pairs(Config.HotelDoors) do
        Citizen.InvokeNative(0xD99229FE93B46286, v, 1,1,0,0,0,0)
        DoorSystemSetDoorState(v, 1) 
    end
end)

--[[
    DOORSTATE_INVALID = -1,
    0 = DOORSTATE_UNLOCKED,
    1 = DOORSTATE_LOCKED_UNBREAKABLE,
    2 = DOORSTATE_LOCKED_BREAKABLE,
    3 = DOORSTATE_HOLD_OPEN_POSITIVE,
    4 = DOORSTATE_HOLD_OPEN_NEGATIVE
--]]

--------------------------------------------------------------------------------------------------
