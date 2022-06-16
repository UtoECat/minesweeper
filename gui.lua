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

local gui = {}

local input = require("input")
local draw = require "graphics"
local mouse = {x = 0, y = 0, w = 1, h = 1}

function gui.mouse()
	return mouse
end

function gui.remove(gui, t)
	for k,v in pairs(gui) do
		if v == t then
			table.remove(gui, k)
		end
	end
end

local function blobsimpleupd(self) 
			if recs_collision(self,mouse) and input:isPressed("LMB") then 
				if self.onclick then self:onclick(); end
			end
end

local function simplemove(self, x, y, w, h)
			self.x = x
			self.y = y or self.y
			self.w = w or self.w
			self.h = h or self.h
end

local function simplecenter(self, x, y, w, h)
			self:move(x - w/2, y - h/2, w, h)
		end

function gui.blob(blobs) 
	local t = {
		draw = false,
		update = lobsimpleupd,
		onclick = false, 
		reset = false,
		final = false,
		x = 0,
		y = 0,
		w = 0,
		h = 0,
		focused = false,
		gui = blobs,
		move = simplemove,
		moveCenter = simplecenter
	}
	blobs[(#blobs) + 1] = t
	return t
end

function gui.insert(blobs, t, i)
	gui.remove(blobs, t)
	if not i then
	blobs[(#blobs) + 1] = t
	else 
		table.insert(blobs, i, t)
	end
	t.gui = blobs
	return t
end

function gui.clear(blobs) 
	blobs:call("final")
	for k, v in ipairs(blobs) do 
		blobs[k] = nil
	end
end

function gui.call(blobs, name, ...) 
	for _,v in next, blobs, nil do
		local t = v[name]
		local r = type(t) == "function" and t(v, ...) or false
		if r then return r end
	end
end

function gui.update(blobs)
	local m = input:getDevice("mouse")
	mouse.x = m.x
	mouse.y = m.y
	blobs:call("update")
end

local function blobupd (self)
	local md = input:isDown("LMB")
	self.focused = false;
	if recs_collision(self,mouse) then
		self.focused = true;
		if not md and self.clicked then 
			self.clicked = false; 
			if self.onclick then self:onclick(); end
		end;
		if md and not self.clicked then
			self.clicked = true;
		end;
	end;
	if not md and self.clicked then self.clicked = false; end;
end

 --- BUTTON
 
local function buttondraw(self) 
		draw.color(200,200,255,255);
		draw.rectangle("fill", self.x, self.y, self.w, self.h);
		draw.color(0,0,0,255);
		draw.size(2);
		draw.rectangle("line", self.x, self.y, self.w, self.h);
		
  	if self.focused then
			if self.clicked then
				draw.color(255,255,0,255);
			else
				draw.color(0,0,255,255);
			end;
		else
		draw.color(0,0,0,255);
		end;
		draw.textCenter(self.text or "$text", self.x + self.w/2, self.y + self.h/2, self.h - 5);
	end


function gui.button(blobs, text, func, x, y, w, h)
	local t = gui.blob(blobs)
	t.update = blobupd
	t.draw = buttondraw
	t.text = text
	t.onclick = func
	return t
end

-- Scroll

local function scrolldraw(self) 
	draw.color(100,100,200,255);
	draw.rectangle("fill", self.x, self.y, self.w, self.h);
	draw.color(200,200,255,255);
	draw.rectangle("fill", self.x, self.y, self.w * self.value, self.h);
	draw.color(0,0,0,255);
	draw.size(2);
	draw.rectangle("line", self.x, self.y, self.w, self.h);
		
 	if self.focused then
		if self.clicked then
			draw.color(255,255,0,255);
		else
			draw.color(0,0,255,255);
		end;
	else
	draw.color(0,0,0,255);
	end;
	draw.textCenter(self.text..":"..tostring(math.floor(self.value*100)).."%", self.x + self.w/2, self.y + self.h/2, self.h - 5);
end

function scrollclick(self)
	local k = mouse.x - self.x
	local v = math.floor((k/self.w) * 100) / 100
	if v ~= self.value then playSound("resources/interact.ogg") end
	self.value = v
end

function gui.scroll(blobs, text, v, x, y, w, h)
	local t = gui.blob(blobs)
	t.update = function(self)
		self.focused = false;
		if recs_collision(self,mouse) then
			self.focused = true;
			self.clicked = false;
			if input:isDown("LMB") then 
				if self.onclick then self:onclick(); end
				self.clicked = true;
			end
		end
	end
	t.draw = scrolldraw
	t.value = v or 0
	t.text = text
	t.onclick = scrollclick
	return t
end

-- Switch

local function switchdraw(self) 
	draw.color(100,100,200,255);
	draw.rectangle("fill", self.x, self.y, self.h, self.h);
	draw.color(200,200,255,255);
	draw.rectangle("fill", self.x, self.y, self.value and self.h or 0, self.h);
	draw.color(0,0,0,255);
	draw.size(2);
	draw.rectangle("line", self.x, self.y, self.h, self.h);
	
	draw.textCenter(self.value and "on" or "off", self.x + self.h/2, self.y + self.h/2, self.h - 15);
 	if self.focused then
		if self.clicked then
			draw.color(255,255,0,255);
		else
			draw.color(0,0,255,255);
		end;
	else
	draw.color(0,0,0,255);
	end;
	draw.textCenter(self.text, self.x + self.w/2 + self.h/2, self.y + self.h/2, self.h - 5);
end

function switchclick(self)
	self.value = not self.value
	playSound("resources/interact.ogg")
end

function gui.switch(blobs, text, v, x, y, w, h)
	local t = gui.blob(blobs)
	t.update = blobupd
	t.draw = switchdraw
	t.value = v and true or false
	t.text = text
	t.onclick = switchclick
	return t
end

gui.__index = gui;

function gui.new()
	local t = {}
	setmetatable(t, gui)
	return t;
end

return gui
