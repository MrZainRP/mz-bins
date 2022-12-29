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
    elseif chance > 185 and chance < 201 then
        Player.Functions.AddItem(QBCore.Shared.Items["bulletcasing"].name, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["bulletcasing"], "add")
    end
    if Config.NotifyType == 'qb' then
        TriggerClientEvent('QBCore:Notify', src, "This might be useful, nice!", 'success')
    elseif Config.NotifyType == "okok" then
        TriggerClientEvent('okokNotify:Alert', source, "YOU FOUND SOMETHING!", "This might be useful, nice!", 3500, 'success')
    end
end)

RegisterServerEvent('mz-bins:server:GetItemRare', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local chance2 = math.random(1, 200)
    if chance2 > 0 and chance2 <= 3 then
        Player.Functions.AddItem(QBCore.Shared.Items[Config.Rareitem1].name, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Rareitem1], "add")
        if Config.NotifyType == 'qb' then
            TriggerClientEvent('QBCore:Notify', src, "Woah, you also found a "..Config.Rareitem1..".", 'success')
        elseif Config.NotifyType == "okok" then
            TriggerClientEvent('okokNotify:Alert', source, "NICE!", "Woah, you also found a "..Config.Rareitem1..".", 3500, 'success')
        end
    elseif chance2 > 3 and chance2 <= 5 then
        Player.Functions.AddItem(QBCore.Shared.Items[Config.Rareitem2].name, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Rareitem2], "add")
        if Config.NotifyType == 'qb' then
            TriggerClientEvent('QBCore:Notify', src, "Woah, you also found a "..Config.Rareitem2..".", 'success')
        elseif Config.NotifyType == "okok" then
            TriggerClientEvent('okokNotify:Alert', source, "NICE!", "Woah, you also found a "..Config.Rareitem2..".", 3500, 'success')
        end
    elseif chance2 == 6 then
        Player.Functions.AddItem(QBCore.Shared.Items[Config.Rareitem3].name, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Rareitem3], "add")
        if Config.NotifyType == 'qb' then
            TriggerClientEvent('QBCore:Notify', src, "Woah, you also found a "..Config.Rareitem3..".", 'success')
        elseif Config.NotifyType == "okok" then
            TriggerClientEvent('okokNotify:Alert', source, "NICE!", "Woah, you also found a "..Config.Rareitem3..".", 3500, 'success')
        end
    elseif chance2 == 7 then
        Player.Functions.AddItem(QBCore.Shared.Items[Config.Rareitem4].name, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Rareitem4], "add")
        if Config.NotifyType == 'qb' then
            TriggerClientEvent('QBCore:Notify', src, "Woah, you also found a "..Config.Rareitem4..".", 'success')
        elseif Config.NotifyType == "okok" then
            TriggerClientEvent('okokNotify:Alert', source, "NICE!", "Woah, you also found a "..Config.Rareitem4..".", 3500, 'success')
        end
    end
end)

RegisterServerEvent('mz-bins:getItem', function()
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

RegisterServerEvent('mz-bins:server:BreakdownCans', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local sodacan = Player.Functions.GetItemByName('sodacan')
    if Player.PlayerData.items ~= nil then 
        if sodacan ~= nil then 
            if sodacan.amount >= Config.cansamount then 
                Player.Functions.RemoveItem("sodacan", Config.cansamount)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['sodacan'], "remove", Config.cansamount)
                TriggerClientEvent("mz-bins:client:BreakdownCansMinigame", src)
            else
                if Config.NotifyType == 'qb' then
                    TriggerClientEvent('QBCore:Notify', src, "You do not have enough soda cans to press (Need "..Config.cansamount..")", 'error')
                elseif Config.NotifyType == "okok" then
                    TriggerClientEvent('okokNotify:Alert', source, "NEED CANS", "You do not have enough soda cans to press (Need "..Config.cansamount..")", 3500, 'error')
                end
            end
        end
    end
end)

RegisterServerEvent('mz-bins:server:GetAluminum', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local amount = math.random(Config.cansreturnlow, Config.cansreturnhigh)
    Player.Functions.AddItem("aluminum", amount)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['aluminum'], "add", amount)
end)

------------
--PLASTIC--
------------

RegisterServerEvent('mz-bins:server:BreakdownBottles', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local emptybottle = Player.Functions.GetItemByName('emptybottle')
    if Player.PlayerData.items ~= nil then 
        if emptybottle ~= nil then 
            if emptybottle.amount >= Config.bottlesamount then 
                Player.Functions.RemoveItem("emptybottle", Config.bottlesamount)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['emptybottle'], "remove", Config.bottlesamount)
                TriggerClientEvent("mz-bins:client:BreakdownBottlesMinigame", src)
            else
                if Config.NotifyType == 'qb' then
                    TriggerClientEvent('QBCore:Notify', src, "You do not have enough empty bottles to crush (Need "..Config.bottlesamount..")", 'error')
                elseif Config.NotifyType == "okok" then
                    TriggerClientEvent('okokNotify:Alert', source, "NEED BOTTLES", "You do not have enough empty bottles to crush (Need "..Config.bottlesamount..")", 3500, 'error')
                end
            end
        end
    end
end)

RegisterServerEvent('mz-bins:server:GetPlastic', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local amount = math.random(Config.bottlesreturnlow, Config.bottlesreturnhigh)
    Player.Functions.AddItem("plastic", amount)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['plastic'], "add", amount)
end)

-------------
--PLASTIC 2--
-------------

RegisterServerEvent('mz-bins:server:BreakdownBottlecaps', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local bottlecaps = Player.Functions.GetItemByName('bottlecaps')
    if Player.PlayerData.items ~= nil then 
        if bottlecaps ~= nil then 
            if bottlecaps.amount >= Config.bottlecapsamount then 
                Player.Functions.RemoveItem("bottlecaps", Config.bottlecapsamount)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['bottlecaps'], "remove", Config.bottlecapsamount)
                TriggerClientEvent("mz-bins:client:BreakdownBottlecapsMinigame", src)
            else
                if Config.NotifyType == 'qb' then
                    TriggerClientEvent('QBCore:Notify', src, "You do not have enough empty bottles to crush (Need "..Config.bottlecapsamount..")", 'error')
                elseif Config.NotifyType == "okok" then
                    TriggerClientEvent('okokNotify:Alert', source, "NEED BOTTLES", "You do not have enough empty bottles to crush (Need "..Config.bottlecapsamount..")", 3500, 'error')
                end
            end
        end
    end
end)

RegisterServerEvent('mz-bins:server:GetPlastic2', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local amount = math.random(Config.bottlecapsreturnlow, Config.bottlecapsreturnhigh)
    Player.Functions.AddItem("plastic", amount)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['plastic'], "add", amount)
end)

---------
--GLASS--
---------

RegisterServerEvent('mz-bins:server:BreakdownCup', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local brokencup = Player.Functions.GetItemByName('brokencup')
    if Player.PlayerData.items ~= nil then 
        if brokencup ~= nil then 
            if brokencup.amount >= Config.brokencupamount then 
                Player.Functions.RemoveItem("brokencup", Config.brokencupamount)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['brokencup'], "remove", Config.brokencupamount)
                TriggerClientEvent("mz-bins:client:BreakdownBrokencupMinigame", src)
            else
                if Config.NotifyType == 'qb' then
                    TriggerClientEvent('QBCore:Notify', src, "You do not have enough glass cups (Need "..Config.brokencupamount..")", 'error')
                elseif Config.NotifyType == "okok" then
                    TriggerClientEvent('okokNotify:Alert', source, "NEED CUPS", "You do not have enough glass cups (Need "..Config.brokencupamount..")", 3500, 'error')
                end
            end
        end
    end
end)

RegisterServerEvent('mz-bins:server:GetGlass', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local amount = math.random(Config.brokencupreturnlow , Config.brokencupreturnhigh)
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

RegisterServerEvent('mz-bins:server:walletReward', function()
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
