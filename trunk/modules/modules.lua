--[[
creates modules table and loads
]]--

_utility.debugPrint("Starting "..debug.getinfo(1).source)

_modules = { }
_modules.__index = _modules
_modules.current = { }

function _modules._load ( file )
	table.insert( _modules.current, file )
	_utility.debugPrint("Loading module '"..file.."'")
	_modules[tostring(file)] = require( "modules/"..file )
	--make sure we have the prereqs listed in module.modules
	if ( _modules[tostring(file)].modules ~= { } ) then
		for k,v in ipairs( _modules[tostring(file)].modules ) do
			--print( k, v )
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
end

_modules._load("tableToFile")
_modules._load("printTable")

_utility.debugPrint("Finished "..debug.getinfo(1).source)