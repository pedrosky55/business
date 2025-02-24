-- Función para abrir el menú de facturación
function OpenBillingMenu()
    local players = GetNearestPlayers()
    local elements = {}

    for _, player in pairs(players) do
        table.insert(elements, {
            label = GetPlayerName(player.id) .. " (ID: " .. player.id .. ")",
            value = player.id
        })
    end

    if #elements == 0 then
        TriggerEvent('esx:showNotification', 'No hay jugadores cercanos.')
        return
    end

    lib.registerMenu({
        id = 'billing_menu',
        title = 'Emitir Factura',
        position = 'top-left',
        options = elements
    }, function(selected, scrollIndex, args)
        local targetId = elements[selected].value
        OpenBillingAmountMenu(targetId)
    end)

    lib.showMenu('billing_menu')
end

-- Tecla F5 para abrir el menú de facturación
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 166) then -- 166 es la tecla F5
            OpenBillingMenu()
        end
    end
end)