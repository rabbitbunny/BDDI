--[[
creates modules table and loads
]]--


_modules = { }
_modules.__index = _modules
_modules._loaded = { }

function _modules._load ( file )
	table.insert( _modules._loaded, file )
	_modules[tostring(file)] = require( "modules/"..file )
	--make sure we have the prereqs listed in module.modules
	--_utility.printVariable(_modules, tostring(file))
	if ( _modules[tostring(file)].modules ~= { } ) then
		for k,v in ipairs( _modules[tostring(file)].modules ) do
			if ( _modules[tostring(v)] == nil ) then
				_utility.debugPrint("Prereq module needed:", v)
				_modules._load(v)
			end
		end
	end
end

function _modules._remove ( file )
	_utility.debugPrint("Unloading module '"..file.."'")
	_modules[tostring(file)] = nil
	_modules._loaded[tostring(file)] = nil --maybe?
end

_modules._load("tableToFile")
_modules._load("printTable")
