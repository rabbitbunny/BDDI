--[[
--little debugging functions

]]--

_utility = {}
utility.__index = utility

function utility.CentralPrint( stuff )
	print(stuff)
end

CentralPrint("Loaded "..debug.getinfo(1).source)
