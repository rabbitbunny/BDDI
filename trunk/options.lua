_options = {
	["GUI_runtime"] = "lua5.1",
	["cluster"] = {
		["single"] = true,
	},
	["version"] = 0.01,
	["debug"] = true,
	["log"] = true,
	["type"]= "server",
	["controller"] = nil,
	["logfile"] = "log",
	["start_time"] = os.time(),
	["job"] = {
		["title"] = "default job",
		["database"] = {
			["username"] = "cluster",
			["password"] = "password",
			["location"] = "127.0.0.1"
		},
		["prototype"] = {
			["x"] = true,
			["y"] = true
		},
	},
};