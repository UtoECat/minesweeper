--[[
memdebug - benchmark for getting info about memory usage in different functions :)
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

local mem = {}
local nobench = {}
require("code/deepprint")

local data = nil
local datamem = 0

function mem.start()
	local m = collectgarbage('count')
	collectgarbage()
	collectgarbage('stop')
	data = {}
	setmetatable(data, {__index=function(t, k) t[k] = {name = "nil", koeff = 0, memmax = 0, memcurr = 0, memgrow = 0, calls = 0}; return t[k] end})
	datamem = collectgarbage('count') - m
	debug.sethook(mem.hook, 'cr')
end

function mem.stop()
	if not data then return nil end
	debug.sethook()
	collectgarbage("restart")
	local ii = 0
	for k,v in pairs (data) do
		if v.memmax == 0 then
			v.memin = nil
			v.memmax = nil
			v.memcurr = nil
			v.memgrow = nil
			data[k] = nil
		end
		ii = ii + 1
	end
	collectgarbage()
	io.write("___________MEMORY BENCHMARK______________", tostring(datamem), " : ", tostring(ii), "\n")
	local most_hungry = nil
	local total_hungry = nil
	
	for k,v in pairs(data) do 
		io.write(tostring(v.name).."("..tostring(k)..") : {")
		for a, b in pairs(v) do
			if a ~= "name" and a~= "memcurr" then
				io.write(", "..tostring(a).."="..tostring(b))
			end
		end
		if not most_hungry then most_hungry = v end
		if not total_hungry then total_hungry = v end
		if most_hungry.koeff < v.koeff then most_hungry = v end
		if total_hungry.memgrow < v.memgrow then total_hungry = v end
		io.write("}\n")
	end
	io.write("Most hungry :"..tostring(most_hungry.name).." grow: "..tostring(most_hungry.memgrow).. " calls: "..tostring(most_hungry.calls).." max: "..tostring(most_hungry.memmax).."\n")
	io.write("Total hungry :"..tostring(total_hungry.name).." grow: "..tostring(total_hungry.memgrow).. " calls: "..tostring(total_hungry.calls).." max: "..tostring(total_hungry.memmax).."\n")
	io.write("_________________________________________\n")
	return data
end

function mem.hook(event)
	-- check internal memory growning
	local mem = collectgarbage('count')
	local funcinfo = debug.getinfo(2)
	if nobench[funcinfo.func] then return end -- if function is internal, do not benchmark it
	
	local ft = data[funcinfo.func] -- getting function benchmark table
	if ft.name == "nil" then ft.name = (funcinfo.source or "[unknown source]").." : "..(funcinfo.name or "nil").." (line "..tostring(funcinfo.linedefined)..") = " end
	local parinfo = debug.getinfo(3)
	local par = nobench[parinfo.func] and nil or data[parinfo.func]
	
	local a = collectgarbage('count')
	datamem = datamem+(a - mem)
	assert(a > mem, "memory underflow in benchmark "..tostring(a).." "..tostring(mem).." all :"..tostring(datamem))
	
	-- now checking memory for function :)
	mem = ((((collectgarbage('count') - datamem))))
	if event == "call" then -- if called, save current memory
		ft.memcurr = mem
		ft.calls = ft.calls + 1
	elseif event == "return" and ft.calls > 0 then -- if returned, get difference
		local res = mem - ft.memcurr
		if res < 0 then res = 0 end
		if ft.memmax < res then ft.memmax = res end
		ft.memgrow = ft.memgrow + res
		ft.koeff = ft.memgrow / ft.calls
		if par then
			par.memcurr = par.memcurr + res
		end
	end
	
	
	
end

nobench[mem.start] = true
nobench[mem.stop] = true
nobench[mem.hook] = true
nobench[deepprint] = true
nobench[error] = true
nobench[collectgarbage] = true

return mem
