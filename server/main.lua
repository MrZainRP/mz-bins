local QBCore = exports['qb-core']:GetCoreObject()

local ItemList = {
    ["sodacan"] = "sodacan",
    ["emptybottle"] = "emptybottle",
    ["bottlecaps"] = "bottlecaps",
    ["brokencup"] = "brokencup",
    ["wallet"] = "wallet",
}

QBCore.Functions.CreateCallback('mz-bins:getItem', function(source, cb)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local chance = math.random(1, 200)
    if chance > 0 and chance < 50 then
        Player.Functions.AddItem(QBCore.Shared.Items["sodacan"].name, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["sodacan"], "add")
    elseif chance > 49 and chance < 71 then
        Player.Functions.AddItem(QBCore.Shared.Items["bottlecaps"].name, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["bottlecaps"], "add")
    elseif chance > 70 and chance < 91 then
        Player.Functions.AddItem(QBCore.Shared.Items["emptybottle"].name, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["emptybottle"], "add")
    elseif chance > 90 and chance < 116 then
        Player.Functions.AddItem(QBCore.Shared.Items["brokencup"].name, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["brokencup"], "add")
    elseif chance > 115 and chance < 136 then
        Player.Functions.AddItem(QBCore.Shared.Items["ace"].name, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["ace"], "add")
    elseif chance > 135 and chance < 156 then
        Player.Functions.AddItem(QBCore.Shared.Items["crayons"].name, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["crayons"], "add")
    elseif chance > 155 and chance < 166 then
        Player.Functions.AddItem(QBCore.Shared.Items["sunglasses"].name, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["sunglasses"], "add")
    elseif chance > 166 and chance < 175 then
        Player.Functions.AddItem(QBCore.Shared.Items["teddy"].name, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["teddy"], "add")
    elseif chance > 174 and chance < 182 then
        Player.Functions.AddItem(QBCore.Shared.Items["fabric"].name, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["fabric"], "add")
    elseif chance > 181 and chance < 186 then
        Player.Functions.AddItem(QBCore.Shared.Items["actiontoy"].name, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["actiontoy"], "add")
    elseif chance > 185 and chance < 194 then
        Player.Functions.AddItem(QBCore.Shared.Items["bulletcasing"].name, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["bulletcasing"], "add")
    elseif chance > 193 and chance < 197 then
        Player.Functions.AddItem(QBCore.Shared.Items[Config.Rareitem1].name, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Rareitem1], "add")
    elseif chance > 196 and chance < 199 then
        Player.Functions.AddItem(QBCore.Shared.Items[Config.Rareitem2].name, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Rareitem2], "add")
    elseif chance == 199 then
        Player.Functions.AddItem(QBCore.Shared.Items[Config.Rareitem3].name, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Rareitem3], "add")
    elseif chance == 200 then
        Player.Functions.AddItem(QBCore.Shared.Items[Config.Rareitem4].name, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Rareitem4], "add")
    end
    Wait(100)
    if Config.NotifyType == 'qb' then
        TriggerClientEvent('QBCore:Notify', src, "This might be useful, nice!", 'success')
    elseif Config.NotifyType == "okok" then
        TriggerClientEvent('okokNotify:Alert', source, "YOU FOUND SOMETHING!", "This might be useful, nice!", 3500, 'success')
    end
end)

RegisterServerEvent('mz-bins:getItem')
AddEventHandler('mz-bins:getItem', function()
    QBCore.Functions.BanInjection(source, 'mz-bins (getItem)')
end)

------------
--CRAFTING--
------------

--------------------
--BREAK DOWN PARTS--
--------------------

------------
--ALUMINUM--
------------

RegisterServerEvent('mz-bins:server:BreakdownCans')
AddEventHandler('mz-bins:server:BreakdownCans', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local sodacan = Player.Functions.GetItemByName('sodacan')
    if Player.PlayerData.items ~= nil then 
        if sodacan ~= nil then 
            if sodacan.amount >= 3 then 
                Player.Functions.RemoveItem("sodacan", 3)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['sodacan'], "remove", 3)
                TriggerClientEvent("mz-bins:client:BreakdownCansMinigame", src)
            else
                if Config.NotifyType == 'qb' then
                    TriggerClientEvent('QBCore:Notify', src, "You do not have enough soda cans to press (Need 3)", 'error')
                elseif Config.NotifyType == "okok" then
                    TriggerClientEvent('okokNotify:Alert', source, "NEED 3 CANS", "You do not have enough soda cans to press.", 3500, 'error')
                end
            end
        end
    end
end)

RegisterServerEvent('mz-bins:server:GetAluminum')
AddEventHandler('mz-bins:server:GetAluminum', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local amount = math.random(3, 5)
    Player.Functions.AddItem("aluminum", amount)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['aluminum'], "add", amount)
end)

------------
--PLASTIC--
------------

RegisterServerEvent('mz-bins:server:BreakdownBottles')
AddEventHandler('mz-bins:server:BreakdownBottles', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local emptybottle = Player.Functions.GetItemByName('emptybottle')
    if Player.PlayerData.items ~= nil then 
        if emptybottle ~= nil then 
            if emptybottle.amount >= 3 then 
                Player.Functions.RemoveItem("emptybottle", 3)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['emptybottle'], "remove", 3)
                TriggerClientEvent("mz-bins:client:BreakdownBottlesMinigame", src)
            else
                if Config.NotifyType == 'qb' then
                    TriggerClientEvent('QBCore:Notify', src, "You do not have enough empty bottles to crush (Need 3)", 'error')
                elseif Config.NotifyType == "okok" then
                    TriggerClientEvent('okokNotify:Alert', source, "NEED 3 BOTTLES", "You do not have enough empty bottles to crush", 3500, 'error')
                end
            end
        end
    end
end)

RegisterServerEvent('mz-bins:server:GetPlastic')
AddEventHandler('mz-bins:server:GetPlastic', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local amount = math.random(3, 6)
    Player.Functions.AddItem("plastic", amount)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['plastic'], "add", amount)
end)

-------------
--PLASTIC 2--
-------------

RegisterServerEvent('mz-bins:server:BreakdownBottlecaps')
AddEventHandler('mz-bins:server:BreakdownBottlecaps', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local bottlecaps = Player.Functions.GetItemByName('bottlecaps')
    if Player.PlayerData.items ~= nil then 
        if bottlecaps ~= nil then 
            if bottlecaps.amount >= 3 then 
                Player.Functions.RemoveItem("bottlecaps", 3)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['bottlecaps'], "remove", 3)
                TriggerClientEvent("mz-bins:client:BreakdownBottlecapsMinigame", src)
            else
                if Config.NotifyType == 'qb' then
                    TriggerClientEvent('QBCore:Notify', src, "You do not have enough empty bottles to crush (Need 3)", 'error')
                elseif Config.NotifyType == "okok" then
                    TriggerClientEvent('okokNotify:Alert', source, "NEED 3 BOTTLES", "You do not have enough empty bottles to crush", 3500, 'error')
                end
            end
        end
    end
end)

RegisterServerEvent('mz-bins:server:GetPlastic2')
AddEventHandler('mz-bins:server:GetPlastic2', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local amount = math.random(3, 8)
    Player.Functions.AddItem("plastic", amount)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['plastic'], "add", amount)
end)

---------
--GLASS--
---------

RegisterServerEvent('mz-bins:server:BreakdownCup')
AddEventHandler('mz-bins:server:BreakdownCup', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local brokencup = Player.Functions.GetItemByName('brokencup')
    if Player.PlayerData.items ~= nil then 
        if brokencup ~= nil then 
            if brokencup.amount >= 3 then 
                Player.Functions.RemoveItem("brokencup", 3)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['brokencup'], "remove", 3)
                TriggerClientEvent("mz-bins:client:BreakdownBrokencupMinigame", src)
            else
                if Config.NotifyType == 'qb' then
                    TriggerClientEvent('QBCore:Notify', src, "You do not have enough glass cups (Need 3)", 'error')
                elseif Config.NotifyType == "okok" then
                    TriggerClientEvent('okokNotify:Alert', source, "NEED 3 CUPS", "You do not have enough glass cups", 3500, 'error')
                end
            end
        end
    end
end)

RegisterServerEvent('mz-bins:server:GetGlass')
AddEventHandler('mz-bins:server:GetGlass', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local amount = math.random(3, 7)
    Player.Functions.AddItem("glass", amount)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['glass'], "add", amount)
end)

----------
--TRADER--
----------

QBCore.Functions.CreateCallback('mz-bins:server:getInv', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local inventory = Player.PlayerData.items
    return cb(inventory)
end)

RegisterNetEvent("mz-bins:server:sellTrashItems", function(itemName, itemAmount, itemPrice)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local totalPrice = (tonumber(itemAmount) * itemPrice)
    if Player.Functions.RemoveItem(itemName, tonumber(itemAmount)) then
        Player.Functions.AddMoney("cash", totalPrice)
        if Config.NotifyType == "qb" then    
            TriggerClientEvent("QBCore:Notify", src, Lang:t('success.sold', {value = tonumber(itemAmount), value2 = QBCore.Shared.Items[itemName].label, value3 = totalPrice}), 'success')
        elseif Config.NotifyType == "okok" then
            TriggerClientEvent('okokNotify:Alert', source, "SOLD!", Lang:t('success.sold', {value = tonumber(itemAmount), value2 = QBCore.Shared.Items[itemName].label, value3 = totalPrice}), 3500, 'success')
        end
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], 'remove')
    else
        if Config.NotifyType == "qb" then    
            TriggerClientEvent("QBCore:Notify", src, Lang:t('error.no_items'), "error")
        elseif Config.NotifyType == "okok" then
            TriggerClientEvent('okokNotify:Alert', source, "WRONG ITEMS?", "You do not have the necessary items", 3500, 'error')
        end
    end
end)

-----------
--WALLETS--
-----------

QBCore.Functions.CreateUseableItem("wallet", function(source, item)
    TriggerClientEvent("mz-bins:client:walletOpen", source, item.name)
end)

RegisterServerEvent('mz-bins:server:walletReward')
AddEventHandler('mz-bins:server:walletReward', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local wallet = Player.Functions.GetItemByName('wallet')
    local walletcash = math.random(1, 500)
    local chancey = math.random(1, 10)
    if chancey < 3 then
        Player.Functions.AddMoney("cash", walletcash)
        if Config.NotifyType == "qb" then    
            TriggerClientEvent("QBCore:Notify", src, "Hey, you found some cash! Nice!", "success", 3500)
        elseif Config.NotifyType == "okok" then
            TriggerClientEvent('okokNotify:Alert', source, "CASH FOUND", "You found some cash! Nice!", 3500, 'success')
        end
    elseif chancey > 2 and chancey < 7 then
        if Config.NotifyType == "qb" then    
            TriggerClientEvent("QBCore:Notify", src, "Found a note 'Be good to your mother' ...")
        elseif Config.NotifyType == "okok" then
            TriggerClientEvent('okokNotify:Alert', source, "META FOUND", "Found a note 'Be good to your mother' ...", 3500, 'success')
        end
    elseif chancey > 6 and chancey < 11 then
        if Config.NotifyType == "qb" then    
            TriggerClientEvent("QBCore:Notify", src, "Empty... It came from a bin, what did you expect?", "error", 3500)
        elseif Config.NotifyType == "okok" then
            TriggerClientEvent('okokNotify:Alert', source, "NOTHING HERE", "Empty... It came from a bin, what did you expect?", 3500, 'error')
        end
    end
    Player.Functions.RemoveItem("wallet", 1)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['wallet'], "remove", 1)
end)
