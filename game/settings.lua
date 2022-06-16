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


require("base");
local input = require("input")
local draw = require "graphics"
local gui = require("gui").new()
local locale = require "locale"
require("code/deepprint")

local settings = {};

gui:clear()
local bgbomb = gui:insert(require"boombg");
local backb = gui:button(locale.t_back_button, function() saveSettings(); setScreen(require "menu"); playSound("resources/interact.ogg") return 1 end, 0, 0, 200, 200)
local m_scroll = gui:scroll(locale.t_music_volume, var_vol_music_max,0,0,100,100)
local s_scroll = gui:scroll(locale.t_sound_volume, var_vol_sound_max,0,0,100,100)
local f_debug = gui:switch(locale.t_debug, _DEBUG, 0,0,100,100)
local f_spec = gui:switch(locale.t_off_particles, var_no_particles, 0,0,100,100)

function settings.init()
	bgbomb = gui:insert(require"boombg", 1);
	playMusic("resources/menu.mp3");
end

function settings.draw() 
	draw.color(255,255,255,255);
	draw.rectangle("fill", 0, 0, WIN.w, WIN.h);
	gui:call("draw")
	draw.color(255,255,255,255);
	local py = WIN.h/3 - 30;
  draw.sprites.drawCenter("GameLogo", WIN.w/2, py, 400, 100);
  py = py + 100 + 10
  backb:moveCenter(WIN.w/2, py, 300, 50);
  py = py + 35 + 10
  m_scroll:moveCenter(WIN.w/2, py, 300, 30)
  py = py + 25 + 10
  s_scroll:moveCenter(WIN.w/2, py, 300, 30)
  py = py + 35 + 10
  f_debug:moveCenter( WIN.w/2 - 77, py, 145, 30)
  f_spec:moveCenter( WIN.w/2 + 77, py, 145, 30)
  
  draw.color(0,0,0,255);
  draw.textCenter(locale.t_copyright, WIN.w/2, WIN.h - 10, 20);
  draw.color(255,255,255,255);
  
end

function settings.update()
	gui:update()
	var_vol_sound_max = s_scroll.value
	var_vol_music_max = m_scroll.value
	var_no_particles = f_spec.value
	_DEBUG = f_debug.value
end

return settings;
