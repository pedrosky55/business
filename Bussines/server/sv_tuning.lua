-- Evento para aplicar mejoras al vehículo
RegisterServerEvent('business:tuneVehicle')
AddEventHandler('business:tuneVehicle', function(upgrade)
    local xPlayer = ESX.GetPlayerFromId(source)
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(source), false)

    if vehicle == 0 then
        TriggerClientEvent('esx:showNotification', source, 'Debes estar en un vehículo para tunearlo.')
        return
    end

    local price = 0
    if upgrade == 'engine' then
        price = 5000
    elseif upgrade == 'brakes' then
        price = 3000
    elseif upgrade == 'suspension' then
        price = 4000
    elseif upgrade == 'transmission' then
        price = 4500
    end

    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        TriggerClientEvent('business:applyTuning', source, upgrade)
        TriggerClientEvent('esx:showNotification', source, 'Has mejorado tu vehículo: ' .. upgrade)
    else
        TriggerClientEvent('esx:showNotification', source, 'No tienes suficiente dinero.')
    end
end)