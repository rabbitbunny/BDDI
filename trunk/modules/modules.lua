--[[
creates modules table and loads
]]--

_modules = { }
_modules.__index = _modules

function _modules.load ( file )
	_utility.debugPrint("Loading "..file)
	_modules[tostring(file)] = require( "modules/"..file )
end

_modules.load("tableToFile")
_modules.load("printTable")
_utility.debugPrint("Loaded "..debug.getinfo(1).source)