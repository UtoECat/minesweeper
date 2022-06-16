--[[
deepprint - functions for deep printing tables for debug
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

function deepprint(val,name,i,deep,allowmeta,pairs_f)
	i = i or 0;
	pairs_f = pairs_f or pairs;
	deep = deep or {};
	if type(name) ~= "string" then name = tostring(name); end;
	if deep[val] then print(string.rep(" ",i)..name.." = "..deep[val])
	elseif type(val) == "table" then
		deep[val] = "reference on "..tostring(val).." known as "..name;
		print(string.rep(" ",i)..name.." = { ");
		for k,v in pairs_f(val) do
			deepprint(v,k,i+1,deep,allowmeta,pairs_f);
		end;
		if type(debug.getmetatable(val)) ~= nil and allowmeta then
			deepprint(debug.getmetatable(val),"$METATABLE$",i+1,deep,allowmeta,pairs_f);
		end;
		print(string.rep(" ",i).."};");
	elseif type(val) == "userdata" then
		print(string.rep(" ",i)..name.." = "..tostring(val));
		if type(debug.getmetatable(val)) ~= nil and allowmeta then
			deepprint(debug.getmetatable(val),"$METATABLE$",i+1,deep,allowmeta,pairs_f);
		end;
		deep[val] = "reference on "..tostring(val).." known as "..name;
	elseif type(val) == "function" then
		print(string.rep(" ",i)..name.." = "..tostring(val));
		deep[val] = "reference on "..tostring(val).." known as "..name;
	else
		print(string.rep(" ",i)..name.." = "..tostring(val));
	end;
end;
