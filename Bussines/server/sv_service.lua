local onDutyEmployees = {}

-- Evento para entrar/salir de servicio
RegisterServerEvent('business:toggleDuty')
AddEventHandler('business:toggleDuty', function(businessType)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    if onDutyEmployees[identifier] then
        onDutyEmployees[identifier] = nil
        TriggerClientEvent('esx:showNotification', source, 'Has salido de servicio.')
    else
        onDutyEmployees[identifier] = businessType
        TriggerClientEvent('esx:showNotification', source, 'Has entrado de servicio en ' .. Config.BusinessTypes[businessType].label)
    end

    -- Actualizar el estado de servicio en el cliente
    TriggerClientEvent('business:updateDutyStatus', -1, onDutyEmployees)
end)

-- Función para obtener empleados en servicio
function GetOnDutyEmployees()
    return onDutyEmployees
end