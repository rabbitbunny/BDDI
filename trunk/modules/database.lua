--[[
	uses sqlite database
	luasql-sqlite3
	
	records = database:open( "test", "test" )
printVariable( records )
records:insert( "test", "hello", 10)
records:print( "test" )
records:close()


]]--

require "luasql.sqlite3"

do

	local database = {}
	database.__index = database
	database.modules = { }
	
	function database:open( f, t )
		_utility.print( "Opening Database Connection" )
		object = {}
		object.env = luasql.sqlite3()
		object.conn = object.env:connect( f..".sqlite" )
		setmetatable(object,database)
		assert(object.conn:execute("create table if not exists "..t.."(one varchar(10), two smallint)"))
		return object
	end
	
	function database:close( )
		_utility.print( "Closing Database Connection" )
		self.conn:close()
		self.env:close()
	end
	
	function database:insert( t, ... )
		s = ""
		for _,v in ipairs(arg) do
			if ( type(v) == "string" ) then
				s = s..', "'..v..'"'
			elseif ( type(v) == "table" ) then
			 s = s..', <table>'
			else
				s = s..", "..tostring(v)
			end
		end
		s = string.sub(s, 3) -- removes leading comma
		assert(self.conn:execute("insert into "..t.." values("..s..")"))
	end
	
	function database:print( t )
		cursor = assert(self.conn:execute("select * from "..t))
		row = {}
		while cursor:fetch(row) do
				_utility.print(table.concat(row, '|'))
		end
		cursor:close()
	end

	return database
end
