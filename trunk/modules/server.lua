--[[
	server module
		controls db, starts jobs, presents results
]]--


do
	local server = {}
	server.__index = server
	server.modules = { "networking", "database" }
	
	function server.main ( ... )
		--_utility.print('input args: ' .. (... == nil and 'none' or ...)) --ternary
		_utility.print( "Starting Server..." )

		--open network
		pipe = _modules.networking:open(_options.type)
		
		--open databases
		queue = _modules.database:open( "server", "queue" )
		
		--serve things
		_utility.print( "Running Server..." )
		
		--generate jobs
		_utility.print( "Generating Jobs..." )
		for a = 1, 5 do
			queue:insert( "queue", "false", "director", "0", "job"..a, a, a, "-" )
		end
		queue:print( "queue" )
		
		_utility.print("Launching Director...")
		server.launchDirector()
		_utility.print("Director Stopped...")
		
	
		--stop serving things
		_utility.print( "Stopping Server..." )

		--clear database
		queue:clear( "queue" )
		
		--close database
		queue:close()
		
		--close network
		pipe:close()
		
		return true
	end
	
	function server.launchDirector()
		--i think os.execute is wrong, it needs to run a process detached
		os.execute(_options.runtime .. " main.lua director " .. _modules.networking.myip)
	end

	return server
end
