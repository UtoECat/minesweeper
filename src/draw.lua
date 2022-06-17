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

function Texture(...)
	local path = makepath(...)
	return love.graphics.newImage(path)
end

local quad = love.graphics.newQuad(0, 0, 0, 0, 0, 0)

function drawCenter(obj, x, y, sx, sy, a)
	local x = x or 0
	local y = y or 0
	local a = a or 0
	local sx = sx or 1
	local sy = sy or 1
	love.graphics.draw(obj, x, y, a, sx, sy, obj:getWidth()/2, obj:getHeight()/2)
end

function draw(obj, x, y, sx, sy, a)
	local x = x or 0
	local y = y or 0
	local a = a or 0
	local sx = sx or 1
	local sy = sy or 1
	love.graphics.draw(obj, x, y, a, sx, sy)
end

function drawSub(obj, x, y, sx, sy, a, ta, tb, tc, td)
	local x = x or 0
	local y = y or 0
	local a = a or 0
	local sx = sx or 1
	local sy = sy or 1
	local w = obj:getWidth()
	local h = obj:getHeight()
	quad:setViewport(ta, tb, tc, td, w, h)
	love.graphics.draw(obj, quad, x, y, a, sx, sy)
end

function drawCenterSub(obj, x, y, sx, sy, a, ta, tb, tc, td)
	local x = x or 0
	local y = y or 0
	local a = a or 0
	local sx = sx or 1
	local sy = sy or 1
	local w = obj:getWidth()
	local h = obj:getHeight()
	quad:setViewport(ta, tb, tc, td, w, h)
	love.graphics.draw(obj, quad, x, y, a, sx, sy, w/2, h/2)
end
