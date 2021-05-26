local fs = require 'fs'
local utils = {}

utils.expand = function(path)
	return path:gsub('~', os.getenv 'HOME')
end

utils.clone = function(url, path)
	local cmd = io.popen('git clone https://github.com/' .. url
	..  ' ' .. path .. ' 2>&1')

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

function string.startsWith(str, start)
   return string.sub(str, 1, string.len(start)) == start
end

return utils
