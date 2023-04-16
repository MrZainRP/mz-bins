local QBCore = exports['qb-core']:GetCoreObject()

local PlayerData = {}
local isLoggedIn = false
local percent = false
local searching = false
local isInVehicle = false
local NeededAttempts = 0
local SucceededAttempts = 0
local FailedAttemps = 0
local craftcheck = false
local craftprocesscheck = false

local binparse 

local hascans = false 
local hasbottles = false 
local hasbottlecaps = false 
local hascups = false 

cachedBins = {}

closestBin = {
    'prop_dumpster_01a', 
    'prop_dumpster_02a',
    'prop_dumpster_02b',
    'prop_dumpster_3a'
}

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then
        PlayerJob = QBCore.Functions.GetPlayerData().job
        TriggerEvent('mz-bins:client:NoCrafting')
        while binparse do 
            if QBCore.Functions.HasItem("sodacan") then
                hascans = true 
            else 
                hascans = false 
            end
            if QBCore.Functions.HasItem("emptybottle") then
                hasbottles = true 
            else 
                hasbottles = false  
            end
            if QBCore.Functions.HasItem("bottlecaps") then
                hasbottlecaps = true 
            else 
                hasbottlecaps = false 
            end
            if QBCore.Functions.HasItem("brokencup") then
                hascups = true
            else 
                hascups = false 
            end
            Wait(2000)
        end 
    end
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    isLoggedIn = true
end)

CreateThread(function()
    exports['qb-target']:AddBoxZone("craftbinparts", vector3(-1156.22, -1999.3, 13.18), 3.8, 1, {
        name = "craftbinparts",
        heading = 314,
        debugPoly = false,
        minZ = 9.78,
        maxZ = 13.78,
        }, {
            options = { 
            {
                num = 1, 
                type = "client",
                event = "mz-bins:client:BreakdownCans",
                icon = 'fas fa-compress-alt',
                label = 'Process old cans',
                canInteract = function()
                    return hascans
                end,
            },
            {
                num = 2,
                type = "client",
                event = "mz-bins:client:BreakdownBottles",
                icon = 'fas fa-wine-bottle',
                label = 'Crush empty bottles',
                canInteract = function()
                    return hasbottles
                end,
            },
            {
                num = 3,
                type = "client",
                event = "mz-bins:client:BreakdownBottlecaps",
                icon = 'fa-solid fa-circle',
                label = 'Process bottlecaps',
                canInteract = function()
                    return hasbottlecaps
                end,
            },
            {
                num = 4,
                type = "client",
                event = "mz-bins:client:BreakdownCup",
                icon = 'fas fa-glass',
                label = 'Process glass',
                canInteract = function()
                    return hascups
                end,
            },
            {
                num = 5,
                type = "client",
                event = "mz-bins:client:NoCrafting",
                icon = 'fas fa-glass',
                label = 'Do you have materials to process?',
                canInteract = function()
                    return (not hascans) and (not hasbottles) and (not hascups) and (not hasbottlecaps)
                end,
            },
        },
        distance = 1.2,
    })
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

RegisterNetEvent("mz-bins:SearchBin", function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    for i = 1, #closestBin do
        local x = GetClosestObjectOfType(playerCoords, 1.0, GetHashKey(closestBin[i]), false, false, false)
        local entity = nil
        if DoesEntityExist(x) and not IsPedSittingInAnyVehicle(PlayerPedId()) then
            entity = x
            if not cachedBins[entity] then
                if not searching then 
                    searching = true
                    if Config.skillcheck then 
                        exports['ps-ui']:Circle(function(success)
                            if success then
                                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                                openBin(entity)
                                Wait(2000)
                                if Config.mzskills then 
                                    local BetterXP = math.random(Config.diveXPlow, Config.diveXPhigh)
                                    local xpmultiple = math.random(1, 4)
                                    if xpmultiple > 3 then
                                        chance = BetterXP
                                    elseif xpmultiple < 4 then
                                        chance = Config.diveXPlow
                                    end
                                    exports["mz-skills"]:UpdateSkill(Config.BinSkill, chance)
                                end
                            else
                                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                                if Config.NotifyType == 'qb' then
                                    QBCore.Functions.Notify(Lang:t('error.skillfail'), "error", 3500)
                                elseif Config.NotifyType == 'okok' then 
                                    exports['okokNotify']:Alert(Lang:t('label.skillfail'), Lang:t('error.skillfail'), 3500, "error")
                                end
                                Wait(1000)
                                if Config.mzskills then 
                                    local deteriorate = -Config.diveXPloss
                                    exports["mz-skills"]:UpdateSkill(Config.BinSkill, deteriorate)
                                    Wait(800)
                                    if Config.NotifyType == 'qb' then
                                        QBCore.Functions.Notify(Lang:t('error.xpdown', {value = Config.diveXPloss, value2 = Config.BinSkill}), "error", 3500)
                                    elseif Config.NotifyType == "okok" then
                                        exports['okokNotify']:Alert(Lang:t('label.mzskills'), Lang:t('error.xpdown', {value = Config.diveXPloss, value2 = Config.BinSkill}), 3500, "error")
                                    end
                                end
                                searching = false 
                            end
                        end, Config.diveparse, Config.diveparsetime)
                    elseif not Config.skillcheck then 
                        openBin(entity)
                        Wait(2000)
                        if Config.mzskills then 
                            local BetterXP = math.random(Config.diveXPlow, Config.diveXPhigh)
                            local xpmultiple = math.random(1, 4)
                            if xpmultiple > 3 then
                                chance = BetterXP
                            elseif xpmultiple < 4 then
                                chance = Config.diveXPlow
                            end
                            exports["mz-skills"]:UpdateSkill(Config.BinSkill, chance)
                        end
                    end
                else
                    if Config.NotifyType == 'qb' then
                        QBCore.Functions.Notify(Lang:t('error.doingtask'),"error", 3500)
                    elseif Config.NotifyType == "okok" then
                        exports['okokNotify']:Alert(Lang:t('label.doingtask'), Lang:t('error.doingtask'), 3500, "error")
                    end
                end
            else
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify(Lang:t('error.searched'),"error", 3500)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert(Lang:t('label.searched'), Lang:t('error.searched'), 3500, "error")
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

local binCheck = true 

openBin = function(entity)
    local LowTime = (Config.SearchTimeLow * 1000)
    local HighTime = (Config.SearchTimeHigh * 1000)
    local searchtime = math.random(LowTime, HighTime)
    QBCore.Functions.Progressbar("search_register", Lang:t('progress.searching'), searchtime, false, true, {
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
        if Config.FailEnabled then 
            local bindivechance = math.random(1, 100)
            if Config.FailChance >= bindivechance then  
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify(Lang:t('error.failfind'), "error", 3500)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert(Lang:t('label.failfind'), Lang:t('error.failfind'), 3500, "error")
                end 
                searching = false   
            else 
                binCheck = false 
                QBCore.Functions.TriggerCallback('mz-bins:getItem', function(result, binCheck)
                end)
                binCheck = true 
                if Config.rareitems then 
                    Wait(1000)
                    binCheck = false 
                    TriggerServerEvent('mz-bins:server:GetItemRare', binCheck)
                    binCheck = true 
                end
                searching = false 
            end
        elseif not Config.FailEnabled then
            binCheck = false 
            QBCore.Functions.TriggerCallback('mz-bins:getItem', function(result, binCheck)
            end)
            binCheck = true
            if Config.rareitems then 
                Wait(1000)
                binCheck = false
                TriggerServerEvent('mz-bins:server:GetItemRare', binCheck)
                binCheck = false
            end
            searching = false  
        end
        ClearPedTasks(PlayerPedId())
        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_bin@base", "base", 1.0)
        searching = false
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "amb@prop_human_bum_bin@base", "base", 1.0)
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify(Lang:t('error.cancelled'), "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert(Lang:t('label.cancelled'), Lang:t('error.cancelled'), 3500, "error")
        end  
        searching = false      
    end)
end

------------
--CRAFTING--
------------

local Working = false

--------------------
--BREAK DOWN PARTS--
--------------------

RegisterNetEvent('mz-bins:client:emoteCancel', function()
    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
end)

------------
--ALUMINUM--
------------

RegisterNetEvent('mz-bins:client:BreakdownCans', function()
    if not Working then 
        if QBCore.Functions.HasItem("sodacan") then
            TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
            TriggerServerEvent("mz-bins:server:BreakdownCans")
        else
            hascans = false
            local requiredItems = {
                [1] = {name = QBCore.Shared.Items["sodacan"]["name"], image = QBCore.Shared.Items["sodacan"]["image"]}, 
            }  
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('error.needcans'),"error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.needcans'), Lang:t('error.needcans'), 3500, "error")
            end  
            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
            Wait(3000)
            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
        end
    else 
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify(Lang:t('error.doingtask'),"error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert(Lang:t('label.doingtask'), Lang:t('error.doingtask'), 3500, "error")
        end  
    end 
end)

RegisterNetEvent('mz-bins:client:BreakdownCansMinigame', function(source)
    Working = true
    hascans = false
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    if Config.CraftSkillCheck then 
        BreakdownCansMinigame(source)
    else 
        BreakCansProcess()
    end 
end)

function BreakdownCansMinigame(source)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(Config.canslow, Config.canshigh)
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
                QBCore.Functions.Notify(Lang:t('success.presscans'), "success", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.presscans'), Lang:t('success.presscans'), 3500, "success")
            end    
            Wait(500)
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
            QBCore.Functions.Notify(Lang:t('error.cansruined'),"error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert(Lang:t('label.cansruined'), Lang:t('error.cansruined'), 3500, "error")
        end 
        Wait(500)
        if Config.mzskills then 
            local deteriorate = -Config.cansXPloss
            exports["mz-skills"]:UpdateSkill(Config.BinSkill, deteriorate)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('error.cansxpdown', {value = Config.cansXPloss, value2 = Config.BinSkill}), "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.mzskills'), Lang:t('error.cansxpdown', {value = Config.cansXPloss, value2 = Config.BinSkill}), 3500, "error")
            end 
        end
        FailedAttemps = 0
        SucceededAttempts = 0
        NeededAttempts = 0
        craftprocesscheck = false
        Working = false
        ClearPedTasks(PlayerPedId())
    end)
end

local alumniumCheck = true 

function BreakCansProcess()
    local canstime = math.random(Config.canstimelow*1000, Config.canstimehigh*1000)
    QBCore.Functions.Progressbar("grind_coke", Lang:t('progress.canspress'), canstime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        alumniumCheck = false
        TriggerServerEvent("mz-bins:server:GetAluminum", alumniumCheck)
        alumniumCheck = true
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        Working = false
        Wait(1000)
        if Config.mzskills then 
            local BetterXP = math.random(Config.cansXPlow, Config.cansXPhigh)
            local multiplier = math.random(1, 4)
            if multiplier >= 3 then
                skillup = BetterXP
            else
                skillup = Config.cansXPlow
            end
            exports["mz-skills"]:UpdateSkill(Config.BinSkill, skillup)
        end
        craftcheck = false
    end, function() -- Cancel
        Working = false
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify(Lang:t('error.cancelled'), "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert(Lang:t('label.cancelled'), Lang:t('error.cancelled'), 3500, "error")
        end  
    end)
end

------------
--PLASTIC--
------------

local plasticCheck = true

RegisterNetEvent('mz-bins:client:BreakdownBottles', function()
    if not Working then 
        if QBCore.Functions.HasItem("emptybottle") then
            TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
            TriggerServerEvent("mz-bins:server:BreakdownBottles")
        else
            hasbottles = false 
            local requiredItems = {
                [1] = {name = QBCore.Shared.Items["emptybottle"]["name"], image = QBCore.Shared.Items["emptybottle"]["image"]}, 
            }  
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('error.needbottles'), "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.needbottles'), Lang:t('error.needbottles'), 3500, "error")
            end   
            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
            Wait(3000)
            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
        end
    else 
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify(Lang:t('error.doingtask'),"error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert(Lang:t('label.doingtask'), Lang:t('error.doingtask'), 3500, "error")
        end 
    end 
end)

RegisterNetEvent('mz-bins:client:BreakdownBottlesMinigame', function(source)
    Working = true
    hasbottles = false
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    if Config.CraftSkillCheck then 
        BreakdownBottlesMinigame(source)
    else 
        BreakBottlesProcess()
    end
end)

function BreakdownBottlesMinigame(source)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(Config.bottleslow, Config.bottleshigh)
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
                QBCore.Functions.Notify(Lang:t('success.crushbottles'), "success", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.crushbottles'), Lang:t('success.crushbottles'), 3500, "success")
            end   
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
            QBCore.Functions.Notify(Lang:t('error.bottlesruined'),"error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert(Lang:t('label.bottlesruined'), Lang:t('error.bottlesruined'), 3500, "error")
        end 
        Wait(500)
        if Config.mzskills then 
            local deteriorate = -Config.bottlesXPloss
            exports["mz-skills"]:UpdateSkill(Config.BinSkill, deteriorate)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('error.bottlesxpdown', {value = Config.bottlesXPloss, value2 = Config.BinSkill}), "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.mzskills'), Lang:t('error.bottlesxpdown', {value = Config.bottlesXPloss, value2 = Config.BinSkill}), 3500, "error")
            end  
        end
        FailedAttemps = 0
        SucceededAttempts = 0
        NeededAttempts = 0
        craftprocesscheck = false
        Working = false 
        ClearPedTasks(PlayerPedId())
    end)
end

function BreakBottlesProcess()
    local bottlestime = math.random(Config.bottlestimelow*1000, Config.bottlestimehigh*1000)
    QBCore.Functions.Progressbar("grind_coke", Lang:t('progress.crushbottles'), bottlestime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        plasticCheck = false 
        TriggerServerEvent("mz-bins:server:GetPlastic", plasticCheck)
        plasticCheck = true
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        craftcheck = false
        Working = false 
        Wait(500)
        if Config.mzskills then 
            local BetterXP = math.random(Config.bottlesXPlow, Config.bottlesXPhigh)
            local multiplier = math.random(1, 4)
            if multiplier >= 3 then
                skillup = BetterXP
            else
                skillup = Config.bottlesXPlow
            end
            exports["mz-skills"]:UpdateSkill(Config.BinSkill, skillup)
        end
    end, function() -- Cancel
        Working = false
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify(Lang:t('error.cancelled'), "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert(Lang:t('label.cancelled'), Lang:t('error.cancelled'), 3500, "error")
        end  
    end)
end

-------------
--PLASTIC 2--
-------------

RegisterNetEvent('mz-bins:client:BreakdownBottlecaps', function()
    if not Working then 
        if QBCore.Functions.HasItem("bottlecaps") then
            TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
            TriggerServerEvent("mz-bins:server:BreakdownBottlecaps")
        else
            hasbottlecaps = false
            local requiredItems = {
                [1] = {name = QBCore.Shared.Items["bottlecaps"]["name"], image = QBCore.Shared.Items["bottlecaps"]["image"]}, 
            }  
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('error.needcaps'), "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.needcaps'), Lang:t('error.needcaps'), 3500, "error")
            end   
            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
            Wait(3000)
            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
        end
    else 
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify(Lang:t('error.doingtask'),"error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert(Lang:t('label.doingtask'), Lang:t('error.doingtask'), 3500, "error")
        end
    end
end)

RegisterNetEvent('mz-bins:client:BreakdownBottlecapsMinigame', function(source)
    Working = true
    hasbottlecaps = false
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    if Config.CraftSkillCheck then
        BreakdownBottlecapsMinigame(source)
    else 
        BreakBottlesProcess()
    end
end)

function BreakdownBottlecapsMinigame(source)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(Config.bottlecapslow, Config.bottlecapshigh)
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
                QBCore.Functions.Notify(Lang:t('success.processcaps'), "success", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.processcaps'), Lang:t('success.processcaps'), 3500, "success")
            end   
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
            QBCore.Functions.Notify(Lang:t('error.capsruined'),"error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert(Lang:t('label.capsruined'), Lang:t('error.capsruined'), 3500, "error")
        end
        Wait(500)
        if Config.mzskills then 
            local deteriorate = -Config.bottlecapsXPloss
            exports["mz-skills"]:UpdateSkill(Config.BinSkill, deteriorate)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('error.capsxpdown', {value = Config.bottlecapsXPloss, value2 = Config.BinSkill}), "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.mzskills'), Lang:t('error.capsxpdown', {value = Config.bottlecapsXPloss, value2 = Config.BinSkill}), 3500, "error")
            end    
        end
        FailedAttemps = 0
        SucceededAttempts = 0
        NeededAttempts = 0
        craftprocesscheck = false
        Working = false 
        ClearPedTasks(PlayerPedId())
    end)
end

function BreakBottlesProcess()
    local bottlecapstime = math.random(Config.bottlecapstimelow*1000, Config.bottlecapstimehigh*1000)
    QBCore.Functions.Progressbar("grind_coke", Lang:t('progress.processcaps'), bottlecapstime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        plasticCheck = false
        TriggerServerEvent("mz-bins:server:GetPlastic2", plasticCheck)
        plasticCheck = true 
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        Working = false 
        craftcheck = false
        Wait(500)
        if Config.mzskills then 
            local BetterXP = math.random(Config.bottlecapsXPlow, Config.bottlecapsXPhigh)
            local multiplier = math.random(1, 4)
            if multiplier >= 3 then
                skillup = BetterXP
            else
                skillup = Config.bottlecapsXPlow
            end
            exports["mz-skills"]:UpdateSkill(Config.BinSkill, skillup)
        end
    end, function() -- Cancel
        openingDoor = false
        Working = false
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify(Lang:t('error.cancelled'), "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert(Lang:t('label.cancelled'), Lang:t('error.cancelled'), 3500, "error")
        end  
    end)
end

---------
--GLASS--
---------

local glassCheck = true

RegisterNetEvent('mz-bins:client:BreakdownCup', function() 
    if not Working then 
        if QBCore.Functions.HasItem("brokencup") then
            TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
            TriggerServerEvent("mz-bins:server:BreakdownCup")
        else
            hascups = false 
            local requiredItems = {
                [1] = {name = QBCore.Shared.Items["brokencup"]["name"], image = QBCore.Shared.Items["brokencup"]["image"]}, 
            }  
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('error.needcups'),"error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.needcups'), Lang:t('error.needcups'), 3500, "error")
            end
            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
            Wait(3000)
            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
        end
    else 
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify(Lang:t('error.doingtask'),"error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert(Lang:t('label.doingtask'), Lang:t('error.doingtask'), 3500, "error")
        end 
    end
end)

RegisterNetEvent('mz-bins:client:BreakdownBrokencupMinigame', function(source)
    Working = true
    hascups = false
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    if Config.CraftSkillCheck then
        BreakdownBrokencupMinigame(source)
    else 
        BreakBrokencupProcess()
    end
end)

function BreakdownBrokencupMinigame(source)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(Config.brokencuplow, Config.brokencuphigh)
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
                QBCore.Functions.Notify(Lang:t('success.workcups'),"error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.workcups'), Lang:t('success.workcups'), 3500, "error")
            end
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
            QBCore.Functions.Notify(Lang:t('error.cupsruined'),"error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert(Lang:t('label.cupsruined'), Lang:t('error.cupsruined'), 3500, "error")
        end 
        Wait(500)
        if Config.mzskills then 
            local deteriorate = -Config.brokencupXPloss
            exports["mz-skills"]:UpdateSkill(Config.BinSkill, deteriorate)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('error.cupsxpdown', {value = Config.brokencupXPloss, value2 = Config.BinSkill}), "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.mzskills'), Lang:t('error.cupsxpdown', {value = Config.brokencupXPloss, value2 = Config.BinSkill}), 3500, "error")
            end    
        end 
        FailedAttemps = 0
        SucceededAttempts = 0
        NeededAttempts = 0
        craftprocesscheck = false
        Working = false 
        ClearPedTasks(PlayerPedId())
    end)
end

function BreakBrokencupProcess()
    local brokencuptime = math.random(Config.brokencuptimelow*1000, Config.brokencuptimehigh*1000)
    QBCore.Functions.Progressbar("grind_coke", Lang:t('progress.processcups'), brokencuptime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        glassCheck = false
        TriggerServerEvent("mz-bins:server:GetGlass", glassCheck)
        glassCheck = true
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        craftcheck = false
        Working = false 
        Wait(500)
        if Config.mzskills then 
            local BetterXP = math.random(Config.brokencupXPlow, Config.brokencupXPhigh)
            local multiplier = math.random(1, 4)
            if multiplier >= 3 then
                skillup = BetterXP
            else
                skillup = Config.brokencupXPlow
            end
            exports["mz-skills"]:UpdateSkill(Config.BinSkill, skillup)
        end
    end, function() -- Cancel
        Working = false 
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify(Lang:t('error.cancelled'), "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert(Lang:t('label.cancelled'), Lang:t('error.cancelled'), 3500, "error")
        end  
    end)
end

------------
--NO CRAFT--
------------

local loadparse = true

RegisterNetEvent('mz-bins:client:NoCrafting', function()
    if QBCore.Functions.HasItem("sodacan") then
        hascans = true 
    end
    if QBCore.Functions.HasItem("emptybottle") then
        hasbottles = true 
    end
    if QBCore.Functions.HasItem("bottlecaps") then
        hasbottlecaps = true 
    end
    if QBCore.Functions.HasItem("brokencup") then
        hascups = true 
    end
    if not loadparse then 
        if hascans or hasbottles or hasbottlecaps or hascups then 
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('success.yescraft'),"success", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.yescraft'), Lang:t('success.yescraft'), 3500, "success")
            end 
        else 
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('error.nocraft'),"error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.nocraft'), Lang:t('error.nocraft'), 3500, "error")
            end 
        end 
    end 
    loadparse = false 
end)

--------------
--SELL ITEMS--
--------------

RegisterNetEvent('mz-bins:client:menuSelect', function()
    if Config.mzskills then 
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
        exports["mz-skills"]:CheckSkill(Config.BinSkill, 12800, function(hasskill)
            if hasskill then lvl8 = true end
        end)
        exports["mz-skills"]:CheckSkill(Config.BinSkill, 6400, function(hasskill)
            if hasskill then lvl7 = true end
        end)
        exports["mz-skills"]:CheckSkill(Config.BinSkill, 3200, function(hasskill)
            if hasskill then lvl6 = true end
        end)
        exports["mz-skills"]:CheckSkill(Config.BinSkill, 1600, function(hasskill)
            if hasskill then lvl5 = true end
        end)
        exports["mz-skills"]:CheckSkill(Config.BinSkill, 800, function(hasskill)
            if hasskill then lvl4 = true end
        end)
        exports["mz-skills"]:CheckSkill(Config.BinSkill, 400, function(hasskill)
            if hasskill then lvl3 = true end
        end)
        exports["mz-skills"]:CheckSkill(Config.BinSkill, 200, function(hasskill)
            if hasskill then lvl2 = true end
        end)
        exports["mz-skills"]:CheckSkill(Config.BinSkill, 100, function(hasskill)
            if hasskill then lvl1 = true end
        end)
        exports["mz-skills"]:CheckSkill(Config.BinSkill, 0, function(hasskill)
            if hasskill then lvl0 = true end
        end)
        if lvl8 then
            TriggerEvent('mz-bins:client:openMenu9')
            Wait(1000)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('info.menu9'),"info", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.menu9'), Lang:t('info.menu9'), 3500, "info")
            end
        elseif lvl7 then
            TriggerEvent('mz-bins:client:openMenu8')
            Wait(1000)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('info.menu8'),"info", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.menu8'), Lang:t('info.menu8'), 3500, "info")
            end
        elseif lvl6 then
            TriggerEvent('mz-bins:client:openMenu7')
            Wait(1000)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('info.menu7'),"info", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.menu7'), Lang:t('info.menu7'), 3500, "info")
            end 
        elseif lvl5 then
            TriggerEvent('mz-bins:client:openMenu6')
            Wait(1000)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('info.menu6'),"info", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.menu6'), Lang:t('info.menu6'), 3500, "info")
            end 
        elseif lvl4 then
            TriggerEvent('mz-bins:client:openMenu5')
            Wait(1000)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('info.menu5'),"info", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.menu5'), Lang:t('info.menu5'), 3500, "info")
            end 
        elseif lvl3 then
            TriggerEvent('mz-bins:client:openMenu4')
            Wait(1000)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('info.menu4'),"info", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.menu4'), Lang:t('info.menu4'), 3500, "info")
            end  
        elseif lvl2 then
            TriggerEvent('mz-bins:client:openMenu3')
            Wait(1000)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('info.menu3'),"info", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.menu3'), Lang:t('info.menu3'), 3500, "info")
            end 
        elseif lvl1 then 
            TriggerEvent('mz-bins:client:openMenu2')
            Wait(1000)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify(Lang:t('info.menu2'),"info", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Lang:t('label.menu2'), Lang:t('info.menu2'), 3500, "info")
            end 
        elseif lvl0 then
            TriggerEvent('mz-bins:client:openMenu')
        end
    elseif not Config.mzskills then 
        TriggerEvent('mz-bins:client:openMenuNOXP')
    end
end)

RegisterNetEvent('mz-bins:client:openMenuNOXP', function()
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
                    items = Config.TrashItemsNOXP
                }
            }
        }
    }
    exports['qb-menu']:openMenu(pawnShop)
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
                exports['okokNotify']:Alert(Lang:t('label.negative'), Lang:t('error.negative'), 3500, "error")
            end 
        end
    end
end)

-----------
--WALLETS--
-----------

RegisterNetEvent('mz-bins:client:walletOpen', function(itemName)
    TriggerEvent('animations:client:EmoteCommandStart', {"makeitrain"})
    QBCore.Functions.Progressbar("drink_something", "Opening Wallet", 3500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent("mz-bins:server:walletReward")
    end)
end)

------------
--BOXZONES--
------------

CreateThread(function()
    exports['qb-target']:AddTargetModel(Config.Objects, {
        options = {
            {
              type = "client",
              event = "mz-bins:SearchBin",
              parameters = {},
              icon = "fas fa-search",
              label = "Search through trash",
              job = {
                ["unemployed"] = 0,
                ["police"] = 0,
                ["ambulance"] = 0,
                ['realestate'] = 0,
                ['taxi'] = 0,
                ['bus'] = 0, 
                ['cardealer'] = 0, 
                ['mechanic'] = 0, 
                ['judge'] = 0, 
                ['lawyer'] = 0,
                ['reporter'] = 0,
                ['tow'] = 0,
                ['vineyard'] = 0,
                ['hotdog'] = 0,
                }
            },
        },
    distance = 1.0
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