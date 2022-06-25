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

local events = {}
local handlers = {}

local ev = Object("event")
local pool = MemoryPool(ev.instance, "event")

function Event(f, a, b, c, d)
	local o = pool:new()
	if type(f) == "function" then
		o.func = f
	else 
		o.reciever = f
	end
	o.a = a
	o.b = b
	o.c = c
	o.d = d
	events[#events + 1] = o
	return o
end

function Handler(name, fun, ...)
	local o = {...}
	o.name = name
	o.func = fun
	handlers[name] = o
	return o
end

local unpack = unpack or table.unpack
local dummy = function() end

function poolEvents()
	local len = #events
	local pos = 1
	for i = 1, len do
		local o = events[pos]
		
		if o.clock then -- timer for event
			if os.clock() < o.clock then
				pos = pos + 1
				goto endloop
			end
		end
		
		local fun = o.func and o.func or handlers[o.reciever].func or dummy

		local suc, msg = pcall(o.func, o.a, o.b, o.c, o.d)
		if not suc then
			print("Event handling error : "..tostring(msg))
		end
		pool:free(table.remove(events, pos))
		::endloop::
	end
end
