local fs = require 'fs'
local utils = {}

utils.expand = function(path)
	return path:gsub('~', os.getenv 'HOME')
end

utils.clone = function(url)
	local cmd = io.popen('git clone https://github.com/' .. url
	.. utils.expand ' ~/.local/share/hilbish/petals/start/'
	.. url .. ' 2>&1')

	local output = cmd:read '*all'
	cmd:close()
	
	local res = output:split '\n'
	res = res[#res - 1]

	return not res:startsWith 'fatal: repository'
end

utils.exists = function(url)
	local plugfolder = utils.expand('~/.local/share/hilbish/petals/start/'
	.. url)

	local exists = fs.stat(plugfolder)

	return exists
end

utils.getmanifest = function (plugurl)
	manifile = io.open(utils.expand '~/.local/share/hilbish/petals/start/' 
	.. plugurl .. '/package.lua')

	manifest = manifile:read '*all'
	manifile:close()

	props = loadstring(manifest)
	return props()
end

-- https://gist.github.com/jaredallard/ddb152179831dd23b230
-- TODO: move to hilbish's preload.lua
function string.split(str, delimiter)
	local result = {}
	local from = 1
	
	local delim_from, delim_to = string.find(str, delimiter, from)
	
	while delim_from do
		table.insert(result, string.sub(str, from, delim_from - 1))
		from = delim_to + 1
		delim_from, delim_to = string.find(str, delimiter, from)
	end
	
	table.insert(result, string.sub(str, from))

	return result
end

function string.startsWith(str, start)
   return string.sub(str, 1, string.len(start)) == start
end

return utils
