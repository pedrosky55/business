resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Sistema de Negocios para FiveM'

client_scripts {
    'config.lua',
    'client/cl_main.lua',
    'client/cl_billing.lua',
    'client/cl_tuning.lua',
    'client/cl_service.lua',
    'client/cl_inventory.lua'
}

server_scripts {
    'config.lua',
    'server/sv_main.lua',
    'server/sv_billing.lua',
    'server/sv_tuning.lua',
    'server/sv_service.lua',
    'server/sv_inventory.lua'
}