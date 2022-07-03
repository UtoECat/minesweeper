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
		draw.color(200,200,200)
		if self.clicked then
			draw.color(200,200,0)
		end
	else
		draw.color(128,128,128)
	end
	local szz = GuiColorScheme.lineWidth
	draw.size(szz)
	draw.rect(self.x, self.y, self.w, self.h, 0, true)
	draw.color(255,255,255)
	self.img:draw(self.x+szz, self.y+szz, self.w-szz*2, self.h-szz*2)
end

local function oselect(self, bool)
	self.selected = bool
	if not bool then
		self.clicked = false
	end
end

local function oclick(self, fin, x, y)
	self.clicked = true
	if fin and self.clicked then
		self.clicked = false
		if self.onclick then
			self.onclick()
		end
	end
end

local function oscroll(self, val)
	
end

function GuiImage(gui, x, y, w, h, z, image, action)
	local o = gui:new(x, y, w, h, z)
	o.text = tostring(text)
	o.onclick = action
	o.img = image or Texture()
	o.draw = odraw
	o.select = oselect
	o.click = oclick
	o.scroll = oscroll
end
