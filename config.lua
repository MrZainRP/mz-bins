Config = Config or {}

Config.NotifyType = 'okok' -- notification type: 'qb' for qb-core standard notifications, 'okok' for okokNotify notifications

--------------
--BIN DIVING--
--------------

--1. MZ-SKILLS?--
Config.mzskills = false -- change to 'false' to utilise resource without using mz-skills re: "Searching" skill
--If you choose to use mz-skills, the following parameters will apply:
Config.diveXPlow = 1 -- Lowest amount of XP player will get for dumpster diving
Config.diveXPhigh = 3 -- Highest amount of XP player will get for dumpster diving
Config.diveXPloss = 2 -- Amount of XP lost for failing skillcheck (if skillcheck is enabled)

--2. SKILLCHECK?--
Config.skillcheck = false -- change to 'false' to remove the skillcheck connected to each bin dive.
--If you chose to use a skillcheck, the following parameters will apply
Config.diveparselow = 1 -- Lowest number of skillcheck parses possible when bin diving.
Config.diveparsehigh = 1 -- Highest number of skillcheck parses possible when bin diving.
Config.diveparsetime = 12 -- Time for bindive skill check (NOTE: A higher time makes the skillcheck slower but generally easier)

--3. RARE ITEMS?--
Config.rareitems = true -- change to 'false' to disable (NOTE: Rare drops are in addition to standard drops, not in substitution)
--If you choose to have a potential for rare items to drop from searching bins, the following properties apply:
Config.Rareitem1 = "wd40" -- 1.5% chance to find when searching a bin
Config.Rareitem2 = "blankusb" -- 1% chance to find when searching a bin
Config.Rareitem3 = "pistol1" -- 0.5% chance to find when searching a bin
Config.Rareitem4 = "screwdriver" -- 0.5% chance to find when searching a bin

--4. GENERAL BIN SEARCHING PROPERTIES--
--Time it takes to search bin
Config.SearchTimeLow = 3 -- Lowest time it will take to search a bin (in seconds)
Config.SearchTimeHigh = 5 -- Highest time it will take to search a bin (in seconds)
--Fail function + chance of failure
Config.FailEnabled = "yes" -- change to "no" if you do not want a player to have a chance to find nothing from searching a bin
Config.FailChance = 10 -- Percentage chance for a player to fail to find anything useful upon a successful search of a bin

------------
--CRAFTING--
------------

--DEFAULT CRAFTING LOCATION: -1156.22, -1999.3, 13.18 (Change the "BinParts" boxZone to relocate the crafting location)

--1. CRUSHING CANS
Config.canslow = 3 -- Lowest number of skillchecks to crush cans.
Config.canshigh = 5 -- Highest number of skillchecks to crush cans.
Config.canstimelow = 6 -- Lowest time (in seconds) to crush cans. 
Config.canstimehigh = 10 -- Highest time (in seconds) to crush cans.

--If using "mz-skills" thje following XP parameters will apply:
Config.cansXPlow = 3 -- Lowest amount of "Searching" XP gained from crushing cans. 
Config.cansXPhigh = 6 -- Highest amount of "Searching" XP gained from crushing cans. 
Config.cansXPloss = 3 -- Amount of "Searching" XP lost from failing to crush cans. 

--Inputs and outputs
Config.cansamount = 3 -- Number of cans needed in order to be able to crush them.
Config.cansreturnlow = 3 -- Lowest return for crushing cans.
Config.cansreturnhigh = 5 -- Highest return for crushing cans.

----------------------------------------------------

--2. CRUSHING BOTTLES
Config.bottleslow = 3 -- Lowest number of skillchecks to crush bottles.
Config.bottleshigh = 5 -- Highest number of skillchecks to crush bottles.
Config.bottlestimelow = 6 -- Lowest time (in seconds) to crush bottles. 
Config.bottlestimehigh = 10 -- Highest time (in seconds) to crush bottles. 

--If using "mz-skills" thje following XP parameters will apply:
Config.bottlesXPlow = 3 -- Lowest amount of "Searching" XP gained from crushing bottles. 
Config.bottlesXPhigh = 6 -- Highest amount of "Searching" XP gained from crushing bottles. 
Config.bottlesXPloss = 3 -- Amount of "Searching" XP lost from failing to crush bottles. 

--Inputs and outputs
Config.bottlesamount = 3 -- Number of bottles needed in order to be able to crush them.
Config.bottlesreturnlow = 3 -- Lowest return for crushing bottles.
Config.bottlesreturnhigh = 5 -- Highest return for crushing bottles.

----------------------------------------------------

--3. CRUSHING BOTTLECAPS
Config.bottlecapslow = 5 -- Lowest number of skillchecks to crush bottlecaps.
Config.bottlecapshigh = 7 -- Highest number of skillchecks to crush bottlecaps.
Config.bottlecapstimelow = 6 -- Lowest time (in seconds) to crush bottlecaps. 
Config.bottlecapstimehigh = 10 -- Highest time (in seconds) to crush bottlecaps. 

--If using "mz-skills" thje following XP parameters will apply:
Config.bottlecapsXPlow = 3 -- Lowest amount of "Searching" XP gained from crushing bottlecaps. 
Config.bottlecapsXPhigh = 6 -- Highest amount of "Searching" XP gained from crushing bottlecaps. 
Config.bottlecapsXPloss = 3 -- Amount of "Searching" XP lost from failing to crush bottlecaps. 

--Inputs and outputs
Config.bottlecapsamount = 3 -- Number of bottlecaps needed in order to be able to crush them.
Config.bottlecapsreturnlow = 3 -- Lowest return for crushing bottlecaps.
Config.bottlecapsreturnhigh = 8 -- Highest return for crushing bottlecaps.

----------------------------------------------------

--4. CRUSHING BROKENCUP
Config.brokencuplow = 5 -- Lowest number of skillchecks to crush broken cups.
Config.brokencuphigh = 7 -- Highest number of skillchecks to crush broken cups.
Config.brokencuptimelow = 6 -- Lowest time (in seconds) to crush broken cups.
Config.brokencuptimehigh = 10 -- Highest time (in seconds) to crush broken cups.

--If using "mz-skills" thje following XP parameters will apply:
Config.brokencupXPlow = 4 -- Lowest amount of "Searching" XP gained from crushing broken cups.
Config.brokencupXPhigh = 7 -- Highest amount of "Searching" XP gained from crushing broken cups.
Config.brokencupXPloss = 3 -- Amount of "Searching" XP lost from failing to crush broken cups.

--Inputs and outputs
Config.brokencupamount = 3 -- Number of brokencup needed in order to be able to crush them.
Config.brokencupreturnlow = 3 -- Lowest return for crushing broken cups.
Config.brokencupreturnhigh = 7 -- Highest return for crushing broken cups.

----------------------------------------------------

--OBJECTS--

-- Trash objects player can interact with - [add more props to this list if you wish to expand the bin searching function to those props]
Config.Objects = {
    "prop_dumpster_01a",
    "prop_dumpster_01a",
    "prop_dumpster_02a",
    "prop_dumpster_02b",
}

-----------------
--SELLING ITEMS--
-----------------
Config.SellLocation = { -- If you change this - be sure to also change the details for the "sellbinitems" boxZone in client/main.lua. Those details should match the details in this config variable.
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

-- NO MZ-SKILLS
-- The following table applies if you are not using "mz-skills".

    Config.TrashItemsNOXP = {
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

--MZ-SKILLS
--The following tables apply if you are using "mz-skills". The relevant table called depends on the amount of "Searching" XP a player has at the time of attempting to sell items found in bins. 

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