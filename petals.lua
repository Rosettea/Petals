-- i have the tendancy to make everything i code a mess
-- petals is no exception
-- excuse: its in alpha :^)
local commander = require 'commander'
local fs = require 'fs'

local petals = {}
plugtable = {
	notinstalled = {},
	notstarted = {},
	started = {}
}

-- Init adds the `petals` command for plugin management in interactive mode
petals.init = function()
	commander.register('petals', function(args)
		if #args < 1 then
			print(help)
			return
		end

		local cmd = args[1]
		if cmd == 'install' then
			for p, props in pairs(plugtable.notinstalled) do
				petals.install(p)
			end
		end
	end)
end

-- Loads plugins
petals.load = function(plugurl)
	local exists = plugexists(plugurl)

	if not exists then
		plugtable.notinstalled[plugurl] = {}
	else
		manifest = getmanifest(plugurl)
		plugtable.notstarted[plugurl] = manifest
	end
end

-- Installs a single plugin
petals.install = function(plugurl)
	local ok = clone(plugurl)
	if not ok then error 'not found' end
	
	plugtable.notinstalled[plugurl] = nil
	plugtable.notstarted[plugurl] = getmanifest(plugurl)
	
	print('Successfully installed ' .. plugurl .. '!')
end

-- Actually starts up our plugins
petals.start = function()
	for p, props in pairs(plugtable.notstarted) do
		dofile(expand '~/.local/share/hilbish/petals/start/' .. p .. '/src/plugin.lua')
		plugtable.notstarted[p] = nil
		plugtable.started[props.name] = props
	end
end

function getmanifest(plugurl)
	manifile = io.open(expand '~/.local/share/hilbish/petals/start/' .. plugurl .. '/package.lua')
	manifest = manifile:read('*all')
	manifile:close()

	props = loadstring(manifest)
	return props()
end

function clone(url)
	local cmd = 'git clone https://github.com/' .. url .. expand(' ~/.local/share/hilbish/petals/start/') .. url .. ' > /dev/null 2>&1'
	local code = os.execute(cmd)

	return true, code == 0
end

function plugexists(url)
	local plugfolder = expand '~/.local/share/hilbish/petals/start/' .. url
	local exists = fs.stat(plugfolder)

	return exists
end

function expand(path)
	return string.gsub(path, '~', os.getenv 'HOME', 1)
end

help = string.format [[
Usage: petals <command>

Hilbish plugin manager.

Available commands:
	install - Installs loaded plugins that aren't installed
]]

return petals
