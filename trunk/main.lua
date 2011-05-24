--[[

usage: {filename} [options] <type> <controller>

options:
	-debug		prints debugging in to terminal
	-debugLog		prints to logfile

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
_utility.debugPrint("Starting "..debug.getinfo(1).source)

_options.graphics = false
if ( arg[-1] == _options.GUI_runtime ) then
	_options.graphics = true
end

--we should recurse arg, 1-(n-2), for flags then grab the last two if they're valid data.
-- see if we're in debug
_utility.printVariable( arg )
if ( #arg > 1 ) then
	_utility.centralPrint( "yes")
	for k,v in ipairs( arg ) do
		print( k, v )
	end
end
if ( arg[1] == "-debug" ) then
	_options.debug = true
	_utility.debugPrint("found debug flag")
end
if ( arg[1] ~= nil ) then
	_utility.debugPrint("read commandline args.", arg[2], arg[3])
	if ( arg[2] == "server" ) or ( arg[2] == nil ) then
		_options.type = "server"
		_options.controller = nil
	elseif ( arg[2] == "director" ) then
		_options.type = "director"
		_options.controller = arg[3]
	elseif ( arg[2] == "node" ) then
		_options.type = "node"
		_options.controller = arg[3]
	end
else
	_utility.debugPrint("did not read commandline args.")
		_options.type = "server"
		_options.controller = nil
end


_modules._load(_options.type);

_utility.centralPrint("run module ".. _options.type)
_modules[_options.type].main()
_utility.centralPrint("stop module ".. _options.type)

_utility.printVariable(_G)

_utility.debugPrint("Finished "..debug.getinfo(1).source)