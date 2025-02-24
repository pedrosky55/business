-- Función para abrir el almacén compartido
function OpenSharedStash(businessType)
    local stashId = Config.BusinessTypes[businessType].sharedStash
    if stashId then
        exports.ox_inventory:openInventory('stash', stashId)
    else
        TriggerEvent('esx:showNotification', 'No hay un almacén compartido para este negocio.')
    end
end

-- Función para comprar items
function OpenBuyMenu(businessType)
    local items = Config.BusinessTypes[businessType].inventory
    local elements = {}

    for k, v in pairs(items) do
        if v.stock > 0 then
            table.insert(elements, {
                label = v.label .. ' - $' .. v.price .. ' (Stock: ' .. v.stock .. ')',
                value = v.name,
                price = v.price,
                stock = v.stock
            })
        end
    end

    lib.registerMenu({
        id = 'buy_menu',
        title = 'Comprar Items',
        position = 'top-left',
        options = elements
    }, function(selected, scrollIndex, args)
        TriggerServerEvent('business:buyItem', businessType, elements[selected].value, elements[selected].price)
    end)

    lib.showMenu('buy_menu')
end