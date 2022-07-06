Config = Config or {}

Config.SellLocation = {
    [1] = {
            coords = vector3(1703.29, 3779.5, 34.75),
            length = 1.2,
            width = 0.5,
            heading = 125,
            debugPoly = false,
            minZ = 32.15,
            maxZ = 36.15,
            distance = 1.0
        },
    }

Config.BankMoney = false -- Set to true if you want the money to go into the players bank
Config.UseTimes = false -- Set to false if you want the pawnshop open 24/7

Config.UseTarget = GetConvar('UseTarget', 'false') == 'true'

Config.NotifyType = 'okok' -- notification type: 'qb' for qb-core standard notifications, 'okok' for okokNotify notifications

Config.Objects = {
    -- Trash objects player can interact with - add more props to expand the function
    "prop_dumpster_01a",
    "prop_dumpster_01a",
    "prop_dumpster_02a",
    "prop_dumpster_02b",
}

Config.TrashItems = {
    [1] = {
        item = "bottlecaps",
        price = 15
    },
    [2] = {
        item = "ace",
        price = 50
    },
    [3] = {
        item = "sunglasses",
        price = 60
    },
    [4] = {
        item = "crayons",
        price = 70
    },
    [5] = {
        item = "teddy",
        price = 85
    },
    [6] = {
        item = "fabric",
        price = 100
    },
    [7] = {
        item = "actiontoy",
        price = 130
    },
    [8] = {
        item = "wd40",
        price = 150
    },
    [9] = {
        item = "screwdriver",
        price = 170
    },
}

Config.TrashItems2 = { -- 10% increase in price (off base prices) rounded to the nearest dollar
    [1] = {
        item = "bottlecaps",
        price = 17
    },
    [2] = {
        item = "ace",
        price = 55
    },
    [3] = {
        item = "sunglasses",
        price = 66
    },
    [4] = {
        item = "crayons",
        price = 77
    },
    [5] = {
        item = "teddy",
        price = 94
    },
    [6] = {
        item = "fabric",
        price = 110
    },
    [7] = {
        item = "actiontoy",
        price = 143
    },
    [8] = {
        item = "wd40",
        price = 165
    },
    [9] = {
        item = "screwdriver",
        price = 187
    },
}

Config.TrashItems3 = { -- 20% increase in price (off base prices) rounded to the nearest dollar
    [1] = {
        item = "bottlecaps",
        price = 18
    },
    [2] = {
        item = "ace",
        price = 60
    },
    [3] = {
        item = "sunglasses",
        price = 72
    },
    [4] = {
        item = "crayons",
        price = 84
    },
    [5] = {
        item = "teddy",
        price = 102
    },
    [6] = {
        item = "fabric",
        price = 120
    },
    [7] = {
        item = "actiontoy",
        price = 156
    },
    [8] = {
        item = "wd40",
        price = 180
    },
    [9] = {
        item = "screwdriver",
        price = 204
    },
}

Config.TrashItems4 = { -- 30% increase in price (off base prices) rounded to the nearest dollar
    [1] = {
        item = "bottlecaps",
        price = 20
    },
    [2] = {
        item = "ace",
        price = 65
    },
    [3] = {
        item = "sunglasses",
        price = 78
    },
    [4] = {
        item = "crayons",
        price = 91
    },
    [5] = {
        item = "teddy",
        price = 111
    },
    [6] = {
        item = "fabric",
        price = 130
    },
    [7] = {
        item = "actiontoy",
        price = 169
    },
    [8] = {
        item = "wd40",
        price = 195
    },
    [9] = {
        item = "screwdriver",
        price = 221
    },
}

Config.TrashItems5 = { -- 40% increase in price (off base prices) rounded to the nearest dollar
    [1] = {
        item = "bottlecaps",
        price = 21
    },
    [2] = {
        item = "ace",
        price = 70
    },
    [3] = {
        item = "sunglasses",
        price = 84
    },
    [4] = {
        item = "crayons",
        price = 98
    },
    [5] = {
        item = "teddy",
        price = 119
    },
    [6] = {
        item = "fabric",
        price = 140
    },
    [7] = {
        item = "actiontoy",
        price = 182
    },
    [8] = {
        item = "wd40",
        price = 210
    },
    [9] = {
        item = "screwdriver",
        price = 238
    },
}

Config.TrashItems6 = { -- 50% increase in price (off base prices) rounded to the nearest dollar
    [1] = {
        item = "bottlecaps",
        price = 23
    },
    [2] = {
        item = "ace",
        price = 75
    },
    [3] = {
        item = "sunglasses",
        price = 90
    },
    [4] = {
        item = "crayons",
        price = 110
    },
    [5] = {
        item = "teddy",
        price = 128
    },
    [6] = {
        item = "fabric",
        price = 150
    },
    [7] = {
        item = "actiontoy",
        price = 195
    },
    [8] = {
        item = "wd40",
        price = 225
    },
    [9] = {
        item = "screwdriver",
        price = 255
    },
}

Config.TrashItems7 = { -- 60% increase in price (off base prices) rounded to the nearest dollar
    [1] = {
        item = "bottlecaps",
        price = 24
    },
    [2] = {
        item = "ace",
        price = 80
    },
    [3] = {
        item = "sunglasses",
        price = 96
    },
    [4] = {
        item = "crayons",
        price = 112
    },
    [5] = {
        item = "teddy",
        price = 136
    },
    [6] = {
        item = "fabric",
        price = 160
    },
    [7] = {
        item = "actiontoy",
        price = 208
    },
    [8] = {
        item = "wd40",
        price = 240
    },
    [9] = {
        item = "screwdriver",
        price = 272
    },
}

Config.TrashItems8 = { -- 75% increase in price (off base prices) rounded to the nearest dollar
    [1] = {
        item = "bottlecaps",
        price = 27
    },
    [2] = {
        item = "ace",
        price = 88
    },
    [3] = {
        item = "sunglasses",
        price = 105
    },
    [4] = {
        item = "crayons",
        price = 123
    },
    [5] = {
        item = "teddy",
        price = 149
    },
    [6] = {
        item = "fabric",
        price = 175
    },
    [7] = {
        item = "actiontoy",
        price = 228
    },
    [8] = {
        item = "wd40",
        price = 263
    },
    [9] = {
        item = "screwdriver",
        price = 298
    },
}

Config.TrashItems9 = { -- 100% increase in price (off base prices) rounded to the nearest dollar
    [1] = {
        item = "bottlecaps",
        price = 30
    },
    [2] = {
        item = "ace",
        price = 100
    },
    [3] = {
        item = "sunglasses",
        price = 120
    },
    [4] = {
        item = "crayons",
        price = 140
    },
    [5] = {
        item = "teddy",
        price = 170
    },
    [6] = {
        item = "fabric",
        price = 200
    },
    [7] = {
        item = "actiontoy",
        price = 260
    },
    [8] = {
        item = "wd40",
        price = 300
    },
    [9] = {
        item = "screwdriver",
        price = 340
    },
}