-- Función para entrar/salir de servicio
function ToggleDuty(businessType)
    TriggerServerEvent('business:toggleDuty', businessType)
end

-- Función para verificar si el jugador está en servicio
function IsPlayerOnDuty()
    local playerId = PlayerId()
    local identifier = GetPlayerIdentifier(playerId, 0)
    return onDutyEmployees[identifier] ~= nil
end

-- Evento para actualizar el estado de servicio
RegisterNetEvent('business:updateDutyStatus')
AddEventHandler('business:updateDutyStatus', function(status)
    onDutyEmployees = status
end)