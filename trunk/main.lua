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
if ( arg[-1] == _options.GUI_runtime ) then
	_options.graphics = true
end

--we should recurse arg, 1-(n-2), for flags then grab the last two if they're valid data.
-- see if we're in debug
_utility.printVariable( arg )
if ( #arg > 0 ) then
	_utility.debugPrint( "found cli args" )
	for k,v in pairs(arg) do
	 _utility.debugPrint( k, v )
	end
end

if ( _options.type == nil ) then
	_utility.debugPrint("did not read commandline args.")
		_options.type = "server"
		_options.controller = nil
end


_modules._load(_options.type);

_utility.debugPrint("running module ".. _options.type)
_modules[_options.type].main()
_utility.debugPrint("module ".. _options.type .. " stopped")

_utility.printVariable(_G)

_utility.debugPrint("Finished "..debug.getinfo(1).source)