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

function Table(...) return {...} end 

local pool = Object("MemoryPool")
local weakmt = {__mode="v"}

function MemoryPool(con, name) -- constructor, [[object name]]
	local o = pool:instance()
	o.array = {}
	setmetatable(o.array, weakmt)
	o.name = name -- not necessary
	o.construct = con or Table
	return o
end

function pool:new() -- alloc and construct
	local len = #self.array
	local o = nil
	
	if len > 0 then
		o = self.array[len]
		self.array[len] = nil -- remove from alloc pool
	else -- if no cached memory
		o = self.construct()
	end
	return o
end

function pool:free(o)
	if type(o) ~= "table" then return false end
	if self.name and o.name ~= self.name then
		return -- bad name
	end
	self.array[#self.array + 1] = o -- put to pool
	return true
end


