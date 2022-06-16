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

local scrollpos = 0
local help = {
	"Minesweeper is a game about finding bombs on field",
	"You are copaesh yami, thtobi ispolsovat a minedetector",
	"Minedetector can tells you count of bombs nearby",
	"Nine cells around cell you looking at, contain number of bombs,",
	"That minedetector tells you in this center cell",
	"If you vikopaech yamu in cell, where bomb located, you will die.",
	"My english is very funckin bad, sorry :(",
	"V processe kopania, you can find interesting things like gold coins",
	"At this moment, you cannot do something with them :D",
	"",
	"This game is developed by UtoECat",
	"License GNU GPL 3.0",
	"See file LICENSE near the game, to get more info :)",
	{name="utoecat", w = 300, h = 300}
}

local maxy = 0

function game.draw() 
	draw.color(255,255,255,255);
	draw.rectangle("fill", 0, 0, WIN.w, WIN.h);
	gui:call("draw")
	backb:move(WIN.w - 105, 5, 100, 35);
	draw.color(0,0,0,255);
	local py = WIN.h/3 - 30 - scrollpos;
  draw.textCenter(locale.t_howtoplay, WIN.w/2, py, 55, 0);
  py = py + 55/2+150/2 + 10
  draw.color(255,255,255)
	draw.sprites.drawCenter("controls", WIN.w / 2, py, 251 *1.5, 150, 0)
  py = py + 150/2 + 25/2 + 10
  draw.color(0,0,0)
  for k,v in pairs(help) do
  	if type(v) == "string" then
  		draw.color(0,0,0)
  		draw.textCenter(v, WIN.w / 2, py, 25, 0)
  		py = py + 25/2 + 10
  	else
  		draw.color(255,255,255)
  		draw.sprites.drawCenter(v.name, WIN.w / 2, py + v.h/2, v.w, v.h, 0)
  		py = py + v.h/2 + 5
  	end
  end
  py = py + 10
  maxy = py
  
  draw.color(0,0,0,255);
  draw.textCenter(locale.t_copyright, WIN.w/2, WIN.h - 10, 20);
  draw.color(255,255,255,255);
end

function game.update()
	gui:update()
	scrollpos = scrollpos - input:getDevice("mouse").wheel*10
	if input:isPressed("ZOOM+") then
		scrollpos = scrollpos - 10
	elseif input:isPressed("ZOOM-") then
		scrollpos = scrollpos + 10
	end
	scrollpos = math.clamp(scrollpos, 0, maxy)
end

return game;
