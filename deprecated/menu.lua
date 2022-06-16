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

local menu = {};

gui:clear()
local bgbomb = gui:insert(require"boombg");
local playb = gui:button(locale.t_play_button, function() setScreen(require "game/play"); playSound("resources/interact.ogg") return 1 end, 0, 0, 200, 200)
local settb = gui:button(locale.t_settings_button, function() setScreen(require "game/settings"); playSound("resources/interact.ogg") return 1 end, 0, 0, 200, 200)
local achb = gui:button(locale.t_ach_button, function() setScreen(require "game/achievments"); playSound("resources/interact.ogg") return 1 end, 0, 0, 200, 200)
local exitb = gui:button(locale.t_exit_button, function() setScreen(exit_screen); playSound("resources/interact.ogg") return 1 end, 0, 0, 200, 200)
local helpb = gui:button(locale.t_help_button, function() setScreen(require "game/howtoplay"); playSound("resources/interact.ogg") return 1 end, 0, 0, 200, 200)
local fs_scroll = gui:scroll(locale.t_field_size, var_field_size,0,0,100,100)
local mp_scroll = gui:scroll(locale.t_mines_percent, var_mines_percent,0,0,100,100)

function menu.init()
	bgbomb = gui:insert(require"boombg", 1);
	love.window.setTitle("Minesweeper 1.0")
	playMusic("resources/menu.mp3");
	fs_scroll.value = var_field_size
	mp_scroll.value = var_mines_percent
end

function menu.draw() 
	draw.color(255,255,255,255);
	draw.rectangle("fill", 0, 0, WIN.w, WIN.h);
	gui:call("draw")                                           --
	local py = WIN.h/3 - 30;
	draw.color(255,255,255,255);
  draw.sprites.drawCenter("GameLogo", WIN.w/2, py, 400, 100); --
  py = py + 100 + 10
  fs_scroll:moveCenter(WIN.w/2, py, 300, 25)
  py = py + 25 + 5
  mp_scroll:moveCenter(WIN.w/2, py, 300, 25)
  py = py + 25*2 + 5
  playb:moveCenter(WIN.w/2, py, 300, 50);
  py = py + 50 + 10
  settb:moveCenter(WIN.w/2 - 77, py, 145, 50);
  exitb:moveCenter(WIN.w/2 + 77, py, 145, 50);
  py = py + 50 + 10
  draw.color(0,0,0,255);
  draw.textCenter(locale.t_copyright, WIN.w/2, WIN.h - 10, 20);
  draw.color(255,255,255,255);
  achb:move(WIN.w - 105, WIN.h - 5 - 35, 100, 35);
  helpb:move(WIN.w - 105, WIN.h - 10 - 35*2, 100, 35)
end

function menu.update()
	gui:update()
	var_mines_percent = mp_scroll.value
	var_field_size = fs_scroll.value
end

return menu;
