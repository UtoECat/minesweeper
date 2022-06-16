--[[
ECS-Editor
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
local input = require("input");
local draw = require "graphics";
local menu = require "menu"
local locale = require "locale"

local loading = {};
local points = {"...", ",..", ",,.", ",,,", ".,,", "..,"}
local text = locale.t_loading
local lbprog = 0;
local i = 1

function loading.draw() 
	draw.color(255,255,255,255)
	draw.rectangle("fill",0,0, WIN.w, WIN.h)
	draw.color(0,0,0,255)
  draw.size(3);
  draw.rectangleCenter("line",WIN.w/2,WIN.h/2,WIN.w/3*2,20);
  local lbmax = WIN.w/3*2-6;
  draw.textCenter("Loading" .. points[math.floor(i)], WIN.w/2, WIN.h/2 - 30, 30);
  draw.rectangle("fill",WIN.w/2 - lbmax/2,WIN.h/2 - 7,lbmax * lbprog, 20-6);
end

local final = false

function loading.update()
	lbprog = lbprog + 0.01;
  if lbprog > 1.0 then
  	if not final then setScreen(menu); playSound("resources/interact.ogg") end
  	final = true
    lbprog = 1.0;
  end;
  i = i + 0.1
  if i > 6.5 then i = 1 end
end

-- Resources

draw.sprites.registerTexture("GameLogo", "resources/logo.png")
draw.sprites.registerTexture("bomb", "resources/bomb.png")
draw.sprites.registerTexture("ground", "resources/ground.png")
draw.sprites.registerTexture("ground1", "resources/onground1.png")
draw.sprites.registerTexture("ground2", "resources/onground2.png")
draw.sprites.registerTexture("ground3", "resources/onground3.png")
draw.sprites.registerTexture("ground4", "resources/onground4.png")
draw.sprites.registerTexture("ground5", "resources/onground5.png")
draw.sprites.registerTexture("flag", "resources/flag.png")
draw.sprites.registerTexture("mogila", "resources/mogila.png")
draw.sprites.registerTexture("coin", "resources/coin.png")
draw.sprites.registerTexture("controls", "resources/controls.png")

draw.sprites.registerTexture("shovel", "resources/shovel.png")
draw.sprites.registerTexture("utoecat", "resources/shit_maker.jpg")
draw.sprites.registerTexture("underground", "resources/underground.png")
draw.sprites.registerSprite("boom", "resources/boom_anim.png", {
	{1,1,50,50},
	{51,1, 50,50},
	{101,1,50,50},
	{151,1,50,50},
	{201,1,50,50},
	{251,1,50,50},
	{301,1,50,50}
})



return loading;
