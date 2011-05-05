--[[
--little debugging functions

]]--

_utility = {
	["test"] = 5,
}
function CentralPrint( stuff )
	print(stuff)
end

CentralPrint("Loaded "..debug.getinfo(1).source)
