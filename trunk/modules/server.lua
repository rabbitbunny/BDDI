--[[
	server module
		controls db, starts jobs, presents results
]]--

_utility.debugPrint("Starting "..debug.getinfo(1).source)

do
	local server = {}
	server.__index = server
	server.modules = { "networking", "database" }
	
	function server.main ( ... )
		_utility.print('input args: ' .. (... == nil and 'none' or ...)) --ternary
		_utility.print( "Starting Server..." )
		
		--open database
		records = _modules.database:open( "test", "test" )
		
		--open network
		pipe = _modules.networking:open(_options.type)
		
		--serve things
		_utility.print( "Running Server..." )
		records:insert( "test", "server", os.time())
		records:print( "test" )
		
		--stop serving things
		_utility.print( "Stopping Server..." )

		--close network
		pipe:close()
		
		--close database
		records:close()
		
		return true
	end

	return server
end
	
_utility.debugPrint("Finished "..debug.getinfo(1).source)