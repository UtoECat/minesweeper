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

-- Пресоздаём некоторые константные строки :)

local a = {} -- stringificated number cache
for i = 0, 1000, 1 do
	a[i] = tostring(i)
end

local tochar = string.char
local b = {}
for i = 0, 255 do
	b[i] = string.char(i)
end

_CACHE_CHAR = b
_CACHE_NUM = a

-- Перезапускаем сборщик мусора
collectgarbage('restart')

-- Получаем некоторые платформоспецефичные значения
PATH_DELIM = string.sub(package.config, 1, 1)

-- Некоторые полезные функции

_require = require
_dofile = dofile

function makepath(first, ...) -- делает путь из аргументов :)
	local str = first
	local len = select("#", ...)
	
	for i = 1, len do
		str = str .. PATH_DELIM .. tostring(select(i, ...))
	end
	return str
end

function require(...) -- замена require
	local fin = makepath(...)
	if not fin then
		error("No module name or path passed!")
	else
		return _require(fin)
	end
end

function dofile(...) -- замена dofile :)
	local fin = makepath(...)
	if not fin then
		error("No module name or path passed!")
	else
		return love.filesystem.load(fin)()
	end
end

--for k in next, love._modules do
	--_G[k] = love[k]
--end

-- замена стандартного цикла

local loopfunc = function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if love.quit then
						love.quit()
					end
					os.exit()
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		dt = love.timer.step()

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		love.timer.sleep(0.001)
end

-- цикл с проверкой на ошибки

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end
	love.math.setRandomSeed(os.time())
	love.timer.step()

	local dt = 0

	return function() -- custom error handler here :)
		local suc, msg
		if not ERR then
			suc, msg = xpcall(loopfunc, debug.traceback)
			if suc then return end
			print(msg)
			ERR = msg
		else
			while ERR do
				for e, a, b, c in love.event.poll() do 
					if e == "keypressed" and a == "escape" then
						ERR = nil
					elseif e == "quit" then
						if love.quit then love.quit() end
						os.exit()
					end
				end
				love.event.pump()
				love.timer.step()
				if love.graphics.isActive() then
					love.graphics.origin()
					love.graphics.clear(32/255, 64/255, 128/255)
					love.graphics.setColor(255,255,255)
					love.graphics.printf("Error : "..tostring(ERR).."\n\n\n\nPress ESC to restart", 
						50, 50, love.graphics.getWidth()-100, "left", 0, 1.5)
					love.graphics.present()
				end
				love.timer.sleep(0.001)
			end
			-- конец цикла
		end
	end
	-- hehe
end

os.clock = love.timer.getTime
inspect = require("src", "inspect").inspect
json = require("src", "json")
base = require("src", "base")
Object = require("src", "object")
require("src", "draw")
input = require("src", "input")
require("src", "sound")

dofile("src", "main.lua")
