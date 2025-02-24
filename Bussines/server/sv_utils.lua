-- Función para verificar si un jugador tiene un trabajo permitido
function IsJobAllowed(playerJob, allowedJobs)
    for _, job in pairs(allowedJobs) do
        if playerJob == job then
            return true
        end
    end
    return false
end

-- Función para verificar si un jugador está en servicio
function IsPlayerOnDuty(identifier, onDutyEmployees)
    return onDutyEmployees[identifier] ~= nil
end