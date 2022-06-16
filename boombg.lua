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

local function drawboom(self)
		local f = self.frame > self.max and self.frame - 1 or self.frame;
		draw.color(255,255,255,255)
		draw.sprites.draw("boom", self.x, self.y, self.sz, self.sz, f, 0);
	end

local function makeboom(gui, x, y, sz) -- Boom effect
	local t = gui:blob()
	t.update = function(self)
		if self.frame > self.max then
			gui:remove(self)
		end
		if os.clock() > self.timer + 0.02 then
			self.timer = os.clock()
			self.frame = self.frame + 1
		end
	end
	t.draw = drawboom
	t.frame = 1
	t.x = x
	t.y = y
	t.sz = sz
	t.timer = os.clock()
	t.max = draw.sprites.framesCount("boom")
end

local bgbomb = gui:blob(0,0,0,0);
bgbomb.bombs = {}
bgbomb.timer = os.clock()

local startpos = -90

function bgbomb.update(self)
	if var_no_particles then return end
	for k = 1, #(self.bombs), 1 do
		local v = self.bombs[k]
  	v.y = v.y + v.spd
  	v.a = v.a + v.aspd
  	if v.y+v.s > WIN.h - 200 or v.x+v.s > WIN.w then
  		v.fade = v.fade + v.spd*5;
  	else
  		v.fade = v.fade - v.spd*2;
  	end
  	if v.fade > 255 then
  		v.y = startpos
  		v.x = math.random(0, WIN.w)
  		v.spd = math.random(10, 100) / 40
  		v.aspd = math.random(0.01,0.05)
  	end
  end
  
  if (#self.bombs) < 30 and os.clock() > self.timer + 0.05 then
  	self.timer = os.clock()
  	local t = {
  		x = math.random(0, WIN.w),
  		y = startpos,
  		s = math.random(15, 50),
  		a = math.random(0, 360),
  		spd = math.random(10, 100) / 40,
  		aspd = math.random(-0.04,0.04),
  		fade = 255
  	}
  	self.bombs[#self.bombs + 1] = t
  end
  if recs_collision(self,gui:mouse()) and input:isPressed("LMB") then 
		if self.onclick then self:onclick(); end
	end
	var_counter = var_counter + 1;
end

function bgbomb.draw(self)
	for k, v in next, self.bombs, nil do
		draw.color(255,255,255,255 - v.fade)
  	draw.sprites.drawCenter("bomb", v.x + v.s/2, v.y + v.s/2, v.s, v.s, 0, v.a);
  end
  self:move(0,0,WIN.w, WIN.h)
end

function bgbomb.onclick(self)
	for k, v in ipairs(self.bombs) do
  	if recss_collision(v, gui:mouse()) then
  		makeboom(self.gui, v.x - v.s * 0.5, v.y - v.s * 0.5, v.s * 2);
  		playSound("resources/boom.ogg")
  		v.y = startpos
  		v.x = math.random(0, WIN.w)
  		v.spd = math.random(10, 100) / 40
  		v.aspd = math.random(0.01,0.05)
  	end
  end
end

bgbomb.makeboom = makeboom

return bgbomb
