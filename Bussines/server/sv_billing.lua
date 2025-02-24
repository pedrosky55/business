-- Evento para enviar una factura
RegisterServerEvent('business:sendBill')
AddEventHandler('business:sendBill', function(targetId, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if not xTarget then
        TriggerClientEvent('esx:showNotification', source, 'Jugador no encontrado.')
        return
    end

    -- Verificar si el jugador tiene un trabajo permitido para facturar
    local allowed = false
    for _, job in pairs(Config.Billing.allowedJobs) do
        if xPlayer.job.name == job then
            allowed = true
            break
        end
    end

    if not allowed then
        TriggerClientEvent('esx:showNotification', source, 'No tienes permiso para emitir facturas.')
        return
    end

    -- Calcular el total con impuestos
    local totalAmount = amount * (1 + Config.Billing.taxRate)

    -- Enviar la factura al jugador objetivo
    TriggerClientEvent('esx:showNotification', targetId, 'Has recibido una factura de $' .. totalAmount .. ' de ' .. xPlayer.getName())
    TriggerClientEvent('esx:showNotification', source, 'Factura enviada a ' .. xTarget.getName() .. ' por $' .. totalAmount)

    -- Guardar la factura en la base de datos (opcional)
    MySQL.Async.execute('INSERT INTO billing (identifier, sender, target, amount, label) VALUES (@identifier, @sender, @target, @amount, @label)', {
        ['@identifier'] = xTarget.identifier,
        ['@sender'] = xPlayer.identifier,
        ['@target'] = xTarget.identifier,
        ['@amount'] = totalAmount,
        ['@label'] = 'Factura de ' .. xPlayer.job.label
    })
end)