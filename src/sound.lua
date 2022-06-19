--[[
This file is a part of Minesweeper game
Copyright (C) UtoECat 2022

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]

local snd = Object("Sound")

local test = love.audio.newSource(makepath("res", "boom.ogg"), "static")
local func = {"play", "pause", "stop", "seek", "tell", "getPitch", "getVolume"}

print(inspect(debug.getmetatable(test)))

for _, name in pairs(func) do
	local faa = debug.getmetatable(test)[name]
	snd[name] = function(self, ...)
		faa(self.sound, ...)
	end
end

function Sound(stream, ...)
	local obj = snd:instance()
	obj.sound = love.audio.newSource(makepath(...), stream and "stream" or "static")
	return obj
end

function snd:volume(val)
	self.sound:setVolume(val)
end

function snd:loop(val)
	self.sound:setLooping(val)
end

function snd:is_looping(val)
	self.sound:isLooping(val)
end

function snd:is_playing(val)
	self.sound:isPlaying(val)
end

function snd:pitch(val)
	self.sound:setPitch(val)
end
