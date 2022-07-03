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
	draw.rect(self.x, self.y, self.w, self.h, GuiColorScheme.roundness)
	-- draw outline
	if self.selected then
		draw.colort(GuiColorScheme.outlineSelect)
		if self.clicked then
			draw.colort(GuiColorScheme.outlinePress)
		end
	else
		draw.colort(GuiColorScheme.outlinePassive)
	end
	draw.size(GuiColorScheme.lineWidth)
	draw.rect(self.x, self.y, self.w, self.h, GuiColorScheme.roundness, true)
	-- draw text :p
	if self.selected then
		draw.colort(GuiColorScheme.fontSelect)
		if self.clicked then
			draw.colort(GuiColorScheme.fontPress)
		end
	else
		draw.colort(GuiColorScheme.fontPassive)
	end
	draw.size()
	local ss = math.min(self.w/#self.text*1.5, self.h)
	GuiColorScheme.defaultFont:drawCenter(self.text, self.x+(self.w/2), self.y+(self.h/2), ss, 0)
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
		if self.onclick then
			self.onclick()
		end
	elseif not fin then
		self.clicked = true
	end
end

local function oscroll(self, val)
	
end

function GuiButton(gui, x, y, w, h, z, text, action)
	local o = gui:new(x, y, w, h, z)
	o.text = tostring(text)
	o.onclick = action
	o.draw = odraw
	o.select = oselect
	o.click = oclick
	o.scroll = oscroll
end

