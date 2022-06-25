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

local debug = function() end

local test = love.audio.newSource(makepath("res", "boom.ogg"), "static")
local func = { "getPitch", "getVolume"}

--debug(inspect(debug.getmetatable(test)))

for _, name in pairs(func) do
	snd[name] = function(self, ...)
		return self.sound[name](self.sound, ...)
	end
end

function Sound(stream, ...)
	local obj = snd:instance()
	local path = makepath(...)
	obj.sound = love.audio.newSource(path, stream and "stream" or "static")
	obj.errstart = false
	obj.path = path
	debug("SOUND: created "..tostring(obj).." path:'"..path.."' length:"..tostring(obj:length()))
	return obj
end

local function checksnd(sound)
	sound.sound:play()
	if not sound.sound:isPlaying() then
		sound:seek(1)
		error("I hate this!"..inspect(sound))
	end
	sound.errstart = false
end

function snd:play()
	debug("SOUND: played "..tostring(self))
	local b = self.sound:play()
	if not b then
		self.errstart = true
		self.sound:seek(1);
		self.sound:setVolume(0.1);
		Event(checksnd, self).clock = os.clock() + 5
	end
end

function snd:volume(val)
	if val < 0 or val > 1 then
		-- If you will pass negative volume to sound : ALL LOVE sound engine will be broked :D
		-- Buggy shit
		print("SOUND: trying to set STRANGE volume "..tostring(val).." for "..tostring(self))
		val = math.max(math.min(val, 0.001), 1.0)
	end
	self.sound:setVolume(val)
end

function snd:pause()
	debug("SOUND: paused "..tostring(self))
	self.sound:pause()
end

function snd:stop()
	debug("SOUND: stopped "..tostring(self))
	self.sound:stop()
end

function snd:seek(val)
	return self.sound:seek(val)
end

function snd:tell()
	return self.sound:tell()
end

function snd:loop(val)
	self.sound:setLooping(val)
end

function snd:is_looping(val)
	return self.sound:isLooping(val)
end

function snd:is_playing(val)
	return self.sound:isPlaying(val) or self.errstart
end

function snd:pitch(val)
	self.sound:setPitch(val)
end

function snd:release(val)
	debug("SOUND: DESTROYED "..tostring(self))
	self.sound:release(val)
	self.sound = nil
end

function snd:length(val)
	return self.sound:getDuration()
end
