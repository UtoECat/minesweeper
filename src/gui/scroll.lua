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

local function odraw(self)
	if self.selected then
		draw.colort(GuiColorScheme.backSelect)
		if self.clicked then
			draw.colort(GuiColorScheme.backPress)
		end
	else
		draw.colort(GuiColorScheme.backPassive)
	end
	local szz = GuiColorScheme.lineWidth
	draw.size(szz)
	draw.rect(self.x+szz, self.y+szz, self.w-szz*2, self.h-szz*2, GuiColorScheme.roundness, true)
	local k = math.max(self.h - self.max, self.w/2)
	local diff = self.h - k
	draw.rect(self.x, self.y + self.value/self.max*diff, self.w, k, GuiColorScheme.roundness)
	-- draw outline
	if self.selected then
		draw.colort(GuiColorScheme.outlineSelect)
		if self.clicked then
			draw.colort(GuiColorScheme.outlinePress)
		end
	else
		draw.colort(GuiColorScheme.outlinePassive)
	end
	draw.rect(self.x, self.y, self.w, self.h, GuiColorScheme.roundness, true)
	draw.size()
end

local function oselect(self, bool)
	self.selected = bool
	if not bool then
		self.clicked = false
	end
end

local function oclick(self, fin, x, y)
	if fin and self.clicked then
		self.clicked = false
		self.value = math.floor(y/self.h*self.max)
	elseif not fin then
		self.clicked = true
	end
end


local function omoving(self, x, y)
	if self.clicked then
		self.value = math.floor(y/self.h*self.max)
	end
end

local function oscroll(self, val)
	self.value = self.value + -val*(self.max/50)
	if self.value > self.max then
		self.value = self.max
	end
	if self.value < 0 then
		self.value = 0
	end
end

function GuiHorizontalScroll(gui, x, y, w, h, z, val, max)
	local o = gui:new(x, y, w, h, z)
	o.text = tostring(text)
	o.draw = odraw
	o.select = oselect
	o.click = oclick
	o.scroll = oscroll
	o.value = math.min(math.max(val, max), 0) or 0
	o.max = max or 1
	o.moving = omoving
end

