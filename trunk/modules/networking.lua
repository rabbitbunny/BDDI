--[[
use LuaSocket?
]]--

do

	local networking = {}
	networking.__index = networking
	networking.modules = { }
	networking.myip = "127.0.0.1" -- uh, this needs to be dynamic
	
	function networking.open( title )
		_utility.print( "Opening Network Connection" )
		connection = { }
		setmetatable(connection,networking)
		return connection
	end
	
	function networking.close( title )
		_utility.print( "Closing Network Connection" )
	end
	
	return networking
end
