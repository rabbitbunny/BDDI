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
		_utility.print( "Opening Database Connection (".. tostring(f) .. "_" .. tostring(t) .. ")" )
		object = {}
		object.env = luasql.sqlite3()
		object.conn = object.env:connect( f..".sqlite" )
		object.title = tostring(f) .. "_" .. tostring(t)
		setmetatable(object,database)
		if ( t == "queue" ) then
			assert(object.conn:execute("create table if not exists "..t.."(active varchar(10), asignee varchar(10), hash varchar(10), complete int, x int, y int, fitness int)"))
		else
			assert(object.conn:execute("create table if not exists "..t.."(one varchar(10), two smallint)"))
		end
		--[[
			the database should emulate a lua table like:
			t_filters = {
				1 = "one",
				2 = ">=",
				3 = "'server'"
			}
			t_columns =  {
				1 = "one",
				2 = "two"
			}
			t = { -- data
				1 = true, --printable, passes filters
				2 = hash, --hash for cache
				3 = ...
			}				
				
			]]--
		return object
	end
	
	function database:close( )
		_utility.print( "Closing Database Connection (".. self.title .. ")" )
		self.conn:close()
		self.env:close()
	end
	
	function database:insert( t, ... )
		s = ""
		arg = {...}
		for _,v in ipairs(arg) do
			if ( type(v) == "string" ) then
				s = s..', "'..v..'"'
			elseif ( type(v) == "table" ) then
				--s = s..", ".. table.concat( v, ", " ) -- i doubt this will work well
				for _,va in ipairs(v) do
					if ( type(v) == "string" ) then
						s = s..', '..va
					else
						s = s .. ", '" .. tostring(va) .. "'"
					end
				end
			else
				s = s..", "..tostring(v)
			end
		end
		s = string.sub(s, 3) -- removes leading comma
		assert(self.conn:execute("insert into "..t.." values("..s..")"))
	end
	
	function database:delete( t, ... )
		s = ""
		iter = 0
		for _,v in ipairs(arg) do
			portion = math.mod(iter,3)
			if ( portion == 0 ) then
				s = s..' and '..v 
			elseif ( portion == 1 ) then
				s = s..' '..v 
			else
				s = s .. " '" .. tostring(v) .. "'"
			end
			iter = iter + 1
		end
		s = string.sub(s, 5) -- removes leading " and "
		assert(self.conn:execute("delete from "..t.." where"..s..""))
	end
	
	function database:update( t, col, vol, ... )
		return --uh, this needs to make an sql update statement and execute it
		--[[s = ""
		iter = 0
		for _,v in ipairs(arg) do
			portion = math.mod(iter,3)
			if ( portion == 0 ) then
				s = s..' and '..v 
			elseif ( portion == 1 ) then
				s = s..' '..v 
			else
				s = s .. " '" .. tostring(v) .. "'"
			end
			iter = iter + 1
		end
		s = string.sub(s, 5) -- removes leading " and "
		_utility.debugPrint("delete from "..t.." where"..s.."")
		assert(self.conn:execute("delete from "..t.." where"..s..""))
		]]--
		_utility.debugPrint("update "..t.." where"..s.."")
	end
	
	function database:clear( t )
		assert(self.conn:execute("delete from "..t))
	end
	
	function database:print( t )
		cursor = assert(self.conn:execute("select * from "..t))
		row = {}
		while cursor:fetch(row) do
			_utility.print(table.concat(row, '|'))
		end
		--_utility.printVariable( row )
		if ( row == nil ) then
			_utility.print("Empty table")
		end
		cursor:close()
	end

	function database:query( t, ... )
		result = { }
		s = ""
		iter = 0
		for _,v in ipairs(arg) do
			portion = math.mod(iter,3)
			if ( portion == 0 ) then
				s = s..' and '..v 
			elseif ( portion == 1 ) then
				s = s..' '..v 
			else
				s = s .. " '" .. tostring(v) .. "'"
			end
			iter = iter + 1
		end
		s = string.sub(s, 5) -- removes leading " and "
		cursor = assert(self.conn:execute("select * from "..t.." where"..s..""))
		row = {}
		while cursor:fetch(row) do
			table.insert( result, table.copy(row) )
		end
		return result
	end
	
	return database
end
