Config = {}

Config.BusinessTypes = {
    ["workshop"] = {
        label = "Taller Mecánico",
        inventory = {
            {name = "repair_kit", label = "Kit de Reparación", price = 500, stock = 10},
            {name = "body_kit", label = "Kit de Carrocería", price = 1000, stock = 5}
        },
        tuningLocation = nil, -- Se añadirá dinámicamente
        employees = {},
        jobs = {
            {label = "Mecánico", coords = vector3(125.0, -1005.0, 30.0)},
            {label = "Recepcionista", coords = vector3(130.0, -1000.0, 30.0)}
        },
        owner = nil,
        sharedStash = nil, -- Se añadirá dinámicamente
        locations = {} -- Se añadirán dinámicamente
    },
    ["store"] = {
        label = "Tienda de Conveniencia",
        inventory = {
            {name = "water", label = "Agua", price = 10, stock = 50},
            {name = "bread", label = "Pan", price = 15, stock = 30}
        },
        employees = {},
        jobs = {
            {label = "Cajero", coords = vector3(30.0, -1347.0, 29.5)},
            {label = "Reponedor", coords = vector3(35.0, -1350.0, 29.5)}
        },
        owner = nil,
        sharedStash = nil, -- Se añadirá dinámicamente
        locations = {} -- Se añadirán dinámicamente
    }
}

-- Configuración de ox_inventory
Config.Inventory = {
    tabletItem = 'tablet',
    businessStashPrefix = 'business_' -- Prefijo para los stashes de negocios
}

-- Configuración de facturación
Config.Billing = {
    maxAmount = 10000,
    taxRate = 0.16,
    allowedJobs = {
        "mechanic",
        "police",
        "ambulance"
    }
}