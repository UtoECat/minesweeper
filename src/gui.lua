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

local gui = Object("Gui");
local blob = Object("Gui.Blob");

-- Blob in GUI

function blob:draw()
	if self.selected then
		draw.color(200,200,200)
		if self.clicked then
			draw.color(200,200,0)
		end
	else
		draw.color(128,128,128)
	end
	draw.rect(self.x, self.y, self.w, self.h)
end

function blob:select(bool)
	self.selected = bool
	if not bool then
		self.clicked = false
	end
end

function blob:click(fin, x, y)
	self.clicked = true
	if fin then
		self.clicked = false
		if self.onclick then
			self.onclick()
		end
	end
end

function blob:scroll(val)
	
end

function blob:remove()
	local arr = blob.master.array
	local len = #arr
	for i = 1, len do
		if arr[i] == self then
			table.remove(arr, i)
			return true
		end
	end
	return false
end

-- GUI Object

function gui:draw() 
	local len = #self.array
	for i = 1, len do
		self.array[i]:draw()
	end
end

local function sorter(a, b) return a.z < b.z end

local function calleachret(arr, fun, ...) -- call fun foreach obj in arr
	local len = #arr
	local i = 1
	while i <= len do
		local r1, r2, r3 = fun(arr[i], ...)
		if r1 or r2 or r3 then
			return r1, r2, r3
		end
		i = i + 1
	end
	return nil
end

local function nearestrect(arr, fun, rect, ...) --nearest object
	local len = #arr
	local curr
	local val = 9999999
	
	local i = 1
	while i <= len do
		local aa = fun(arr[i], rect, ...)
		if aa < val and aa ~= 0 then
			val = aa
			curr = arr[i]
		end
		i = i + 1
	end
	return curr, val
end

function gui:update() 
	--sorting gui by Z
	table.sort(self.array, sorter)
	-- check some stuff :D
	local mouse = input.getDevice("mouse")
	local kleft = input.getKey("left")
	local kright = input.getKey("right")
	local kup = input.getKey("up")
	local kdown = input.getKey("down")
	-- get new object to be selected
	local newsel = calleachret(self.array, coll_rect_xor, mouse)
	
	if mouse.xdiff == 0 and mouse.ydiff == 0 then
		newsel = self.selected
		local rect = self.selected or self.array[1]
		if not rect then return end
		
		if kleft.pressed then
			newsel = nearestrect(self.array, dist_rect, rect, 0, 1, 1, 0.5)
		elseif kright.pressed then
			newsel = nearestrect(self.array, dist_rect, rect, 2, 1, 1, 0.5)
		elseif kup.pressed then
			newsel = nearestrect(self.array, dist_rect, rect, 1, 0, 0.5, 1)
		elseif kdown.pressed then
			newsel = nearestrect(self.array, dist_rect, rect, 1, 2, 0.5, 1)
		end
	end
	
	if newsel ~= self.selected then -- reselecting :)
		if self.selected then
			self.selected:select(false) -- deselect old
		end
		self.selected = newsel
		if self.selected then
			self.selected:select(true) -- select new :p
		end
	else -- check for clicking
		local curr = self.selected
		
		if not curr then
			return -- nothing to do :p
		end
		
		if coll_rect(curr, mouse) or (mouse.xdiff == 0 and mouse.ydiff == 0) then
			if input.getKey("select").pressed then
				curr:click(false, mouse.x - curr.x, mouse.y - curr.y)
			end
			if input.getKey("select").released then
				curr:click(true, mouse.x - curr.x, mouse.y - curr.y)
			end
			if mouse.wheel ~= 0 then
				curr:scroll(mouse.wheel)
			end
		end
	end
	
	for _, gel in pairs(self.array) do -- update all gui elements, that have this field
		if gel.update then gel:update() end
	end
end

function gui:new(x, y, w, h, z)
	local o = blob:instance()
	o.x = x or 0
	o.y = y or 0
	o.w = w or 0
	o.h = h or 0
	o.z = z or self.z or 0
	
	o.master = self or error("how? and why?")
	self.array[#self.array + 1] = o
	return o
end

return function()
	local o = gui:instance()
	o.array = {}
	o.selected = nil
	return o
end
