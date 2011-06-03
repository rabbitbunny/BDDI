--[[

usage: {filename} [options] <type> <controller>

options:
	-debug		prints debugging in to terminal

	<type>
		server
			should be running at all times, one per cluster
		director
			get work from server, caches for local nodes, one per machine
		node
		 does work
		 
	<controller>
		IP is whatever is controlling this subtype, not needed for server
		
lua5.1 main.luc
lua5.1 main.luc -debug
lua5.1 main.luc -debug director 127.0.0.1
lua5.1 main.luc -debug node 127.0.0.1
]]--
require("options");
require("utilities");
require("modules/modules");

_options.graphics = false

--_utility.printVariable(_G)

if ( arg[-1] == _options.JIT_runtime ) then
	_options.runtime = _options.JIT_runtime
else
	_options.runtime = _options.Lua_runtime
end
--we should recurse arg, 1-(n-2), for flags then grab the last two if they're valid data.
-- as it is we can't use the --debug flag so... need to work on that
_options.type = "server"
_options.controller = nil
if ( #arg > 0 ) then
	--_utility.debugPrint( "found cli args" )
	--for k,v in ipairs(arg) do
	-- _utility.debugPrint( k, v )
	--end
	_options.type = arg[1]
	_options.controller = arg[2]
else
	--_utility.debugPrint("did not read commandline args.")
end

_modules._load(_options.type);

_modules[_options.type].main()

--_utility.printVariable(_G)
