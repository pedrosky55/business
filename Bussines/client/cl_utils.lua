-- Función para obtener jugadores cercanos
function GetNearestPlayers()
    local players = {}
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, player in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(player)
        local targetCoords = GetEntityCoords(targetPed)
        local distance = #(playerCoords - targetCoords)

        if distance < 3.0 and player ~= PlayerId() then
            table.insert(players, {
                id = GetPlayerServerId(player),
                name = GetPlayerName(player)
            })
        end
    end

    return players
end

-- Función para mostrar notificaciones
function ShowHelpNotification(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end