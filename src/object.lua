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

--[[
	This file implements prototype oop :)
]]

-- Predefinition

local dummy = function() end
local getmetatable = getmetatable
local setmetatable = setmetatable
local copymt = function(a, b) setmetatable(a, getmetatable(b)) end
local strformat = string.format
local proto_key = "_prototype"

-- Definition and code

local obj = {name = "Base", [proto_key] = false} -- base object

-- standart object metatable. Can be redefined in childs to add more features
setmetatable(obj, { 
	__index = function(o, k)
		local p = rawget(o, proto_key)
		return p and p[k] or nil -- because main object hasn't got any prototype
	end, 
	__tostring = function(o) return o:tostring() end,
	__pairs = function(o, ...) return o:pairs(...) end
})

-- Main constructor

local function Object(n) -- basic object constructor. You can pass string to set new name
	local t = obj:instance()
	t.name = n and tostring(n) or "Object"
	return t
end

-- Basic functions implementation (yes, only 4 functions :D)

function obj:instance(rawtable) -- returns new child of this object
	local t = rawtable or {}
	copymt(t, self)
	rawset(t, proto_key, self)
	return t
end

function obj:base() -- returns base object
	return rawget(self, proto_key)
end

function obj:tostring() return strformat("%s: %p", self.name, self) end

function obj:pairs() return next, self, nil end

return Object;
