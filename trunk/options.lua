_options = {
	["GUI_runtime"] = "lua5.1",
	["version"] = 0.01,
	["debug"] = true,
	["debugLog"] = false,
	["type"]= "server",
	["controller"] = nil,
	["logfile"] = "log.txt",
	["job"] = {
		["title"] = "Velomobile",
		["database"] = {
			["username"] = "cluster",
			["password"] = "password",
			["location"] = "127.0.0.1"
		},
		["prototype"] = {
			["motor"] = true,
			["battery"] = {
				["type"] = true,
				["cells"] = true,
				["strings"] = true,
			},
			["primary_pulley"] = true,
			["secondary_pulley"] = true,
			["belt"] = true,
		},
	},
};
if ( _options.debug ) then
	print("Finished "..debug.getinfo(1).source)
end