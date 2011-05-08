--[[
creates modules table and loads
]]--

_modules = { }
_modules.__index = _modules

function _modules._load ( file )
	_utility.debugPrint("Loading module '"..file.."'")
	_modules[tostring(file)] = require( "modules/"..file )
end

function _modules._remove ( file )
	_utility.debugPrint("Unloading module '"..file.."'")
	_modules[tostring(file)] = nil
end

_modules._load("tableToFile")
_modules._load("printTable")
_utility.debugPrint("Loaded "..debug.getinfo(1).source)