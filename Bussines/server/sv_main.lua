ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Tabla para almacenar empleados en servicio
local onDutyEmployees = {}

-- Variable para almacenar la conexión a la base de datos
local db = nil
local lastActivity = 0 -- Tiempo de la última actividad

-- Función para abrir la conexión a la base de datos
local function openDatabaseConnection()
    if not db then
        db = exports.oxmysql -- Usar oxmysql
        print("[business] Conexión a la base de datos abierta.")
    end
    lastActivity = os.time() -- Actualizar el tiempo de la última actividad
end

-- Función para cerrar la conexión a la base de datos después de un tiempo de inactividad
local function closeDatabaseConnectionIfInactive()
    if db and os.time() - lastActivity > 60 then -- Cerrar después de 60 segundos de inactividad
        db = nil
        print("[business] Conexión a la base de datos cerrada por inactividad.")
    end
end

-- Temporizador para cerrar la conexión si está inactiva
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000) -- Verificar cada 60 segundos
        closeDatabaseConnectionIfInactive()
    end
end)

-- Registrar el comando createJob
RegisterCommand("createjob", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    -- Verificar si el jugador tiene permisos de administrador
    if xPlayer.getGroup() == "admin" then
        local jobName = args[1]
        local jobLabel = args[2]
        local coords = GetEntityCoords(GetPlayerPed(source))

        if jobName and jobLabel then
            openDatabaseConnection() -- Abrir la conexión

            -- Guardar el trabajo en la base de datos usando oxmysql
            db:execute('INSERT INTO jobs (job_name, job_label, coords) VALUES (?, ?, ?)', {
                jobName, jobLabel, json.encode(coords)
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    TriggerClientEvent('esx:showNotification', source, 'Trabajo creado y guardado correctamente.')
                else
                    TriggerClientEvent('esx:showNotification', source, 'Error al guardar el trabajo.')
                end
            end)
        else
            TriggerClientEvent('esx:showNotification', source, 'Uso: /createjob <nombre_trabajo> <etiqueta_trabajo>')
        end
    else
        TriggerClientEvent('esx:showNotification', source, 'No tienes permisos para crear trabajos.')
    end
end, false)

-- Evento para cargar trabajos desde la base de datos
RegisterServerEvent('business:loadJobs')
AddEventHandler('business:loadJobs', function()
    openDatabaseConnection() -- Abrir la conexión

    db:fetchAll('SELECT * FROM jobs', {}, function(result)
        TriggerClientEvent('business:setJobs', source, result)
    end)
end)

-- Evento para verificar si un jugador puede realizar acciones de servicio
RegisterServerEvent('business:checkDuty')
AddEventHandler('business:checkDuty', function(action)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    if not IsPlayerOnDuty(identifier, onDutyEmployees) then
        TriggerClientEvent('esx:showNotification', source, 'Debes estar en servicio para realizar esta acción.')
        CancelEvent()
    end
end)

-- Función para obtener empleados en servicio
function GetOnDutyEmployees()
    return onDutyEmployees
end

-- Evento para obtener la configuración del negocio
RegisterServerEvent('business:getConfig')
AddEventHandler('business:getConfig', function()
    local source = source
    TriggerClientEvent('business:setConfig', source, Config)
end)