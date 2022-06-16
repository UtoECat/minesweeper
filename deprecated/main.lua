--[[
ECS-Editor
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

-- For hot reloading :)
local orig = {}

for k,v in pairs(_G) do
	orig[k] = v
end
_ORIGINAL_G = orig

orig = {}
for k,v in pairs(package.loaded) do
	orig[k] = v
end
_ORIGINAL_LOADED = orig

local a = {} -- stringificated number cache
for i = 0, 1000, 1 do
	a[i] = tostring(i)
end

_CACHE_NUM = a

collectgarbage('restart')

dofile("maincode.lua")

