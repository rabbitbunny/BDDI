--[[

]]--

do

	local director = {}
	director.__index = director
	director.modules = { "networking", "database" }
	
	function director.main ( ... )
		_utility.print( "Starting Director..." )
		_utility.print( "Controller:", _options.controller )
		
		--open network
		pipe = _modules.networking:open(_options.type)
		
		--open database
		server_output = _modules.database:open( "server", "queue" )
		director_queue = _modules.database:open( "director", "queue" )
		
		--load cached jobs from server
		director_cache = server_output:query( "queue", "asignee", "==", "director" )	-- this should reference the name of this instance
		
		--do jobs
		for k,v in ipairs(director_cache) do
			server_output:update( "cache", complete, "1", "hash", v[3] )
			v[2] = "node"
			director_queue:insert( "queue", v )
			_utility.print("Launching Node...")
			director.launchNode()
			_utility.print("Node Stopped...")
		end

		--we're done
		_utility.print( "Stopping Director..." )
		
		--close database
		director_queue:clear( "queue" )
		director_queue:close()
		
		--close network
		pipe:close()
		
		return true
	end
	
	function director.launchNode()
		os.execute(_options.runtime .. " main.lua node " .. _modules.networking.myip)
	end
	
	return director
end
