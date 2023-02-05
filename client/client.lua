local RSGCore = exports['rsg-core']:GetCoreObject()
local isLoggedIn = false

RegisterNetEvent('RSGCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

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
            icon = "fas fa-concierge-bell",
            params = {
                event = 'rsg-hotel:server:CheckIn',
                isServer = true,
                args = { location = hotellocation }
            }
        },
        {
            header = 'Rent a Room ($'..Config.StartCredit..' Deposit)',
            txt = '',
            icon = "fas fa-bed",
            params = {
                event = 'rsg-hotel:server:RentRoom',
                isServer = true,
                args = { location = hotellocation }
            }
        },
        {
            header = 'Close Menu',
            txt = '',
            icon = "fas fa-times",
            params = {
                event = 'rsg-menu:closeMenu',
            }
        },
    })
    
end)

--------------------------------------------------------------------------------------------------

-- transfer player to room
RegisterNetEvent('rsg-hotel:client:gotoRoom', function(location)
    if location == 'valentine' then
        DoScreenFadeOut(500)
        Wait(1000)
        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), vector4(-323.935, 767.02294, 121.6327, 102.64147))
        Wait(1500)
        DoScreenFadeIn(1800)
    end
    if location == 'stawberry' then
        DoScreenFadeOut(500)
        Wait(1000)
        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), vector4(-1813.903, -370.0737, 166.49919, 269.52258))
        Wait(1500)
        DoScreenFadeIn(1800)
    end
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
RegisterNetEvent('rsg-hotel:client:roommenu', function()
    RSGCore.Functions.TriggerCallback('rsg-hotel:server:GetActiveRoom', function(result)
        local activeRoom = {
            {
                header = 'Hotel Room : '..result.roomid,
                txt = '',
                isMenuHeader = true
            },
        }
        activeRoom[#activeRoom+1] = {
            header = 'Add Credit',
            txt = 'current credit $'..result.credit,
            icon = "fas fa-dollar-sign",
            params = {
                event = "rsg-hotel:client:addcredit",
                isServer = false,
                args = { room = result.roomid, credit = result.credit },
            }
        }
        activeRoom[#activeRoom+1] = {
            header = 'Wardrobe',
            txt = '',
            icon = "fas fa-hat-cowboy-side",
            params = {
                event = "rsg-clothes:OpenOutfits",
                isServer = false,
                args = {},
            }
        }
        activeRoom[#activeRoom+1] = {
            header = 'Room Locker',
            txt = '',
            icon = "fas fa-box",
            params = {
                event = "rsg-hotel:client:roomlocker",
                isServer = false,
                args = { roomid = result.roomid, location = result.location },
            }
        }
        activeRoom[#activeRoom+1] = {
            header = 'Mini-Bar',
            txt = '',
            icon = "fas fa-glass-cheers",
            params = {
                event = "rsg-hotel:client:minibar",
                isServer = false,
                args = { roomid = result.roomid },
            }
        }
        activeRoom[#activeRoom+1] = {
            header = 'Leave Room',
            txt = '',
            icon = "fas fa-door-open",
            params = {
                event = 'rsg-hotel:client:leaveroom',
                isServer = false,
                args = { exitroom = result.location }
            }
        }
        activeRoom[#activeRoom+1] = {
            header = 'Close Menu',
            txt = '',
            icon = "fas fa-times",
            params = {
                event = 'rsg-menu:closeMenu',
            }
        }
        exports['rsg-menu']:openMenu(activeRoom)
    end)
end)

--------------------------------------------------------------------------------------------------

RegisterNetEvent('rsg-hotel:client:addcredit', function(data)
    local dialog = exports['rsg-input']:ShowInput({
        header = "Add Credit to Room "..data.room,
        submitText = "",
        inputs = {
            {
                text = "Amount ($)",
                name = "addcredit",
                type = "number",
                isRequired = true,
                default = 10,
            },
        }
    })
    if dialog ~= nil then
        for k,v in pairs(dialog) do
            if Config.Debug == true then
                print(dialog.addcredit)
                print(data.room)
            end
            local newcredit = (data.credit + dialog.addcredit)
            TriggerServerEvent('rsg-hotel:server:addcredit', newcredit, data.room)
        end
    end
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
    if roomlocation == 'stawberry' then
        DoScreenFadeOut(500)
        Wait(1000)
        TriggerServerEvent('rsg-hotel:server:setdefaultbucket')
        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), vector4(-1814.274, -369.9327, 162.88313, 277.07699))
        Wait(1500)
        DoScreenFadeIn(1800)
    end
end)

--------------------------------------------------------------------------------------------------

-- room storage locker
RegisterNetEvent('rsg-hotel:client:roomlocker', function(data)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", 'room_'..data.roomid..'_'..data.location, {
        maxweight = Config.StorageMaxWeight,
        slots = Config.StorageMaxSlots,
    })
    TriggerEvent("inventory:client:SetCurrentStash", 'room_'..data.roomid..'_'..data.location)
end)

RegisterNetEvent('rsg-hotel:client:minibar')
AddEventHandler('rsg-hotel:client:minibar', function(data)
    local ShopItems = {}
    ShopItems.label = 'Room '..data.roomid..' Mini-Bar'
    ShopItems.items = Config.MiniBar
    ShopItems.slots = #Config.MiniBar
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "Config.MiniBar_"..math.random(1, 99), ShopItems)
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
