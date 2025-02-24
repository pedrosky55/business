-- Evento para comprar items
RegisterServerEvent('business:buyItem')
AddEventHandler('business:buyItem', function(businessType, itemName, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    local business = Config.BusinessTypes[businessType]

    for k, v in pairs(business.inventory) do
        if v.name == itemName then
            if v.stock > 0 then
                if xPlayer.getMoney() >= price then
                    xPlayer.removeMoney(price)
                    xPlayer.addInventoryItem(itemName, 1)
                    v.stock = v.stock - 1
                    TriggerClientEvent('esx:showNotification', source, 'Has comprado ' .. v.label .. ' por $' .. price)
                else
                    TriggerClientEvent('esx:showNotification', source, 'No tienes suficiente dinero.')
                end
            else
                TriggerClientEvent('esx:showNotification', source, 'No hay suficiente stock.')
            end
            break
        end
    end
end)