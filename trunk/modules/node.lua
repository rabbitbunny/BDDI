--[[
	node
	performs simulations and returns results to server
]]--


do

	local node = {}
	node.__index = node
	node.modules = { "networking", "database" }
	
	function node.main ( ... )
		_utility.print( "Starting Node..." )
		_utility.print( "Controller:", _options.controller )
		
		--open network
		pipe = _modules.networking:open(_options.type)
		
		--open database
		node_data = _modules.database:open( "cache", "data" )
		director_queue = _modules.database:open( "director", "queue" )
		director_queue:print( "queue" )
		
		--grab queue
		node_cache = director_queue:query( "queue", "asignee", "==", "node", "complete", "==", "0" )	-- this should reference the name of this instance
		_utility.printVariable( node_cache, "cache" )
		
		--compute things
		for k,v in ipairs(node_cache) do
			start_time = os.time()
			result = node.compute( v )
		end
			--records:print( "test" )
			
		--end --while
		
		_utility.print( "Stopping Node..." )
		
		--close database
		--records:close()
		--queue:close()
		
		--close network
		pipe:close()
		
		return true
	end
	
	function node.compute( input )
		_utility.print( "Computing..." )
		_utility.printVariable( input )
		return input
	end
	
	return node
end
