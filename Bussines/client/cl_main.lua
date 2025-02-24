local inBusinessZone = false
local currentBusiness = nil

-- Función para mostrar notificaciones
function ShowHelpNotification(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

-- Función para verificar si el jugador está cerca de un negocio
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        inBusinessZone = false
        currentBusiness = nil

        for businessType, data in pairs(Config.BusinessTypes) do
            for k, v in pairs(data.locations) do
                local distance = #(playerCoords - v)
                if distance < 5.0 then
                    inBusinessZone = true
                    currentBusiness = businessType
                    DrawMarker(1, v.x, v.y, v.z - 1.0, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 255, 255, 0, 200, false, true, 2, nil, nil, false)
                    if distance < 1.5 then
                        ShowHelpNotification("Presiona ~INPUT_CONTEXT~ para interactuar con el negocio.")
                        if IsControlJustReleased(0, 38) then -- 38 es la tecla E
                            OpenBusinessMenu(currentBusiness)
                        end
                    end
                end
            end
        end
    end
end)

-- Cargar garajes y vehículos al iniciar el recurso
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        -- Obtener los garajes y vehículos desde la caché del servidor
        TriggerServerEvent('business:getGaragesAndVehicles')
    end
end)

-- Evento para recibir garajes y vehículos desde el servidor
RegisterNetEvent('business:setGaragesAndVehicles')
AddEventHandler('business:setGaragesAndVehicles', function(garages)
    for _, garage in pairs(garages) do
        local coords = garage.coords
        -- Crear un blip para el garaje
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 357) -- Icono del garaje
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 3) -- Color del blip
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Garaje de " .. garage.job_name)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Comando para añadir un garaje y un vehículo
RegisterCommand("addgarageandvehicle", function(source, args, rawCommand)
    local jobName = args[1]
    local garageType = args[2]
    local vehicleModel = args[3]

    if jobName and garageType and vehicleModel then
        local playerCoords = GetEntityCoords(PlayerPedId())
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if vehicle ~= 0 then
            local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
            TriggerServerEvent('business:addGarageAndVehicle', jobName, garageType, playerCoords, vehicleModel, vehicleProps)
        else
            TriggerEvent('esx:showNotification', 'Debes estar en un vehículo para añadirlo al garaje.')
        end
    else
        TriggerEvent('esx:showNotification', 'Uso: /addgarageandvehicle <nombre_trabajo> <tipo_garaje> <modelo_vehículo>')
    end
end, false)