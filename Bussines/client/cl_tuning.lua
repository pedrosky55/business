-- Función para abrir el menú de colores RGB
function OpenColorRGBMenu(colorType)
    local elements = {
        {label = "Rojo", value = 'red', min = 0, max = 255, default = 255},
        {label = "Verde", value = 'green', min = 0, max = 255, default = 0},
        {label = "Azul", value = 'blue', min = 0, max = 255, default = 0}
    }

    lib.registerMenu({
        id = 'color_rgb_menu',
        title = 'Seleccionar Color ' .. (colorType == 'primary' and 'Primario' or 'Secundario') .. ' (RGB)',
        position = 'top-left',
        options = elements
    }, function(selected, scrollIndex, args)
        local red = tonumber(args.red)
        local green = tonumber(args.green)
        local blue = tonumber(args.blue)

        if red and green and blue then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if colorType == 'primary' then
                SetVehicleCustomPrimaryColour(vehicle, red, green, blue)
            else
                SetVehicleCustomSecondaryColour(vehicle, red, green, blue)
            end
            TriggerEvent('esx:showNotification', 'Color ' .. (colorType == 'primary' and 'primario' or 'secundario') .. ' aplicado correctamente.')
        else
            TriggerEvent('esx:showNotification', 'Valores de color inválidos.')
        end
    end)

    lib.showMenu('color_rgb_menu')
end

-- Función para abrir el menú de estética
function OpenAestheticMenu()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then
        TriggerEvent('esx:showNotification', 'Debes estar en un vehículo para tunearlo.')
        return
    end

    local elements = {
        {label = "Cambiar Color Primario (RGB)", value = 'primary_color'},
        {label = "Cambiar Color Secundario (RGB)", value = 'secondary_color'},
        {label = "Cambiar Llantas", value = 'wheels'},
        {label = "Aerokits", value = 'bodywork'},
        {label = "Neón", value = 'neon'},
        {label = "Ventanas Tintadas", value = 'window_tint'},
        {label = "Faros", value = 'headlights'}
    }

    lib.registerMenu({
        id = 'aesthetic_menu',
        title = 'Estética del Vehículo',
        position = 'top-left',
        options = elements
    }, function(selected, scrollIndex, args)
        if selected == 1 then
            OpenColorRGBMenu('primary')
        elseif selected == 2 then
            OpenColorRGBMenu('secondary')
        elseif selected == 3 then
            OpenWheelsMenu()
        elseif selected == 4 then
            OpenBodyworkMenu()
        elseif selected == 5 then
            OpenNeonMenu()
        elseif selected == 6 then
            OpenWindowTintMenu()
        elseif selected == 7 then
            OpenHeadlightsMenu()
        end
    end)

    lib.showMenu('aesthetic_menu')
end

-- Función para abrir el menú de tuneo
function OpenTuningMenu()
    local elements = {
        {label = "Mejorar Motor", value = 'engine'},
        {label = "Mejorar Frenos", value = 'brakes'},
        {label = "Mejorar Suspensión", value = 'suspension'},
        {label = "Mejorar Transmisión", value = 'transmission'},
        {label = "Estética del Vehículo", value = 'aesthetic'}
    }

    lib.registerMenu({
        id = 'tuning_menu',
        title = 'Tunear Vehículo',
        position = 'top-left',
        options = elements
    }, function(selected, scrollIndex, args)
        if selected == 5 then
            OpenAestheticMenu()
        else
            TriggerServerEvent('business:checkDuty', 'tune_vehicle')
            TriggerServerEvent('business:tuneVehicle', elements[selected].value)
        end
    end, function(data, menu)
        menu.close()
    end)

    lib.showMenu('tuning_menu')
end

-- Función para abrir el menú de llantas
function OpenWheelsMenu()
    local elements = {
        {label = "Llantas Deportivas", value = 0},
        {label = "Llantas de Lujo", value = 1},
        {label = "Llantas Off-Road", value = 2}
    }

    lib.registerMenu({
        id = 'wheels_menu',
        title = 'Cambiar Llantas',
        position = 'top-left',
        options = elements
    }, function(selected, scrollIndex, args)
        SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), elements[selected].value)
    end)

    lib.showMenu('wheels_menu')
end

-- Función para abrir el menú de aerokits
function OpenBodyworkMenu()
    local elements = {
        {label = "Aerokit 1", value = 0},
        {label = "Aerokit 2", value = 1},
        {label = "Aerokit 3", value = 2}
    }

    lib.registerMenu({
        id = 'bodywork_menu',
        title = 'Aerokits',
        position = 'top-left',
        options = elements
    }, function(selected, scrollIndex, args)
        SetVehicleBodyKit(GetVehiclePedIsIn(PlayerPedId(), false), elements[selected].value)
    end)

    lib.showMenu('bodywork_menu')
end

-- Función para abrir el menú de neón
function OpenNeonMenu()
    local elements = {
        {label = "Neón Rojo", value = {255, 0, 0}},
        {label = "Neón Azul", value = {0, 0, 255}},
        {label = "Neón Verde", value = {0, 255, 0}},
        {label = "Apagar Neón", value = {0, 0, 0}}
    }

    lib.registerMenu({
        id = 'neon_menu',
        title = 'Neón',
        position = 'top-left',
        options = elements
    }, function(selected, scrollIndex, args)
        local color = elements[selected].value
        SetVehicleNeonLightEnabled(GetVehiclePedIsIn(PlayerPedId(), false), 0, color[1] ~= 0)
        SetVehicleNeonLightEnabled(GetVehiclePedIsIn(PlayerPedId(), false), 1, color[1] ~= 0)
        SetVehicleNeonLightEnabled(GetVehiclePedIsIn(PlayerPedId(), false), 2, color[1] ~= 0)
        SetVehicleNeonLightEnabled(GetVehiclePedIsIn(PlayerPedId(), false), 3, color[1] ~= 0)
        SetVehicleNeonLightsColour(GetVehiclePedIsIn(PlayerPedId(), false), color[1], color[2], color[3])
    end)

    lib.showMenu('neon_menu')
end

-- Función para abrir el menú de ventanas tintadas
function OpenWindowTintMenu()
    local elements = {
        {label = "Sin Tinte", value = 0},
        {label = "Tinte Ligero", value = 1},
        {label = "Tinte Oscuro", value = 2},
        {label = "Tinte Limusina", value = 3}
    }

    lib.registerMenu({
        id = 'window_tint_menu',
        title = 'Ventanas Tintadas',
        position = 'top-left',
        options = elements
    }, function(selected, scrollIndex, args)
        SetVehicleWindowTint(GetVehiclePedIsIn(PlayerPedId(), false), elements[selected].value)
    end)

    lib.showMenu('window_tint_menu')
end

-- Función para abrir el menú de faros
function OpenHeadlightsMenu()
    local elements = {
        {label = "Faros Normales", value = -1},
        {label = "Faros Xenón", value = 0},
        {label = "Faros LED", value = 1}
    }

    lib.registerMenu({
        id = 'headlights_menu',
        title = 'Faros',
        position = 'top-left',
        options = elements
    }, function(selected, scrollIndex, args)
        ToggleVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 22, elements[selected].value)
    end)

    lib.showMenu('headlights_menu')
end