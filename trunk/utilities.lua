--[[
--little debugging functions

]]--
_utility = {}
_utility.__index = _utility

function _utility.print( ... )
	arg = {...}
	input = table.concat( arg, " " )
	if ( _options.debug ) then
		print( _options.type .. " " .. input )
	else
		print( input )
	end
	io.flush()
	if ( _options.log == true ) then
		_utility._log( input )
	end
end

function _utility.debugPrint( ... )
	arg = {...}
	input = table.concat( arg, " " )
	if ( _options.debug ) then
		_utility.print( "Debug:", input )
	end
end

function _utility._log( ... )
	file,err = io.open( "logs/" .. _options.type .. _options.logfile .. _options.start_time .. ".txt", "a")
	if err then return _,err end
	arg = table.concat( {...}, " " )
	file:write( "\n" .. 	arg )
	file:close()
end
--[[
file = io.open("testRead.txt","a")
myText = "\nHello"
file:write(myText)
file:close()
]]--
function round(num, idp)  --it rounds numbers.
	return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

function bargraph(num, den, len)
	--funny bug, but if num&den == 1, (filled*len)==(desired*len)
	if ( (den == inf) or (den == nil) ) or (den <= 0) then
		den = len
	end
	per = len / den
	--if ( (per == inf) or (per == nil) ) or (per <= 0) then
	--	per = 1
	--end
	filled = round( ((num / den) * per), 2)
	return "("..num.."/"..den.."["..string.rep("=", round((filled*len),0) )..string.rep("-", round(len - (filled*len), 0) ).."]"..filled.."/"..len..")"
end

function table.copy(t)
  local u = { }
  for k, v in pairs(t) do u[k] = v end
  return setmetatable(u, getmetatable(t))
end

function _utility.arrayInsert( ary, val, idx )
    -- Needed because table.insert has issues
    -- An "array" is a table indexed by sequential
    -- positive integers (no empty slots)
    local lastUsed = #ary + 1
    local nextAvail = lastUsed + 1

    -- Determine correct index value
    local index = tonumber(idx) -- Don't use idx after this line!
    if (index == nil) or (index > nextAvail) then
        index = nextAvail
    elseif (index < 1) then
        index = 1
    end

    -- Insert the value
    if ary[index] == nil then
        ary[index] = val
    else
        -- TBD: Should we try to allow for skipped indices?
        for j = nextAvail,index,-1 do
            ary[j] = ary[j-1]
        end
        ary[index] = val
    end
end

function _utility.compareAnyTypes( op1, op2 ) -- Return the comparison result
    -- Inspired by http://lua-users.org/wiki/SortedIteration
    local type1, type2 = type(op1),     type(op2)
    local num1,  num2  = tonumber(op1), tonumber(op2)
    
    if ( num1 ~= nil) and (num2 ~= nil) then  -- Number or numeric string
        return  num1 < num2                     -- Numeric compare
    elseif type1 ~= type2 then                -- Different types
        return type1 < type2                    -- String compare of type name
    -- From here on, types are known to match (need only single compare)
    elseif type1 == "string"  then            -- Non-numeric string
        return op1 < op2                        -- Default compare
    elseif type1 == "boolean" then
        return op1                              -- No compare needed!
         -- Handled above: number, string, boolean
    else -- What's left:   function, table, thread, userdata
        return tostring(op1) < tostring(op2)  -- String representation
    end
end

function _utility.pairsByKeys (tbl, func)
    -- Inspired by http://www.lua.org/pil/19.3.html
    -- and http://lua-users.org/wiki/SortedIteration

    if func == nil then
        func = _utility.compareAnyTypes
    end

    -- Build a sorted array of the keys from the passed table
    -- Use an insertion sort, since table.sort fails on non-numeric keys
    local ary = {}
    local lastUsed = 0
    for key --[[, val--]] in pairs(tbl) do
        if (lastUsed == 0) then
            ary[1] = key
        else
            local done = false
            for j=1,lastUsed do  -- Do an insertion sort
                if (func(key, ary[j]) == true) then
                    _utility.arrayInsert( ary, key, j )
                    done = true
                    break
                end
            end
            if (done == false) then
                ary[lastUsed + 1] = key
            end
        end
        lastUsed = lastUsed + 1
    end

    -- Define (and return) the iterator function
    local i = 0                -- iterator variable
    local iter = function ()   -- iterator function
        i = i + 1
        if ary[i] == nil then
            return nil
        else
            return ary[i], tbl[ary[i]]
        end
    end
    return iter
end

function _utility.printVariable( var, name, tabs )
	--var is the variable you want to print.
	--name is the name you'll be seeing in the output, try something you can remember.
	--tabs is for internal use, don't pass it anything.
	var = var or "undeclared";
	name = name or type(var);
	tabs = tabs or 0;
	if type(var) == "string" then
		_utility.debugPrint( string.rep("\t", tabs)..name.." = "..string.format("%q", var) );
	elseif type(var) == "number" then
		_utility.debugPrint( string.rep("\t", tabs)..name.." = "..var );
	elseif ( name == "_G" ) then
		_utility.debugPrint( string.rep("\t", tabs).."_G = { GLOBAL -- Not recursing }" ); -- heh, infinite recursion is funny.
	elseif ( name == "loaded" ) then
		_utility.debugPrint( string.rep("\t", tabs).."loaded = { loaded -- Not recursing }" ); -- heh, infinite recursion is funny.
	elseif ( name == "__index" ) then
		_utility.debugPrint( string.rep("\t", tabs).."__index = { __index -- Not recursing }" ); -- heh, infinite recursion is funny.
	elseif type(var) == "table" then
		_utility.debugPrint( string.rep("\t", tabs)..name.." = {" );
		for k,v in _utility.pairsByKeys(var) do
			_utility.printVariable(v,tostring(k),tabs+1);
		end
		_utility.debugPrint( string.rep("\t", tabs).."}" );
	elseif type(var) == "function" then
		_utility.debugPrint( string.rep("\t", tabs)..name.." = function(".." ... "..")" ); -- Prototype?
	elseif type(var) == "thread" then
		_utility.debugPrint( string.rep("\t", tabs)..name.." = thread(".." ... "..")" ); -- PID?
	elseif type(var) == "userdata" then
		_utility.debugPrint( string.rep("\t", tabs)..name.." = userdata(".." ... "..")" );
	elseif type(var) == "boolean" then
		if ( var ) then
			_utility.debugPrint( string.rep("\t", tabs)..name.." = boolean(true)" );
		else
			_utility.debugPrint( string.rep("\t", tabs)..name.." = boolean(false)" );
		end
	elseif type(var) == "nil" then
		_utility.debugPrint( string.rep("\t", tabs)..name.." = nil" );
	else
		--We don't know what it is
		--nil, _boolean, _number, _string, _userdata, _function, _thread, and _table
		_utility.debugPrint( name..": ", var )
	end
end

