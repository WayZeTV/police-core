resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Police Job Core by WayZe#0001'

version '1.2.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',

	'server/policejob.lua',
	'server/policearmurerie.lua',
	'server/celldoors.lua'
}

client_scripts {
	'@es_extended/locale.lua',

	"src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",
	
	'locales/fr.lua',
	'config.lua',

	'client/policejob.lua',
	'client/celldoors.lua',
	'client/policearmurerie.lua',
	'client/policegarage.lua'
}

dependencies {
	'es_extended',
	'esx_billing'
}

-- Vehicules

------------- GhispoLSPD -------------

files {
	'vehicules/GhispoLSPD/vehicles.meta',
	'vehicules/GhispoLSPD/carvariations.meta',
	'vehicules/GhispoLSPD/carcols.meta',
	'vehicules/GhispoLSPD/handling.meta'
}

data_file 'HANDLING_FILE' 'vehicules/GhispoLSPD/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicules/GhispoLSPD/vehicles.meta'
data_file 'CARCOLS_FILE' 'vehicules/GhispoLSPD/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'vehicules/GhispoLSPD/carvariations.meta'

------------- velolspd -------------

files {
	'vehicules/velolspd/vehicles.meta',
	'vehicules/velolspd/carvariations.meta',
	'vehicules/velolspd/carcols.meta',
	'vehicules/velolspd/handling.meta'
}

data_file 'HANDLING_FILE' 'vehicules/velolspd/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicules/velolspd/vehicles.meta'
data_file 'CARCOLS_FILE' 'vehicules/velolspd/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'vehicules/velolspd/carvariations.meta'

------------- flashlandpack -------------

files {
    'vehicules/flashlandpack/vehicles.meta',
    'vehicules/flashlandpack/carvariations.meta',
    'vehicules/flashlandpack/carcols.meta',
    'vehicules/flashlandpack/handling.meta',
}

data_file 'HANDLING_FILE' 'vehicules/flashlandpack/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicules/flashlandpack/vehicles.meta'
data_file 'CARCOLS_FILE' 'vehicules/flashlandpack/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'vehicules/flashlandpack/carvariations.meta'

------------- policefelon -------------

files {
    'vehicules/policefelon/vehicles.meta',
    'vehicules/policefelon/carvariations.meta',
    'vehicules/policefelon/carcols.meta',
    'vehicules/policefelon/handling.meta',
}

data_file 'HANDLING_FILE' 'vehicules/policefelon/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicules/policefelon/vehicles.meta'
data_file 'CARCOLS_FILE' 'vehicules/policefelon/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'vehicules/policefelon/carvariations.meta'