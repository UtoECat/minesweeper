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

-- High-level sound system :p

VAR_VOLUME_SOUND = 0.5
VAR_VOLUME_MUSIC = 0.4
VAR_VOLUME_COEFFICIENT = 0.02

function playSound(...)
	local o = love.audio.newSource(makepath(...), "static")
	o:play()
	o:setVolume(VAR_VOLUME_SOUND)
	o = nil
end

local old_music = nil
local music = nil
local volume = 0
local playlist = nil

function updateMusic()
	if old_music then
		volume = volume - VAR_VOLUME_COEFFICIENT
		old_music:volume(volume * VAR_VOLUME_MUSIC)
		
		if music then
		music:volume((1.0 - (volume)) * VAR_VOLUME_MUSIC)
		end
		
		if volume < VAR_VOLUME_COEFFICIENT then
			old_music:stop()
			old_music:release()
			old_music = nil
			volume = 1.0
		end
	elseif music and volume < 1.0 - VAR_VOLUME_COEFFICIENT then
		volume = volume + VAR_VOLUME_COEFFICIENT
		music:volume(volume * VAR_VOLUME_MUSIC);
	end
	
	if playlist and music and not music:is_playing() then
		nextMusic()
	end
end

function push_new(m)
	if old_music then
		old_music:stop()
		old_music:release()
	end
	old_music = music
	music = m
end

function dbgMusic()
	if music then
		music:seek(music:length() - 5)
	end
end

function playMusic(...)
	local o = Sound(true, makepath(...))
	o:volume(0)
	o:play()
	o:loop(true)
	playlist = nil
	push_new(o)
end

function stopMusic()
	push_new()
end

function playMusicPlaylist(t)
	if not t then error("no function passed!") end
	playlist = t
	nextMusic()
end

function nextMusic()
	if not playlist then return end
	local fn = playlist()
	local o = Sound(true, fn)
	o:play()
	o:volume(0)
	push_new(o)
end

local valid_formats = {
	".wav", ".mp3", ".ogg", ".oga", ".ogv", ".abc", ".mid", ".pat", ".flac"
}

local check_format = {}

for k,v in pairs(valid_formats) do
	check_format[v] = true
end

local function inext(t, k)
	if not k then return t[1] and 1, t[1] end
	if not t[k] then return nil end
	local k = k + 1
	if t[k] then return k, t[k] end
end

function dir2playlist(...)
	local str = makepath(...)
	str = string.sub(str, #str, #str) == PATH_DELIM and str or str..PATH_DELIM
	
	if love.filesystem.getInfo(str, "directory") then
		local pl = love.filesystem.getDirectoryItems(str)
		
		local i = 1
		while i <= #pl do -- remove all directories and no media files :)
			local v = str..pl[i]
			local info = love.filesystem.getInfo(v)
			if not info or info.type ~= "file" then -- if filetype is bad
				table.remove(pl, i) -- remove audio from playlist :)
				print(v.." is not a file")
			else
				local arg = v:sub(v:find("%.[^%.]*$"))
				if not check_format[arg] then
					print("format "..arg.." is not valid. Skipping...")
					table.remove(pl, i)
				else
					pl[i] = v
					i = i + 1
				end
			end
		end
		
		if not inext(pl) then return end; -- if no any files stay :D
		print(inspect(pl))
		
		return function() -- playlist function
			local v
			local key = pl.key
			print("getting next music")
			while not v do
				key, v = inext(pl, key)
			end
			pl.key = key
			return v
		end
	else
		error("bad direcory path : "..str)
	end
end
