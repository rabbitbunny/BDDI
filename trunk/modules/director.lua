--[[

]]--

_utility.debugPrint("Starting "..debug.getinfo(1).source)

do

	local director = {}
	director.__index = director
	director.modules = { "networking" }
	
	function director.main ( ... )
		_utility.centralPrint( "Starting Director..." )
--		_utility.centralPrint('input args: ' .. (... == nil and 'none' or ...) ) --ternary
--		_utility.centralPrint('input args: ' .. table.concat( ... ) )
		_utility.centralPrint( "Controller:", _options.controller )
		
		--direct things
		
		_utility.centralPrint( "Stopping Director..." )
		return true
	end
	
	return director
end

_utility.debugPrint("Finished "..debug.getinfo(1).source)