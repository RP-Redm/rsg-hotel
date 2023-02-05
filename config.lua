Config = {}

Config.Debug = false

-- settings
Config.BillingCycle = 1 -- will remove credit every x hour/s
Config.RentPerCycle = 1 -- $ amount of rent added per cycle
Config.StartCredit = 10 -- $ amount of credit added when renting room
Config.StorageMaxWeight = 4000000
Config.StorageMaxSlots = 48

-- room service
Config.MiniBar = {
    [1] = { name = "bread",       price = 0,   amount = 2,  info = {}, type = "item", slot = 1, },
    [2] = { name = "water",       price = 0,   amount = 2,  info = {}, type = "item", slot = 2, },
    [3] = { name = "beer",        price = 0,   amount = 2,  info = {}, type = "item", slot = 3, },
    [4] = { name = "coffee",      price = 0,   amount = 2,  info = {}, type = "item", slot = 4, },
    [5] = { name = "stew",        price = 0,   amount = 2,  info = {}, type = "item", slot = 5, },
    [6] = { name = "cooked_meat", price = 0,   amount = 2,  info = {}, type = "item", slot = 6, },
    [7] = { name = "cooked_fish", price = 0,   amount = 2,  info = {}, type = "item", slot = 7, },
    [8] = { name = "cigar",       price = 0,   amount = 2,  info = {}, type = "item", slot = 8, },
}

-- blip settings
Config.Blip = {
    blipName = 'Hotel', -- Config.Blip.blipName
    blipSprite = 'blip_hotel_bed', -- Config.Blip.blipSprite
    blipScale = 0.2 -- Config.Blip.blipScale
}

-- prompt locations
Config.HotelLocations = {
    { -- valentine
        name = 'Valentine Hotel', 
        prompt = 'valhotel', 
        location = 'valentine', 
        coords = vector3(-325.7658, 774.46496, 117.45713),
        showblip = true
    },
    { -- stawberry
        name = 'Stawberry Hotel', 
        prompt = 'stawberryhotel', 
        location = 'stawberry', 
        coords = vector3(-1817.56, -370.8123, 163.29635),
        showblip = true
    }, 
}

Config.HotelRoom = {
    { -- valentine
        name = 'Valentine Hotel Room', 
        prompt = 'valhotelroom', 
        location = 'valentine', 
        coords = vector3(-323.935, 767.02294, 121.6327),
    },
    { -- stawberry
        name = 'Stawberry Hotel Room', 
        prompt = 'stawberryhotelroom', 
        location = 'stawberry', 
        coords = vector3(-1813.394, -368.9348, 166.49964),
    },
}

Config.HotelDoors = {
    238680582, -- valentine
    3765902977, -- valentine
    3049177115, -- valentine
    1407130373, -- stawberry
    1654175864, -- stawberry
}
