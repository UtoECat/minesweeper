-- This file restores all important packages and _G enviroment into default state
local require = require
local next = next
local _ORIGINAL_LOADED = _ORIGINAL_LOADED
local _ORIGINAL_G = _ORIGINAL_G
local _G = _G

for k,v in pairs(package.loaded) do
	print("Package "..tostring(k).." is unloaded!")
	package.loaded[k] = nil
end

for k,v in pairs(_ORIGINAL_LOADED) do
	print("Package "..tostring(k).." is restored!")
	package.loaded[k] = v
end

for k,v in next, _G, nil do 
	_G[k] = nil
end

for k,v in next, _ORIGINAL_G, nil do
	_G[k] = v
end

love.audio.stop()
collectgarbage();
collectgarbage();
collectgarbage();

dofile("main.lua")
