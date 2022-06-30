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

local mouse = input.getDevice("mouse")

input.registerKey("lmb", "mouse", 1)
input.registerKey("select", "mouse", 1, "keyboard", "return")
input.registerKey("up", "keyboard", "w", "keyboard", "up")
input.registerKey("down", "keyboard", "s", "keyboard", "down")
input.registerKey("left", "keyboard", "a", "keyboard", "left")
input.registerKey("right", "keyboard", "d", "keyboard", "right")

WIN = input.getDevice("window");

local SCREEN = nil
local newscr = nil
local alpha = 255

function setScreen(t)
	if newscr then SCREEN = newscr end
	newscr = t
	if t.init then t.init() end
end

function love.draw()
	draw.color(255,255,255)
	if SCREEN then SCREEN.draw() end
	draw.color(0, 0, 0, alpha)
	draw.rect(0, 0, WIN.w, WIN.h)
end

function love.update()
	updateMusic()
	if newscr then
		alpha = alpha + 5
		if alpha >= 255 then
			SCREEN = newscr
			newscr = nil
		end
	else
		if alpha > 1 then
			alpha = alpha - 5
		end
	end
	if SCREEN then SCREEN.update() end
	input.update()
	poolEvents()
end

setScreen(dofile("game", "intro.lua"))
