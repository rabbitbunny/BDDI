_options = {
	["GUI_runtime"] = "lua5.1",
	["CLI_runtime"] = "luajit-2.0.0-beta2",
	["version"] = 0.01,
	["debug"] = true,
	["debugLog"] = false,
	["type"]= "server",
	["controller"] = nil,
	["logfile"] = "log.txt",
};
if ( _options.debug ) then
	print( "Debug:  Loaded "..debug.getinfo(1).source )
end