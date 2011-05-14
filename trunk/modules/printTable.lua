--[[
	print tables for debug
]]--

_utility.debugPrint("Starting "..debug.getinfo(1).source)

do

local printtable = {}
printtable.__index	=	printtable
printtable.modules = { }

function printtable.load( f )
	t, err = table.load( f )
	if t then
		if ( t.hashes == nil ) then
			t.hashes = { }
		end
		for k,v in ipairs(t.raw) do
			t.hashes[v["hash"]] = true
		end
		setmetatable(t,printtable)
	end
	return t, err
end

function printtable.create(title, ...)
	arg = {...}
	arg["printable"] = 1
	local raw = {}
	setmetatable(raw,printtable)
	raw.title				= title;
	raw.columns	= arg;
	raw.hashes		= { };
	raw.raw				= { };
	return raw
end

function printtable:combine(child)
	print( "combining.." )
	for k,v in ipairs(child.raw) do
		--printvariable(v.hash)
		if ( not self:is_hash(v.hash)) then
			--print("\tInserting "..v.hash )
			self:insert(v)
		end
	end
end

function printtable:save(filename)
	return assert( table.save( self, filename ) == 1 )
end

function printtable:insert_hash(hash)
	self.hashes[hash] = true
end
function printtable:is_hash(tabel)
	if ( type(tabel) == "table" ) then
		hash = self:makehash(tabel)
	else
		hash = tabel
	end
	if ( self.hashes[hash] ) then
		return true
	end
	return false
end

function printtable:sethash(...)
	self.hash = {...}
	self.hashtable = { }
	for k,v in ipairs(self.hash) do
		for j,u in ipairs(self.columns) do
			if ( v == u ) then
				table.insert(self.hashtable, j)
			end
		end
	end
end

function printtable:makehash(tabel)
	hash = tostring(_options.version);
	_utility.printVariable(self.hashtable)
	for k,v in ipairs(self.hashtable) do
		hash = hash.."|"..tabel[v]
	end
	return hash
end

function printtable:insert(tabel) 
	tabel["printable"] = 1
	tabel["hash"] = self:makehash(tabel)
	table.insert(self.raw, tabel)
	self.hashes[tabel["hash"]] = true
end

function printtable:count( printable )
	if ( printable ) then
		local a = 0
		for k,v in ipairs(self.raw) do
			if ( v.printable == 1 ) then
				a = a + 1
			end
		end
		return a
	else
		return #self.raw
	end
end

function printtable:sort(field, direction, field2, direction2)
	if ( field2 ) then
		for k,v in ipairs(self.columns) do
			if ( field == v ) then col = k end
			if ( field2 == v ) then col2 = k end
		end
		if ( direction == "ASC" ) then
			if ( direction2 == "ASC" ) then
				table.sort(self.raw, function(a,b) if ( a[col] == b[col] ) then return a[col2]<b[col2] else return a[col]<b[col] end end )
			else
				table.sort(self.raw, function(a,b) if ( a[col] == b[col] ) then return a[col2]>b[col2] else return a[col]<b[col] end end )
			end
		else
			if ( direction2 == "ASC" ) then
				table.sort(self.raw, function(a,b) if ( a[col] == b[col] ) then return a[col2]<b[col2] else return a[col]>b[col] end end )
			else
				table.sort(self.raw, function(a,b) if ( a[col] == b[col] ) then return a[col2]>b[col2] else return a[col]>b[col] end end )
			end
		end
	else
		for k,v in ipairs(self.columns) do if ( field == v ) then col = k end end
		if ( direction == "ASC" ) then
			table.sort(self.raw, function(a,b) return a[col]<b[col] end )
		else
			table.sort(self.raw, function(a,b) return a[col]>b[col] end )
		end
	end
end

function printtable:filter( field, comp, field2 )
	for k,v in ipairs(self.columns) do
		if ( field == v ) then
			colA = k
		end
		if ( field2 == v ) then
			colB = k
		end
	end
	if ( colA ~= nil ) then
		sub1 = "arg2[1]["..colA.."]"
	else
		sub1 = tostring(field)
	end
	if ( colB ~= nil ) then
		sub2 = "arg2[1]["..colB.."]"
	else
		sub2 = tostring(field2)
	end
	line = "arg2 = {...} if ( "..sub1.." "..comp.." "..sub2.." ) then return true else return false end "
	for k,v in pairs(self.raw) do
		if ( assert(loadstring(line))(v) == true ) then
			k = nil
			--v.printable = 0
		end
	end
end

function printtable:resetfilters()
	for k,v in ipairs(self.raw) do
		v.printable = 1
	end
end

function printtable:print(subtitle, maxrows)
	--find longest
	long = {};
	for k,v in pairs(self.columns) do
		long[k] = string.len(tostring(v))
	end
	for k,v in pairs(self.raw) do
		for b,d in ipairs(v) do
			if ( type( d ) == 'number' ) then
				data = string.len(tostring(round(d,2)))
			else
				data = string.len(tostring(d))
			end
			if ( data > long[b] ) then
				long[b] = data
			end
		end
	end
	
	--print lines
	linestring = " ";
	for k,v in ipairs(self.columns) do
		if ( #v > long[k] ) then
			v = string.sub( v, 1, long[k])
		else
			v = string.rep(" ", ( long[k] - #v ) ) .. v;
		end
		linestring = linestring .. v .. "  ";
	end
	local title = self.title
	if ( subtitle ) then
		title = self.title.." -- "..subtitle
	end
	print( "<" .. string.rep("-", math.floor(((#linestring-#title)/2)-2)).. title .. string.rep("-", math.ceil(((#linestring-#title)/2)-2)).. ">" )
	print( linestring );
	if maxrows then rows = 0 end
	for row, data in ipairs(self.raw) do
		if ( data["printable"] == 1 ) then
			--printvariable(data)
			linestring = " ";
			for b,d in ipairs(data) do
				if ( type( d ) == 'number' ) then
					if ( string.len(tostring(round(d,2))) > long[b] ) then
						data = string.rep(" ", ( long[b] - string.len(tostring(round(d,2)))) ) .. string.sub( tostring(round(d,2)), 1, long[b]);
					else
						data = string.rep(" ", ( long[b] - string.len(tostring(round(d,2))) ) ) .. round(d,2);
					end
				else
					if ( string.len(tostring(d)) > long[b] ) then
						data = string.rep(" ", ( long[b] - string.len(tostring(d))) ) .. string.sub( tostring(d), 1, long[b]);
					else
						data = string.rep(" ", ( long[b] - string.len(tostring(d))) ) .. d;
					end
				end
				linestring = linestring .. data .. "  ";
			end
			print( linestring );
			if maxrows then
				rows = rows + 1
				if rows == maxrows then
					break
				end
			end
		end
	end
	if maxrows then rows = nil end
end

--[[
names = {
	"stuff",
	"things",
	"butt",
	"face",
	"nom",
	"nom nom nom",
	"omgnom",
	"lmaoomgnom",
	"inglip",
	"boobs"
}

test = printtable.create("test", "name", "input", "value")
test:sethash("input", "value");
for x = 1,10 do
	--print( "x:", x, " x*x: ", x*x )
	test:insert( { names[x], x, x*x } );
end
print( "---Pre Sort---");
test:print();
print( "---Filtering---" )
test:filter("input", "<", 9 )
print( "---Post Filter---");
test:print();
print( "---Sorting---");
test:sort("name", "ASC");
print( "---Post Sort---");
test:print();
print( "---Sorting---");
test:sort("value", "DEC");
print( "---Post Post Sort---");
test:print();
]]--

	return printtable
end

_utility.debugPrint("Finished "..debug.getinfo(1).source)