--[[
Copyright (C) UtoECat 2022-2022

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

local new_sound = nil;
local get_new_sound = nil
local sound = nil;
local soundfilename = "";

var_vol_sound_max = 1.0;
var_vol_music_max = 1.0;

function updateSound()
  if new_sound then
    local vol = new_sound:getVolume();
    vol = vol + 0.01;
    new_sound:setVolume(vol);
    if sound then sound:setVolume(var_vol_music_max - vol); end;
    if vol > var_vol_music_max-0.01 then
      if sound then
        sound:stop();
        sound:release();
      end;
      sound = new_sound;
      new_sound = nil;
    end;
  elseif sound then
  	sound:setVolume(var_vol_music_max);
  end
  if get_new_sound and sound and not sound:isPlaying() and not new_sound then
  	sound = love.audio.newSource(get_new_sound(), "stream");
  	sound:play()
  end
end;

function playSound(file)
  local snd = love.audio.newSource(file,"static");
  snd:setVolume(var_vol_sound_max);
  snd:play();
end;

function playMusic(file, n)
	if file == soundfilename then return end;
	if n == get_new_sound and type(n) ~= "nil" then return end
	soundfilename = file;
  if new_sound then
    new_sound:stop();
    new_sound:release();
  end;
  get_new_sound = false
  new_sound = love.audio.newSource(file,"stream");
  new_sound:setVolume(0);
  if type(n) == "function" then
  	get_new_sound = n
  else
  	new_sound:setLooping(true);
  end
  new_sound:play();
  print("sound attached!")
end;


