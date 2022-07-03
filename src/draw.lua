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

local base = Object("Texture")
local font = Object("Font")
local currfont = nil

local loaded = {}

function Texture(...)
	local path = makepath(...)
	local obj
	
	if loaded[path] then
		obj = loaded[path]
	else
		obj = base:instance()
		local suc, tex = pcall(love.graphics.newImage, path)
		if not suc then
			tex = love.graphics.newImage("error.png")
		end
		tex:setFilter("nearest", "nearest")
		obj.texture = tex
		obj.w = tex:getWidth()
		obj.h = tex:getHeight()
		loaded[path] = obj
	end
	return obj
end

-- Font

function Font(...)
	local path = makepath(...)
	local obj
	
	if loaded[path] then
		obj = loaded[path]
	else
		obj = font:instance()
		local f = path and love.graphics.newFont(path, 100) or love.graphics.newFont(100)
		obj.font = f
		obj.h = f:getHeight()
		obj.s = 100
		if path then loaded[path] = obj end
	end
	return obj
end

function font:draw(text, x, y, s, r)
	love.graphics.print(text, self.font, x, y, r or 0, s/self.s, s/self.s)
end

function font:drawCenter(text, x, y, s, r)
	love.graphics.print(text, self.font, x, y, r or 0, s/self.s, s/self.s, self.font:getWidth(text)/2, self.h/2)
end

-- Texture

local quad = love.graphics.newQuad(0, 0, 0, 0, 0, 0)

function base:drawCenter(x, y, w, h, a)
	local x = x or 0
	local y = y or 0
	local a = a or 0
	local w = w or self.w
	local h = h or self.h
	love.graphics.draw(self.texture, x, y, a, w/self.w, h/self.h, self.w/2, self.h/2)
end

function base:draw(x, y, w, h, a)
	local x = x or 0
	local y = y or 0
	local a = a or 0
	local w = w or self.w
	local h = h or self.h
	love.graphics.draw(self.texture, x, y, a, w/self.w, h/self.h)
end

function base:drawSub(x, y, w, h, a, ta, tb, tc, td)
	local x = x or 0
	local y = y or 0
	local a = a or 0
	quad:setViewport(ta, tb, tc, td, self.w, self.h)
	love.graphics.draw(self.texture, quad, x, y, a, w/tc, h/td)
end

function base:drawSubCenter(x, y, w, h, a, ta, tb, tc, td)
	local x = x or 0
	local y = y or 0
	local a = a or 0
	quad:setViewport(ta, tb, tc, td, self.w, self.h)
	love.graphics.draw(self.texture, quad, x, y, a, w/tc, h/td, tc/2, td/2)
end

draw = {}

function draw.color(r, g, b, a)
	love.graphics.setColor(r/255, g/255, b/255, (a or 255)/255)
end

function draw.colort(arr)
	love.graphics.setColor(arr[1]/255, arr[2]/255, arr[3]/255, (arr[4] or 255)/255)
end

function draw.size(v)
	love.graphics.setLineWidth(v or 1)
end

function draw.line(...)
	love.graphics.line(...)
end

function draw.rect(x, y, w, h, round, lines)
	love.graphics.rectangle(lines and "line" or "fill", x, y, w, h, round, round)
end
