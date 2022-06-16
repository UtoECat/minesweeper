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

local game = {};

gui:clear()
local bgbomb = gui:insert(require"boombg", 1);
local backb = gui:button(locale.t_back_button, function() setScreen(require "menu")
playSound("resources/interact.ogg") return 1 end, 0, 0, 200, 200)

function game.init()
	bgbomb = gui:insert(require"boombg", 1);
end

function game.draw() 
	draw.color(255,255,255,255);
	draw.rectangle("fill", 0, 0, WIN.w, WIN.h);
	gui:call("draw")
	draw.color(0,0,0,255);
	local py = WIN.h/3 - 30;
  draw.textCenter(locale.t_achievments, WIN.w/2, py, 55, 0);
  py = py + 100 + 10
  backb:moveCenter(WIN.w/2, py, 300, 50);
  draw.color(0,0,0,255);
  draw.textCenter(locale.t_copyright, WIN.w/2, WIN.h - 10, 20);
  draw.color(255,255,255,255);
end

function game.update()
	gui:update()
end

return game;
