local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local isLoggedIn = false
local percent    = false
local searching  = false
local isInVehicle = false
local NeededAttempts = 0
local SucceededAttempts = 0
local FailedAttemps = 0
local craftcheck = false
local craftprocesscheck = false

cachedBins = {}

closestBin = {
    'prop_dumpster_01a', 
    'prop_dumpster_02a',
    'prop_dumpster_02b',
    'prop_dumpster_3a'
}

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    isLoggedIn = true
end)


DrawText3Ds = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent("mz-bins:SearchBin")
AddEventHandler("mz-bins:SearchBin", function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    for i = 1, #closestBin do
        local x = GetClosestObjectOfType(playerCoords, 1.0, GetHashKey(closestBin[i]), false, false, false)
        local entity = nil
        if DoesEntityExist(x) and not IsPedSittingInAnyVehicle(PlayerPedId()) then
            entity = x
            if not cachedBins[entity] then
                local success = exports['qb-lock']:StartLockPickCircle(1, 13)
                if success then
                    openBin(entity)
                    Wait(2000)
                    local chance = 1
                    local xpmultiple = math.random(1, 4)
                    if xpmultiple > 3 then
                        chance = 2
                    elseif xpmultiple < 4 then
                        chance = 1
                    end
                    exports["mz-skills"]:UpdateSkill("Searching", chance)
                else
                    local deteriorate = -2
                    exports["mz-skills"]:UpdateSkill("Searching", deteriorate)
                    if Config.NotifyType == 'qb' then
                        QBCore.Functions.Notify('Ouch! Did something just poke me?', "error", 3500)
                        Wait(1600)
                        QBCore.Functions.Notify('-2 XP to Searching', "error", 3500)
                    elseif Config.NotifyType == "okok" then
                        exports['okokNotify']:Alert("UH OH!", "Ouch! Did something just poke me?", 3500, "error")
                        Wait(1600)
                        exports['okokNotify']:Alert("SKILLS", "-2 XP to Searching", 3500, "error")
                    end   
                end
            else
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify('You already searched this dumpster.',"error", 3500)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("ALREADY SEARCHED", "You already searched this dumpster.", 3500, "error")
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)
    while true do
        local sleep = 1000
        if percent then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            for i = 1, #closestBin do
                local x = GetClosestObjectOfType(playerCoords, 1.0, GetHashKey(closestBin[i]), false, false, false)
                local entity = nil
                if DoesEntityExist(x) then
                    sleep  = 5
                    entity = x
                    bin    = GetEntityCoords(entity)
                    DrawText3Ds(bin.x, bin.y, bin.z + 1.5, TimeLeft .. '~g~%~s~')
                    break
                end
            end
        end
        Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if searching then
            DisableControlAction(0, 73)
        end
    end
end)

openBin = function(entity)
    QBCore.Functions.Progressbar("search_register", "Searching for treasure...", math.random(3000, 5000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
        DisableControlAction(0, 170, true),
    }, {
        animDict = "amb@prop_human_bum_bin@base",
        anim = "base",
        flags = 50,
    }, {}, {}, function() -- Done
        searching = true
        cachedBins[entity] = true
        QBCore.Functions.TriggerCallback('mz-bins:getItem', function(result)
        end)
        ClearPedTasks(PlayerPedId())
        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_bin@base", "base", 1.0)
        searching = false
    end, function() -- Cancel
        GetMoney = false
        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_bin@base", "base", 1.0)
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("Process Cancelled", "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("CANCELLED", "Process Cancelled.", 3500, "error")
        end        
    end)
end

------------
--CRAFTING--
------------

--------------------
--BREAK DOWN PARTS--
--------------------

------------
--ALUMINUM--
------------

RegisterNetEvent('mz-bins:client:BreakdownCans')
AddEventHandler('mz-bins:client:BreakdownCans', function()
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
        if result then
            TriggerServerEvent("mz-bins:server:BreakdownCans")
        else
            local requiredItems = {
                [1] = {name = QBCore.Shared.Items["sodacan"]["name"], image = QBCore.Shared.Items["sodacan"]["image"]}, 
            }  
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You need soda cans to press...', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("NEED CANS", "You need soda cans to press...", 3500, "error")
            end   
            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
            Wait(3000)
            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
        end
    end, {"sodacan"})
end)

RegisterNetEvent('mz-bins:client:BreakdownCansMinigame')
AddEventHandler('mz-bins:client:BreakdownCansMinigame', function(source)
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    BreakdownCansMinigame(source)
end)

function BreakdownCansMinigame(source)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(3, 5)
    end
    local maxwidth = 30
    local maxduration = 3000
    Skillbar.Start({
        duration = math.random(1400, 1500),
        pos = math.random(15, 30),
        width = math.random(13, 17),
    }, function()
        if SucceededAttempts + 1 >= NeededAttempts then
            BreakCansProcess()
            Wait(500)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You begin pressing down the cans...', "success", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("PRESSING CANS", "You begin pressing down the cans...", 3500, "success")
            end   
            Wait(500)
            local skillup = 1
            local multiplier = math.random(1, 4)
            if multiplier > 3 then
                skillup = 8
            else
                skillup = 6
            end
            exports["mz-skills"]:UpdateSkill("Searching", skillup)
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
        else    
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = math.random(1200, 1500),
                pos = math.random(10, 30),
                width = math.random(11, 12),
            })
        end
    end, function()
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You apply too much force to the press and ruin the cans...', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("CANS RUINED", "You apply too much force to the press and ruin the cans...", 3500, "error")
            end
            Wait(500)
            local deteriorate = -2
            exports["mz-skills"]:UpdateSkill("Searching", deteriorate)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('-2 XP to Searching', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("SKILLS", "-2 XP to Searching", 3500, "error")
            end   
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
            craftprocesscheck = false
            ClearPedTasks(PlayerPedId())
    end)
end

function BreakCansProcess()
    QBCore.Functions.Progressbar("grind_coke", "Pressing down cans...", math.random(8000, 12000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent("mz-bins:server:GetAluminum")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        craftcheck = false
    end, function() -- Cancel
        openingDoor = false
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Process Cancelled', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("TASK STOPPED", "Process Cancelled", 3500, "error")
        end 
    end)
end

------------
--PLASTIC--
------------

RegisterNetEvent('mz-bins:client:BreakdownBottles')
AddEventHandler('mz-bins:client:BreakdownBottles', function()
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
        if result then
            TriggerServerEvent("mz-bins:server:BreakdownBottles")
        else
            local requiredItems = {
                [1] = {name = QBCore.Shared.Items["emptybottle"]["name"], image = QBCore.Shared.Items["emptybottle"]["image"]}, 
            }  
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You need empty bottles to crush...', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("NEED BOTTLES", "You need empty bottles to crush...", 3500, "error")
            end   
            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
            Wait(3000)
            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
        end
    end, {"emptybottle"})
end)

RegisterNetEvent('mz-bins:client:BreakdownBottlesMinigame')
AddEventHandler('mz-bins:client:BreakdownBottlesMinigame', function(source)
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    BreakdownBottlesMinigame(source)
end)

function BreakdownBottlesMinigame(source)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(3, 5)
    end
    local maxwidth = 30
    local maxduration = 3000
    Skillbar.Start({
        duration = math.random(1400, 1500),
        pos = math.random(15, 30),
        width = math.random(13, 17),
    }, function()
        if SucceededAttempts + 1 >= NeededAttempts then
            BreakBottlesProcess()
            Wait(500)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You begin crushing the plastic bottles...', "success", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("CRUSHING BOTTLES", "You begin crushing the plastic bottles...", 3500, "success")
            end   
            Wait(500)
            local skillup = 1
            local multiplier = math.random(1, 4)
            if multiplier > 3 then
                skillup = 8
            else
                skillup = 6
            end
            exports["mz-skills"]:UpdateSkill("Searching", skillup)
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
        else    
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = math.random(1200, 1500),
                pos = math.random(10, 30),
                width = math.random(11, 12),
            })
        end
    end, function()
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('Your hand slips and the plastic breaks into unusable parts...', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("BOTTLES RUINED", "Your hand slips and the plastic breaks into unusable parts...", 3500, "error")
            end
            Wait(500)
            local deteriorate = -2
            exports["mz-skills"]:UpdateSkill("Searching", deteriorate)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('-2 XP to Searching', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("SKILLS", "-2 XP to Searching", 3500, "error")
            end   
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
            craftprocesscheck = false
            ClearPedTasks(PlayerPedId())
    end)
end

function BreakBottlesProcess()
    QBCore.Functions.Progressbar("grind_coke", "Crushing bottles...", math.random(8000, 12000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent("mz-bins:server:GetPlastic")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        craftcheck = false
    end, function() -- Cancel
        openingDoor = false
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Process Cancelled', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("TASK STOPPED", "Process Cancelled", 3500, "error")
        end 
    end)
end

-------------
--PLASTIC 2--
-------------

RegisterNetEvent('mz-bins:client:BreakdownBottlecaps')
AddEventHandler('mz-bins:client:BreakdownBottlecaps', function()
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
        if result then
            TriggerServerEvent("mz-bins:server:BreakdownBottlecaps")
        else
            local requiredItems = {
                [1] = {name = QBCore.Shared.Items["bottlecaps"]["name"], image = QBCore.Shared.Items["bottlecaps"]["image"]}, 
            }  
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You need bottlecaps to process...', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("NEED BOTTLECAPS", "You need bottlecaps to process...", 3500, "error")
            end   
            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
            Wait(3000)
            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
        end
    end, {"bottlecaps"})
end)

RegisterNetEvent('mz-bins:client:BreakdownBottlecapsMinigame')
AddEventHandler('mz-bins:client:BreakdownBottlecapsMinigame', function(source)
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    BreakdownBottlecapsMinigame(source)
end)

function BreakdownBottlecapsMinigame(source)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(5, 7)
    end
    local maxwidth = 30
    local maxduration = 3000
    Skillbar.Start({
        duration = math.random(1200, 1500),
        pos = math.random(14, 30),
        width = math.random(12, 15),
    }, function()
        if SucceededAttempts + 1 >= NeededAttempts then
            BreakBottlesProcess()
            Wait(500)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You begin processing the bottlecaps...', "success", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("PROCESS BOTTLECAPS", "You begin processing the bottlecaps...", 3500, "success")
            end   
            Wait(500)
            local skillup = 1
            local multiplier = math.random(1, 4)
            if multiplier > 3 then
                skillup = 10
            else
                skillup = 7
            end
            exports["mz-skills"]:UpdateSkill("Searching", skillup)
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
        else    
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = math.random(1100, 1500),
                pos = math.random(10, 30),
                width = math.random(10, 12),
            })
        end
    end, function()
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('The bottlecaps pop under the pressure... Ruined...', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("BOTTLECAPS RUINED", "The bottlecaps pop under the pressure... Ruined...", 3500, "error")
            end
            Wait(500)
            local deteriorate = -2
            exports["mz-skills"]:UpdateSkill("Searching", deteriorate)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('-2 XP to Searching', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("SKILLS", "-2 XP to Searching", 3500, "error")
            end   
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
            craftprocesscheck = false
            ClearPedTasks(PlayerPedId())
    end)
end

function BreakBottlesProcess()
    QBCore.Functions.Progressbar("grind_coke", "Processing bottlecaps...", math.random(8000, 12000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent("mz-bins:server:GetPlastic2")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        craftcheck = false
    end, function() -- Cancel
        openingDoor = false
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Process Cancelled', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("TASK STOPPED", "Process Cancelled", 3500, "error")
        end 
    end)
end

---------
--GLASS--
---------

RegisterNetEvent('mz-bins:client:BreakdownCup')
AddEventHandler('mz-bins:client:BreakdownCup', function()
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
        if result then
            TriggerServerEvent("mz-bins:server:BreakdownCup")
        else
            local requiredItems = {
                [1] = {name = QBCore.Shared.Items["brokencup"]["name"], image = QBCore.Shared.Items["brokencup"]["image"]}, 
            }  
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You need something glass to process...', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("NEED GLASS", "You need something glass to process...", 3500, "error")
            end   
            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
            Wait(3000)
            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
        end
    end, {"brokencup"})
end)

RegisterNetEvent('mz-bins:client:BreakdownBrokencupMinigame')
AddEventHandler('mz-bins:client:BreakdownBrokencupMinigame', function(source)
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    BreakdownBrokencupMinigame(source)
end)

function BreakdownBrokencupMinigame(source)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(5, 7)
    end
    local maxwidth = 30
    local maxduration = 3000
    Skillbar.Start({
        duration = math.random(1200, 1500),
        pos = math.random(14, 30),
        width = math.random(12, 15),
    }, function()
        if SucceededAttempts + 1 >= NeededAttempts then
            BreakBrokencupProcess()
            Wait(500)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You begin crushing the scrap glass...', "success", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("PROCESS GLASS", "You begin crushing the scrap glass...", 3500, "success")
            end   
            Wait(500)
            local skillup = 1
            local multiplier = math.random(1, 4)
            if multiplier > 3 then
                skillup = 9
            else
                skillup = 6
            end
            exports["mz-skills"]:UpdateSkill("Searching", skillup)
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
        else    
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = math.random(1100, 1500),
                pos = math.random(10, 30),
                width = math.random(10, 12),
            })
        end
    end, function()
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('The glass shatters into unuseable pieces...', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("GLASS RUINED", "The glass shatters into unuseable pieces...", 3500, "error")
            end
            Wait(500)
            local deteriorate = -2
            exports["mz-skills"]:UpdateSkill("Searching", deteriorate)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('-2 XP to Searching', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("SKILLS", "-2 XP to Searching", 3500, "error")
            end   
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
            craftprocesscheck = false
            ClearPedTasks(PlayerPedId())
    end)
end

function BreakBrokencupProcess()
    QBCore.Functions.Progressbar("grind_coke", "Processing glass fragments...", math.random(10000, 14000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent("mz-bins:server:GetGlass")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        craftcheck = false
    end, function() -- Cancel
        openingDoor = false
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Process Cancelled', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("TASK STOPPED", "Process Cancelled", 3500, "error")
        end 
    end)
end

--------------
--SELL ITEMS--
--------------

RegisterNetEvent('mz-bins:client:menuSelect', function()
    local lvl8 = false
    local lvl7 = false
    local lvl6 = false
    local lvl5 = false
    local lvl4 = false
    local lvl3 = false
    local lvl2 = false
    local lvl1 = false
    local lvl0 = false

--Skill check call for config.menu prices on items
    
    exports["mz-skills"]:CheckSkill("Searching", 12800, function(hasskill)
        if hasskill then
            lvl8 = true
        end
    end)
    exports["mz-skills"]:CheckSkill("Searching", 6400, function(hasskill)
        if hasskill then
            lvl7 = true
        end
    end)
    exports["mz-skills"]:CheckSkill("Searching", 3200, function(hasskill)
        if hasskill then
            lvl6 = true
        end
    end)
    exports["mz-skills"]:CheckSkill("Searching", 1600, function(hasskill)
        if hasskill then
            lvl5 = true
        end
    end)
    exports["mz-skills"]:CheckSkill("Searching", 800, function(hasskill)
        if hasskill then
            lvl4 = true
        end
    end)
    exports["mz-skills"]:CheckSkill("Searching", 400, function(hasskill)
        if hasskill then
            lvl3 = true
        end
    end)
    exports["mz-skills"]:CheckSkill("Searching", 200, function(hasskill)
        if hasskill then
            lvl2 = true
        end
    end)
    exports["mz-skills"]:CheckSkill("Searching", 100, function(hasskill)
        if hasskill then
            lvl1 = true
        end
    end)
    exports["mz-skills"]:CheckSkill("Searching", 0, function(hasskill)
        if hasskill then
            lvl0 = true
        end
    end)

-- Menu call dependant on XP level

    if lvl8 == true then
        TriggerEvent('mz-bins:client:openMenu9')
        Wait(1000)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Woah, its the veteran diver, give them double on everything! (100% PREMIUM)', "info", 3500)
            Wait(500)
            QBCore.Functions.Notify('Woah, its the veteran diver, give them double on everything! (100% PREMIUM)', "info", 3500)
            Wait(500)
            QBCore.Functions.Notify('Woah, its the veteran diver, give them double on everything! (100% PREMIUM)', "info", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("VIP BONUS", "Woah, its the veteran diver, give them double on everything! (100% PREMIUM)", 3500, "info")
            Wait(500)
            exports['okokNotify']:Alert("VIP BONUS", "Woah, its the veteran diver, give them double on everything! (100% PREMIUM)", 3500, "info")
            Wait(500)
            exports['okokNotify']:Alert("VIP BONUS", "Woah, its the veteran diver, give them double on everything! (100% PREMIUM)", 3500, "info")
        end 
    elseif lvl7 == true then
        TriggerEvent('mz-bins:client:openMenu8')
        Wait(1000)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Hey, I\'ve seen you before, special prices for you. (75% PREMIUM)', "info", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("LOYALTY BONUS", "Hey, I\'ve seen you before, special buy prices for you. (75% PREMIUM)", 3500, "info")
        end 
    elseif lvl6 == true then
        TriggerEvent('mz-bins:client:openMenu7')
        Wait(1000)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Hey, I\'ve seen you before, special prices for you. (60% PREMIUM)', "info", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("LOYALTY BONUS", "Hey, I\'ve seen you before, special buy prices for you. (60% PREMIUM)", 3500, "info")
        end 
    elseif lvl5 == true then
        TriggerEvent('mz-bins:client:openMenu6')
        Wait(1000)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Hey, I\'ve seen you before, special prices for you. (50% PREMIUM)', "info", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("LOYALTY BONUS", "Hey, I\'ve seen you before, special buy prices for you. (50% PREMIUM)", 3500, "info")
        end 
    elseif lvl4 == true then
        TriggerEvent('mz-bins:client:openMenu5')
        Wait(1000)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Hey, I\'ve seen you before, special prices for you. (40% PREMIUM)', "info", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("LOYALTY BONUS", "Hey, I\'ve seen you before, special buy prices for you. (40% PREMIUM)", 3500, "info")
        end 
    elseif lvl3 == true then
        TriggerEvent('mz-bins:client:openMenu4')
        Wait(1000)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Hey, I\'ve seen you before, special prices for you. (30% PREMIUM)', "info", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("LOYALTY BONUS", "Hey, I\'ve seen you before, special buy prices for you. (30% PREMIUM)", 3500, "info")
        end 
    elseif lvl2 == true then
        TriggerEvent('mz-bins:client:openMenu3')
        Wait(1000)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Hey, I\'ve seen you before, special prices for you. (20% PREMIUM)', "info", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("LOYALTY BONUS", "Hey, I\'ve seen you before, special buy prices for you. (20% PREMIUM)", 3500, "info")
        end 
    elseif lvl1 == true then 
        TriggerEvent('mz-bins:client:openMenu2')
        Wait(1000)
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Hey, I\'ve seen you before, special prices for you. (10% PREMIUM)', "info", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("LOYALTY BONUS", "Hey, I\'ve seen you before, special buy prices for you. (10% PREMIUM)", 3500, "info")
        end 
    elseif lvl0 == true then
        TriggerEvent('mz-bins:client:openMenu')
    end
end)

RegisterNetEvent('mz-bins:client:openMenu', function()
    local pawnShop = {
        {
            header = "Trash 'n Treasure",
            isMenuHeader = true,
        },
        {
            header = "Your trash...",
            txt = "... is our treasure!",
            params = {
                event = "mz-bins:client:openPawn",
                args = {
                    items = Config.TrashItems
                }
            }
        }
    }
    exports['qb-menu']:openMenu(pawnShop)
end)

RegisterNetEvent('mz-bins:client:openMenu2', function()
    local pawnShop = {
        {
            header = "Trash 'n Treasure",
            isMenuHeader = true,
        },
        {
            header = "Your trash...",
            txt = "... is our treasure!",
            params = {
                event = "mz-bins:client:openPawn",
                args = {
                    items = Config.TrashItems2
                }
            }
        }
    }
    exports['qb-menu']:openMenu(pawnShop)
end)

RegisterNetEvent('mz-bins:client:openMenu3', function()
    local pawnShop = {
        {
            header = "Trash 'n Treasure",
            isMenuHeader = true,
        },
        {
            header = "Your trash...",
            txt = "... is our treasure!",
            params = {
                event = "mz-bins:client:openPawn",
                args = {
                    items = Config.TrashItems3
                }
            }
        }
    }
    exports['qb-menu']:openMenu(pawnShop)
end)

RegisterNetEvent('mz-bins:client:openMenu4', function()
    local pawnShop = {
        {
            header = "Trash 'n Treasure",
            isMenuHeader = true,
        },
        {
            header = "Your trash...",
            txt = "... is our treasure!",
            params = {
                event = "mz-bins:client:openPawn",
                args = {
                    items = Config.TrashItems4
                }
            }
        }
    }
    exports['qb-menu']:openMenu(pawnShop)
end)

RegisterNetEvent('mz-bins:client:openMenu5', function()
    local pawnShop = {
        {
            header = "Trash 'n Treasure",
            isMenuHeader = true,
        },
        {
            header = "Your trash...",
            txt = "... is our treasure!",
            params = {
                event = "mz-bins:client:openPawn",
                args = {
                    items = Config.TrashItems5
                }
            }
        }
    }
    exports['qb-menu']:openMenu(pawnShop)
end)

RegisterNetEvent('mz-bins:client:openMenu6', function()
    local pawnShop = {
        {
            header = "Trash 'n Treasure",
            isMenuHeader = true,
        },
        {
            header = "Your trash...",
            txt = "... is our treasure!",
            params = {
                event = "mz-bins:client:openPawn",
                args = {
                    items = Config.TrashItems6
                }
            }
        }
    }
    exports['qb-menu']:openMenu(pawnShop)
end)

RegisterNetEvent('mz-bins:client:openMenu7', function()
    local pawnShop = {
        {
            header = "Trash 'n Treasure",
            isMenuHeader = true,
        },
        {
            header = "Your trash...",
            txt = "... is our treasure!",
            params = {
                event = "mz-bins:client:openPawn",
                args = {
                    items = Config.TrashItems7
                }
            }
        }
    }
    exports['qb-menu']:openMenu(pawnShop)
end)

RegisterNetEvent('mz-bins:client:openMenu8', function()
    local pawnShop = {
        {
            header = "Trash 'n Treasure",
            isMenuHeader = true,
        },
        {
            header = "Your trash...",
            txt = "... is our treasure!",
            params = {
                event = "mz-bins:client:openPawn",
                args = {
                    items = Config.TrashItems8
                }
            }
        }
    }
    exports['qb-menu']:openMenu(pawnShop)
end)

RegisterNetEvent('mz-bins:client:openPawn', function(data)
    QBCore.Functions.TriggerCallback('mz-bins:server:getInv', function(inventory)
        local PlyInv = inventory
        local pawnMenu = {
            {
                header = "Trash 'n Treasure",
                isMenuHeader = true,
            }
        }
        for _, v in pairs(PlyInv) do
            for i = 1, #data.items do
                if v.name == data.items[i].item then
                    pawnMenu[#pawnMenu + 1] = {
                        header = QBCore.Shared.Items[v.name].label,
                        txt = Lang:t('info.sell_items', { value = data.items[i].price }),
                        params = {
                            event = 'mz-bins:client:pawnitems',
                            args = {
                                label = QBCore.Shared.Items[v.name].label,
                                price = data.items[i].price,
                                name = v.name,
                                amount = v.amount
                            }
                        }
                    }
                end
            end
        end
        pawnMenu[#pawnMenu + 1] = {
            header = Lang:t('info.back'),
            params = {
                event = 'mz-bins:client:openMenu'
            }
        }
        exports['qb-menu']:openMenu(pawnMenu)
    end)
end)

RegisterNetEvent('mz-bins:client:pawnitems', function(item)
    local sellingItem = exports['qb-input']:ShowInput({
        header = Lang:t('info.title'),
        submitText = Lang:t('info.sell'),
        inputs = {
            {
                type = 'number',
                isRequired = false,
                name = 'amount',
                text = Lang:t('info.max', { value = item.amount })
            }
        }
    })
    if sellingItem then
        if not sellingItem.amount then
            return
        end
        if tonumber(sellingItem.amount) > 0 then
            TriggerServerEvent('mz-bins:server:sellTrashItems', item.name, sellingItem.amount, item.price)
        else
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('error.negative'), 'error')
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("NEGATIVE?", "You cannot sell a negative amount...", 3500, "error")
            end 
        end
    end
end)

-------------
--FUNCTIONS--
-------------

CreateThread(function()
    exports['qb-target']:AddTargetModel(Config.Objects, {
        options = {
            {
              type = "client",
              event = "mz-bins:SearchBin",
              parameters = {},
              icon = "fas fa-search",
              label = "Search through trash"
            },
        },
    distance = 1.0
    })  
 end)

 CreateThread(function()
    exports['qb-target']:AddBoxZone("BinParts", vector3(-1156.22, -1999.3, 13.18), 3.8, 1, {
        name = "BinParts",
        heading = 314,
        debugPoly = false,
        minZ = 9.78,
        maxZ = 13.78,
        }, {
            options = { 
            {
                type = "client",
                event = "mz-bins:client:BreakdownCans",
                icon = 'fas fa-compress-alt',
                label = 'Process old cans'
            },
            {
                type = "client",
                event = "mz-bins:client:BreakdownBottles",
                icon = 'fas fa-wine-bottle',
                label = 'Crush empty bottles'
            },
            {
                type = "client",
                event = "mz-bins:client:BreakdownBottlecaps",
                icon = 'fa-solid fa-circle',
                label = 'Process bottlecaps'
            },
            {
                type = "client",
                event = "mz-bins:client:BreakdownCup",
                icon = 'fas fa-glass',
                label = 'Process glass'
            },
        },
        distance = 1.2,
    })
end)

CreateThread(function()
    exports['qb-target']:AddBoxZone("sellbinitems", vector3(1703.29, 3779.5, 34.75), 1.2, 0.5, {
        name = "sellbinitems",
        heading = 125,
        debugPoly = false,
        minZ = 32.15,
        maxZ = 36.15,
        }, {
            options = { 
            {
                type = "client",
                event = "mz-bins:client:menuSelect",
                icon = 'fas fa-trash',
                label = 'Sell Items'
            },
        },
        distance = 1.5,
     })
end)

CreateThread(function()
    for _, value in pairs(Config.SellLocation) do
        local blip = AddBlipForCoord(value.coords.x, value.coords.y, value.coords.z)
        SetBlipSprite(blip, 374)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.7)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 8)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Lang:t('info.title'))
        EndTextCommandSetBlipName(blip)
    end
end)