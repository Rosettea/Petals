-- i have the tendancy to make everything i code a mess
-- petals is no exception
-- excuse: its in alpha :^)
local commander = require 'commander'
local fs = require 'fs'
local utils = require 'petals.utils'

local petals = {}
local plugtable = {
	notinstalled = {},
	notstarted = {},
	started = {}
}

petals.ver = '0.0.3'
-- Init adds the `petals` command for plugin management in interactive mode
petals.init = function()
	commander.register('petals', function(args)
		if #args < 1 then
			print(help)
			return
		end

		local cmd = args[1]
		if cmd == 'help' then
			print(help)
		elseif cmd == 'install' then
			for p, props in pairs(plugtable.notinstalled) do
				local ok, code, msg = petals.install(p, props)

				if ok then 
					print('✔️ Successfully installed ' .. p .. '!')
				else
					print('✖️ Unsuccessfully installed ' .. p .. '.\n'
					.. 'Reason: ' .. msg)
				end
			end
		elseif cmd == 'version' then
			print(petals.ver)
		else
			print 'unknown command'
			print 'run "petals help" for commands and usage'
		end
	end)
end

-- Loads plugins
petals.load = function(plug)
	local plugurl = plug
	local manifest = {}

	if type(plug) == 'table' then
		plugurl = plug[1]
		manifest = plug
	end
	local exists = utils.exists(plugurl, manifest.module)

	if not exists then
		plugtable.notinstalled[plugurl] = manifest
	else
		if manifest.module then
			utils.addPackage(plugurl)
		else
			manifest = utils.getmanifest(plugurl)
			plugtable.notstarted[plugurl] = manifest
		end
	end
end

-- Installs a single plugin
petals.install = function(plugurl, opts)
	local path = ''
	if opts.module then
		path = utils.expand '~/.local/share/hilbish/petals/libs/' .. plugurl
	else
		path = utils.expand '~/.local/share/hilbish/petals/start/' .. plugurl
	end

	local ok = utils.clone(plugurl, path)
	if not ok then return false, 1, 'repository not found' end
	
	plugtable.notinstalled[plugurl] = nil
	plugtable.notstarted[plugurl] = utils.getmanifest(path)

	return true, 0, success
end

-- Actually starts up our plugins
petals.start = function()
	for p, props in pairs(plugtable.notstarted) do
		dofile(utils.expand '~/.local/share/hilbish/petals/start/' .. p .. '/src/plugin.lua')
		plugtable.notstarted[p] = nil
		plugtable.started[props.name] = props
	end
end

local help = string.format [[
Usage: petals <command>

Hilbish plugin manager.

Available commands:
	help     -  This help page
	install  -  Installs loaded plugins that aren't installed
	version  -  Prints the version of Petals
]]

return petals
