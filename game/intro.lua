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

local utoecat = Texture("res", "shit_maker.jpg")
local font = Font()
local bump = Sound(false, "res", "interact.ogg")
local kb = input.getDevice("keyboard")
local mouse = input.getDevice("mouse")
local gmp = input.getDevice("gamepad")

local t = {}
S = 0.01
K = 0.01
A = 0.01
T = os.clock()
KEY = nil
MKEY = nil
GKEY = nil

function t.init()
	KEY = kb.lastkey
	MKEY = mouse.lastkey
	GKEY = gmp.lastkey
end

function t.draw()
	draw.color(255,255,255, (K - (255/2-35))/35*255)
	font:drawCenter("UtoECat", WIN.w/2, WIN.h/2 + K + 20, 30, i)
	draw.color(255,255,255, A)
	utoecat:drawCenter(WIN.w/2, WIN.h/2, 250, 250)
end

function t.update()
	-- skip intro
	if KEY ~= kb.lastkey or MKEY ~= mouse.lastkey or GKEY ~= gmp.lastkey then
		T = T - 4
		if A > 255 then A = 254 end
		S = S + 5
	end
	
	if os.clock() - T < 4.0 then
		if K <= 255/2 then
			S = S + 0.07
			K = K + S
			A = A + S + 5
		else
			K = 255/2
			bump:volume(S/2)
			S = -S * 0.5
			bump:stop()
			bump:play()
		end
	else
		if A > 255 then A = 255; S = 0 end
		A = A - S/2
		K = K - S
		S = S + 0.07
		if A < 1 then
			setScreen(dofile("game", "menu.lua"))
			t.update = function() end
		end
	end
end

return t
