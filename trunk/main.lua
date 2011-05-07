--[[

usage: {filename} [options] <type> <controller>

options:
	-debug		prints debugging in to terminal
	-debugLog		prints to logfile

	<type>
		server
			should be running at all times
		director
			get work from server, caches for local nodes
		node
		 does work
		 
	<controller>
		IP is whatever is controlling this subtype, not needed for server
]]--
require("options");
require("utilities");
require("modules/modules");
_utility.debugPrint("Loaded "..debug.getinfo(1).source)
--require("modules/modules.lua")


--we should recurse arg, 1-(n-2), for flags then grab the last two if they're valid data.

if ( arg[0] == _options.CLI_runtime ) then
	_options.graphics = false
elseif ( arg[0] == _options.GUI_runtime ) then
	_options.graphics = true
end
-- see if we're in debug
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

require(_options.type);


_utility.printVariable(_G)
_utility.printVariable(arg)
_utility.printVariable(_options)

_utility.debugPrint("Finished "..debug.getinfo(1).source)