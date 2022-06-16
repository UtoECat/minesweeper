--[[
Minesweeper
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

local _require = require
local _dofile = dofile

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
		return _dofile(fin)
	end
end

inspect = require("src", "inspect").inspect
json = require("src", "json")

dofile("src", "main.lua")
