--[[
--little debugging functions

]]--

_utility = {}
_utility.__index = _utility

function _utility.centralPrint( ... )
	print( ... )
end

function _utility.debugPrint( ... )
	if ( _options.debug ) then
		_utility.centralPrint( "Debug:", ... )
	end
end

function round(num, idp)  --it rounds numbers.
	return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

local function arrayInsert( ary, val, idx )
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

local function compareAnyTypes( op1, op2 ) -- Return the comparison result
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

function pairsByKeys (tbl, func)
    -- Inspired by http://www.lua.org/pil/19.3.html
    -- and http://lua-users.org/wiki/SortedIteration

    if func == nil then
        func = compareAnyTypes
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
                    arrayInsert( ary, key, j )
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
		print( string.rep("\t", tabs)..name.." = "..string.format("%q", var) );
	elseif type(var) == "number" then
		print( string.rep("\t", tabs)..name.." = "..var );
	elseif ( name == "_G" ) then
		print( string.rep("\t", tabs).."_G = { GLOBAL -- Not recursing }" ); -- heh, infinite recursion is funny.
	elseif ( name == "loaded" ) then
		print( string.rep("\t", tabs).."loaded = { loaded -- Not recursing }" ); -- heh, infinite recursion is funny.
	elseif ( name == "__index" ) then
		print( string.rep("\t", tabs).."__index = { __index -- Not recursing }" ); -- heh, infinite recursion is funny.
	elseif type(var) == "table" then
		print( string.rep("\t", tabs)..name.." = {" );
		for k,v in pairsByKeys(var) do
			_utility.printVariable(v,tostring(k),tabs+1);
		end
		print( string.rep("\t", tabs).."}" );
	elseif type(var) == "function" then
		print( string.rep("\t", tabs)..name.." = function(".." ... "..")" ); -- Prototype?
	elseif type(var) == "thread" then
		print( string.rep("\t", tabs)..name.." = thread(".." ... "..")" ); -- PID?
	elseif type(var) == "userdata" then
		print( string.rep("\t", tabs)..name.." = userdata(".." ... "..")" );
	elseif type(var) == "boolean" then
		if ( var ) then
			print( string.rep("\t", tabs)..name.." = boolean(true)" );
		else
			print( string.rep("\t", tabs)..name.." = boolean(false)" );
		end
	elseif type(var) == "nil" then
		print( string.rep("\t", tabs)..name.." = nil" );
	else
		--We don't know what it is
		--nil, _boolean, _number, _string, _userdata, _function, _thread, and _table
		print( name..": ", var )
	end
end


_utility.debugPrint("Loaded "..debug.getinfo(1).source)
