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

jit.on();
function resourcePath(a) return "resources/"..a end
math.randomseed(os.time())

collectgarbage('restart')
if not love then error("this program must be runned by LOVE binary!") end
local draw = require "graphics"
local input = require("input");
require("base");
require("music")

draw.libinit()

-- Header. Define and include main things

local loading = require("loading");

WIN = {x = 0, y = 0, w = love.graphics.getWidth(), h = love.graphics.getHeight()} -- window

-- Initialization code and settings

local json = require "code/json"

var_field_size = 0.1
var_mines_percent = 0.1

function loadSettings()
	local fsett = io.open("settings.json", "r")
	if not fsett then 
		print("Can't load settings");
		return
	end

	local str = fsett:read("a");

	for k,v in 
		pairs(json.decode(str))
	do
		_G[k] = v
	end
	fsett:close()
end

function saveSettings()
	local fsett = io.open("settings.json", "w+")
	local t = {var_vol_music_max = var_vol_music_max, var_vol_sound_max = var_vol_sound_max, _DEBUG = _DEBUG, var_no_particles = var_no_particles, var_mines_percent = var_mines_percent, var_field_size = var_field_size}
	fsett:write(json.encode(t))
	fsett:close()
end

print(pcall(loadSettings))

-- Screens System

local screen = loading;
local old_scr = nil;
local screen_fade = 0;

function setScreen(scr)
	old_scr = screen
	screen = scr
	print("Screen", screen, "selected!")
end;

function updScreen()
	if old_scr then
		screen_fade = screen_fade + 9;
		old_scr:update()
		if screen_fade > 254 then old_scr = nil; if screen.init then screen:init() end end;
	else
		if screen.update then screen:update() end
		if screen_fade > 0 then
			screen_fade = screen_fade - 9;
		end;
	end;
end;

function drawScreen() 
	if old_scr then
		if old_scr.draw then old_scr:draw() end;
		draw.color(255,255,255,screen_fade);
  	draw.rectangle("fill",0,0,WIN.w,WIN.h);
	else
		if screen.draw then screen:draw() end;
		draw.color(255,255,255,screen_fade);
  	draw.rectangle("fill",0,0,WIN.w,WIN.h);
	end;
end;

-- Code

function love.update()
	var_counter = 0
	updateSound();
	input:update();
	updScreen();
	var_counteri = var_counter
	if input:isDown("RESET") and _DEBUG then
		dofile("hotrestart.lua")
	end
	if input:isPressed("COLLECT") and _DEBUG then
		collectgarbage()
	end
end;

local mem_arr = {}
local mem_max = 0

function love.draw() 
	draw.reset();
	drawScreen()
	draw.color(255,0,0,255)
	if _DEBUG then
		local k = 5
		draw.text("FPS : "..tostring(love.timer.getFPS()), 5,5,15)
		mem_arr[#mem_arr + 1] = collectgarbage('count') / k
		
		if mem_max < mem_arr[#mem_arr] then mem_max = mem_arr[#mem_arr] end
		local from = WIN.h - 50
		local max_len = 300
		if #mem_arr > max_len then table.remove(mem_arr, 1) end
		
		draw.color(0,0,255,255)
		draw.text("MEMORY USAGE :", 5,from - mem_max - 15,15)
		draw.text(tostring(math.floor(mem_max)), max_len - 15*4 ,from - mem_max - 15,15)
		
		draw.line(1, from - mem_max, #mem_arr, from - mem_max)
		draw.color(255,0,0,255)
		
		for i = 1, #mem_arr - 1, 1 do
			draw.line(i, from - mem_arr[i], i+1, from - mem_arr[i+1])
		end
		draw.color(0,255,0,255)
		draw.line(1, from - 0, #mem_arr, from - 0)
	end
end;

function love.resize(w, h)
	WIN.w = w
	WIN.h = h
end;

-- Exit code

function exitProg() -- program exiting custom function
	saveSettings();
	love.quit()
	os.exit()
end;

exit_screen = {
	update = exitProg;
	init = function() playSound("resources/interact.ogg") end
}

function love.quit()
	print("Goodbye!");
	collectgarbage();
	print("Program exited normally!");
end;
