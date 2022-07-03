--[[
This file is a part of Minesweeper game
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

local font = Font()
local bomb = Texture("res", "bomb.png")
local mouse = input.getDevice("mouse")
local boom = Sound(false, "res", "boom.ogg")
local gui = GUI()

local t = {}

function t.init()
	gui:new(110,0,50,50).onclick = function() print("up!"); end
	gui:new(110,120,50,50).onclick = function() print("down!"); end
	gui:new(110,180,50,50).onclick = function() print("down!"); end
	gui:new(110,240,50,50).onclick = function() print("down!"); end
	gui:new(50,60,50,50).onclick = function() print("hehe"); nextMusic() end
	gui:new(110,60,50,50).onclick = function() print("hehe"); stopMusic() end
	gui:new(170,60,50,50).onclick = function() print("hehe"); dbgMusic() end
	GuiButton(gui, 300, 240, 150, 50, 0, "Heloo!", function() print "lmao" end)
	GuiVerticalScroll(gui, 300, 300, 150, 50, 0, "value =", 0.5)
	GuiHorizontalScroll(gui, 500, 50, 50, 200, 0, 1, 50)
	GuiImage(gui, 300, 400, 150, 150, 0, Texture("res", "shit_maker.jpg"))
	playMusicPlaylist(dir2playlist("res", "music"))
end

function t.draw()
	draw.color(255,255,255)
	draw.rect(0,0, WIN.w, WIN.h)
	bomb:drawCenter(mouse.x, mouse.y, 55, 55, 0)
	gui:draw()
	draw.color(0,0,255)
	font:draw(tostring(love.audio.getActiveSourceCount()), 200,200,40)
end

function t.update()
	gui:update()
end

return t
