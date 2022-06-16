--[[
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


require("base");
local input = require("input")
local draw = require "graphics"
local gui = require("gui").new()
local guiover = require("gui").new()
local locale = require "locale"
require("code/deepprint")

local game = {};
local gameover = {}

gui:clear()
local backb = nil

-- Effects :)
local function makeboom(gui, x, y, sz) -- Boom effect
	if x < 0 or x > WIN.w -- if particle is out of vision = dont spawn it
	or y < 0 or y > WIN.h then
		return
	end
	local t = gui:blob()
	t.update = function(self)
		if self.frame > self.max then
			gui:remove(self)
		end
		if os.clock() > self.timer + 0.02 then
			self.timer = os.clock()
			self.frame = self.frame + 1
		end
	end
	t.draw = function (self)
		local f = self.frame > self.max and self.frame - 1 or self.frame;
		draw.color(255,255,255,255)
		draw.sprites.drawCenter("boom", self.x, self.y, self.sz, self.sz, f, 0);
	end
	t.frame = 1; t.x = x; t.y = y; t.sz = sz;
	t.timer = os.clock()
	t.max = draw.sprites.framesCount("boom")
end

local posx = 0 -- camera pos
local posy = 0

local function makeopeneff(gui, x, y, sz) -- Open effect
	if var_no_particles then return end
	if x + posx < 0 or x + posx > WIN.w -- if particle is out of vision = dont spawn it
	or y + posy < 0 or y + posy > WIN.h then
		return
	end
	local t = gui:blob()
	t.update = function(self)
		if self.alpha < 0 then
			gui:remove(self)
		end
		self.alpha = self.alpha - 2
		for k,v in ipairs(self.particles) do
			v.x = v.x + v.xs
			v.y = v.y - v.ys
			v.xs = v.xs * 0.99
			v.ys = v.ys - 0.03 * k
			v.a = v.a + (v.xs) / 6
		end
	end
	t.draw = function (self)
		draw.color(255,255,255,255)
		for k,v in ipairs(self.particles) do
			draw.color(128,128,128,self.alpha)
			draw.sprites.drawCenter("ground", self.x + v.x + posx, self.y + v.y + posy, self.sz / 2, self.sz / 2, 0, v.a);
		end
	end
	t.x = x; t.y = y; t.sz = sz; t.alpha = 255;
	local hsz = sz/2
	local stv = 1 * math.random(1,50)/40
	t.particles = {
		{x = 0, y = 0, xs = -stv, ys = 1, a = 0},
		{x = 0 + hsz, y = 0, xs = stv, ys = 1, a = 0},
		{x = 0 + hsz, y =0 + hsz, xs = stv, ys = 1, a = 0},
		{x = 0, y = 0 + hsz, xs = -stv, ys = 1, a = 0}
	}
end

local function makefalleff(gui, name, alk, x, y, sz) -- Falling sprite effect :)
	if var_no_particles then return end
	if x + posx < 0 or x + posx > WIN.w -- if particle is out of vision = dont spawn it
	or y + posy < 0 or y + posy > WIN.h then
		return
	end
	local t = gui:blob()
	t.update = function(self)
		if self.alpha < 0 then
			gui:remove(self)
		end
		self.alpha = self.alpha - alk
		local v = self
		v.x = v.x + v.xs
		v.y = v.y - v.ys
		v.xs = v.xs * 0.99
		v.ys = v.ys - 0.3
	end
	t.draw = function (self)
		draw.color(255,255,255,255)
		draw.color(255,255,255,self.alpha)
		draw.sprites.drawCenter(name, self.x + posx, self.y + posy, self.sz, self.sz, 0, 0);
	end
	t.x = x; t.y = y; t.sz = sz; t.alpha = 255;
	local hsz = sz
	local stv = 1 * math.random(1,50)/40
	t.xs = stv * math.random(-1, 1)
	t.ys = 3
	t.a = 0
end

local function makecoineff(gui, x, y, sz) -- Coin effect :)
	makefalleff(gui, "coin", 5, x, y, sz)
end

-- Game

local gameworks = true
local field = {}
local field_w = 10 -- size of field
local field_h = 10
local mine_cnt = 20 -- count of bombs
local gamewin = false

local COUNT = 0 -- count of need to open cells
local FLAGS = 0 -- count of setted flags
local FLAGS_GOOD = 0 -- count of good setted flags

local curx = 0 -- position of cursor in field
local cury = 0

local runs_count = -1 -- count of runs
local first_step = true -- is step is first in this run

local scale = 40 -- scale of resulting image

local function initgame() -- game generation
	gameworks = true
	gamewin = false
	first_step = true
	runs_count = runs_count + 1
	COINS = COINS or 5
	
	field = {}
	local fs = math.clamp(var_field_size*100,3,100)
	local mp = math.clamp(var_mines_percent*100,1,98)
	field_w, field_h = fs, fs
	mine_cnt = math.ceil(field_w * field_h * mp/100)
	COUNT = field_w * field_h - mine_cnt
	FLAGS_GOOD = 0
	FLAGS = 0
	
	for x = 1, field_w do
		field[x] = {}
		for y = 1, field_h do
			field[x][y] = {0, math.random(1,6)} -- type, is_hided
		end
	end
	
	for i = 1, mine_cnt do
		while true do
			local x = math.random(1, field_w)
			local y = math.random(1, field_h)
			local cell = field[x][y]
			if cell[1] ~= 9 then -- it is not bomb :)
				cell[1] = 9 -- make it bomb
				
				-- make cells around marked
				for ax = -1, 1 do
					for ay = -1, 1 do
						local cell = field[ax+x]
						if cell and cell[ay+y] then -- avoid writing to invalid cells
							cell = cell[ay+y]
							cell[1] = (cell[1] > 7) and cell[1] or cell[1] + 1 -- avoid overflow
						end
					end
				end
				
				break
			end
			-- if cell is has bomb, continue randomize
		end
	end
	print("mines generated!")
	-- add coins :)
	
	for i = 1, mine_cnt/3 do
		local x = math.random(1, field_w)
		local y = math.random(1, field_h)
		local cell = field[x][y]
		if cell[1] == 0 then -- it is not bomb or coin :)
			cell[1] = 10 -- make it coin
			break
		end
	end
	-- end of generation :)
end

local numcolors = {
	{0,0,200},
	{0,200,0},
	{128,200,128},
	{200,200,128},
	{255,200,128},
	{255,64,255},
	{0,255,255},
	{255,0,0}
}

local helptime = 0

local function drawcontrols() -- show help about controls
	if helptime > 755 then return end
	helptime = helptime + 1
	local a = helptime
	if helptime > 255 then
		a = 755 - helptime
	end
	draw.color(255,255,255, a)
	local scl = WIN.w / 251
	scl = scl < WIN.h/100 and scl or WIN.h/100
	scl = scl * 0.8
	draw.sprites.drawCenter("controls", WIN.w / 2, WIN.h - 100*0.5 * scl, 251 * scl, 100 * scl, 0)
	draw.color(255,255,255)
end

local function tovalid (pos, pmin, pmax, cmin, cmax)
	local rmax = math.max(math.min(cmax, pmax), pmin)
	local rmin = math.min(math.max(cmin, pmin), pmax)
	return math.max(math.min(pos,rmax), rmin)
end

local function drgame()
	local px = math.floor(tovalid(1, 1, field_w, -posx/scale, WIN.w/scale))
	local py = math.floor(tovalid(1, 1, field_h, -posy/scale, WIN.h/scale))
	local pw = math.floor(tovalid(field_w, 1, field_w, 1, -posx/scale+WIN.w/scale + 1))
	local ph = math.floor(tovalid(field_h, 1, field_h, 1, -posy/scale+WIN.h/scale + 1))
	for x = px, pw do
		for y = py, ph do
			local cell = field[x][y]
			if cell[2] > 0 then
				draw.sprites.draw("ground", (x - 1) * scale + posx, (y - 1) * scale + posy, scale, scale, 0)
				if cell[2] > 1 and cell[2] < 7 then
					draw.sprites.draw("ground"..tostring(cell[2] - 1), (x - 1) * scale + posx, (y - 1) * scale + posy, scale, scale, 0)
				elseif cell[2] == 9 then
					draw.sprites.draw("flag", (x - 1) * scale + posx, (y - 1) * scale + posy, scale, scale, 0)
				end
			else
				draw.sprites.draw("underground", (x - 1) * scale + posx, (y - 1) * scale + posy, scale, scale, 0)
				if cell[1] == 9 then
					draw.sprites.draw("bomb", (x - 1) * scale + posx, (y - 1) * scale + posy, scale, scale, 0)
				else
					local color = numcolors[cell[1]]
					if color then
						draw.color(color[1], color[2], color[3], 255)
						draw.textCenter(tostring(cell[1]), ((x - 1) * scale + posx)+scale/2, (y - 1) * scale + posy +scale/2, scale)
						draw.color(255,255,255,255)
					elseif cell[1] == 10 then
						draw.sprites.draw("coin", (x - 1) * scale + posx, (y - 1) * scale + posy, scale, scale, 0)
					end
				end
			end
		end
	end
	if gameworks and not gamewin then
	draw.sprites.draw("shovel", (curx - 1) * scale + posx, (cury - 1) * scale + posy, scale, scale, 0)
	end
	drawcontrols()
	draw.color(0,0,0)
end

deepprint(love.callbacks)

local mlastx = 0
local mlasty = 0

local function ondeath()
	gameworks = false
	playSound("resources/boom.ogg")
	gui:remove(backb)
	setScreen(gameover)
end

local sound_open = false
local sound_coin = false

local function loopopen(x, y)
	makeopeneff(gui, (x-1)*scale, (y-1)*scale, scale)
	local cell = field[x][y]
	cell[2] = 0
	
	local stp = first_step
	local res_step
	
	if cell[1] == 9 then
		if not first_step then
			ondeath()
			makeboom(gui, (curx - 1) * scale +scale/2 + posx, (cury - 1) * scale +scale/2 + posy, scale*3)
			makefalleff(gui, "shovel", 2, (curx - 1) * scale, (cury - 1) * scale, scale)
			return
		else
			cell[2] = 9
			FLAGS = FLAGS + 1
			FLAGS_GOOD = FLAGS_GOOD + 1
			first_step = true -- experimental mode TODO: add flag for this
			res_step = true
		end
	elseif cell[1] == 10 then
		if not sound_coin then
			sound_coin = true
			playSound("resources/coin.ogg")
		end
		if not var_no_particles then 
			makecoineff(gui, (x-1)*scale, (y-1)*scale, scale)
			cell[1] = 0
		end
		COINS = COINS + 1
		first_step = false
	else
		if not sound_open then
			sound_open = true
			playSound("resources/interact.ogg")
		end
		first_step = false
	end
	
	COUNT = COUNT - 1
	if field[x][y][1] ~= 0 and not stp then return end -- if cell type is not zero => exiting :) (but if it is first step-> open everything around :))
	
	for ax = -1, 1 do for ay = -1, 1 do
			local cell = field[ax+x]
			if cell and cell[ay+y] then -- avoid writing to invalid cells
				cell = cell[ay+y]
				if cell[2] ~= 0 and cell[2] ~= 9 and cell[1] < 9 then loopopen(ax+x, ay+y) end
			end;
	end end
	first_step = res_step or first_step
end

local function prgame()
	sound_open = false
	sound_coin = false
	if not gameworks then 
		local x = math.random(1, field_w)
		local y = math.random(1, field_h)
		local cell = field[x][y]
		if cell[2] ~= 0 and cell[1] == 9 then
			cell[2] = 0
			playSound("resources/boom.ogg")
			makeboom(gui, (x - 1) * scale +scale/2 + posx, (y - 1) * scale +scale/2 + posy, scale*3)
			makeopeneff(gui, (x-1)*scale, (y-1)*scale, scale)
		end
		return
	end 
	local mouse = input:getDevice("mouse")
	if input:isPressed("MMB") then
		mlastx = mouse.x - posx
		mlasty = mouse.y - posy
	end
	if input:isDown("MMB") then
		posx = mouse.x - mlastx
		posy = mouse.y - mlasty
	end
	
	local mx = mouse.x - posx
	local my = mouse.y - posy
	
	curx = math.clamp(math.floor(mx / scale) + 1, 0, field_w+1)
	cury = math.clamp(math.floor(my / scale) + 1, 0, field_h+1)
	if curx < 1 or cury < 1 or curx > field_w or cury > field_h then
		return
	end
	
	local cell = field[curx][cury]
	
	if input:isPressed("ZOOM+") then
		scale = scale - 2
	elseif input:isPressed("ZOOM-") then
		scale = scale + 2
	end
	scale = scale + input:getDevice("mouse").wheel*2
	
	if input:isReleased("LMB") and cell[2] ~= 9 and cell[2] ~= 0 then
		local suc, msg = pcall(loopopen,curx,cury) -- to prevent stack owerflow in big maps
		collectgarbage("step")
		if not suc then
			print(msg)
		end
	elseif input:isReleased("RMB") then
		if cell[2] == 9 then
			FLAGS = FLAGS - 1
			if cell[1] == 9 then
				FLAGS_GOOD = FLAGS_GOOD - 1
			end
			cell[2] = 1
		elseif cell[2] ~= 0 then
			cell[2] = 9
			FLAGS = FLAGS + 1
			if cell[1] == 9 then
				FLAGS_GOOD = FLAGS_GOOD + 1
			end
		end
	end
end



-- Code for game

local key = nil
local playlist = love.filesystem.getDirectoryItems("music/")
assert(#playlist ~= 0, "music/ directory is empity! Add some mp3 files in it!")
deepprint(playlist)
local function nextsound()
	local v
	while not v do
		key, v = next(playlist, key)
	end
	return "music/"..v
end

function game.init()
	initgame()
	gui:clear()
	backb = gui:button(locale.t_back_button, function() runs_count = -1; setScreen(require "menu"); playSound("resources/interact.ogg") return 1 end, 0, 0, 200, 200)
	posx = WIN.w/2 - field_w/2*scale
	posy = WIN.h/2 - field_h/2*scale
	playMusic(nextsound(), nextsound);
end

local cntr = 0

function game.draw() 
	local col = 255-25 + (math.sin(cntr)*25)
	cntr = cntr + 0.01
	draw.color(col, col, col, 255);
	draw.rectangle("fill", 0, 0, WIN.w, WIN.h);
	draw.color(255,255,255, 255);
	
	drgame()
	
	gui:call("draw")
	draw.color(64,64,128,255);
	draw.textCenter("Count : "..tostring(COUNT), WIN.w/2, 20 + 5, 20)
	draw.textCenter("Runs : "..tostring(runs_count), WIN.w/2, 45 + 5, 20)
	draw.textCenter("Flags : "..tostring(FLAGS).."/"..tostring(mine_cnt), WIN.w/2, 70 + 5, 20)
  backb:move(WIN.w - 105, 5, 100, 35);
end

function game.update()
	gui:update() 
	if not recs_collision(backb, gui:mouse()) then 
		prgame()
	end
	if COUNT <= 0 and not gamewin then
		print("You win!")
		gamewin = true
		playSound("resources/levelup.ogg")
		setScreen(game)
	end
	if FLAGS_GOOD == mine_cnt and FLAGS_GOOD == FLAGS and not gamewin then
		print("You win by marks!")
		gamewin = true
		playSound("resources/levelup.ogg")
		setScreen(game)
	end
end

-- Code for gameover

guiover:clear()
local backbb = guiover:button(locale.t_back_button, function() runs_count = -1; setScreen(require "menu"); playSound("resources/interact.ogg") return 1 end, 0, 0, 200, 200)
local retb = guiover:button(locale.t_retry, function() runs_count = -1; setScreen(game); playSound("resources/interact.ogg") return 1 end, 0, 0, 200, 200)

function gameover.init()
	playMusic("resources/death.mp3");
end

function gameover.draw() 
	draw.color(128,128,128,255);
	draw.rectangle("fill", 0, 0, WIN.w, WIN.h);
	draw.color(255,255,255,255);
	drgame()
	gui:call("draw")
	draw.color(0,0,0,160);
	draw.rectangle("fill", 0, 0, WIN.w, WIN.h);
	
	draw.color(255,255,255,255);
	guiover:call("draw")
	draw.color(255,255,255,255);
	local y = WIN.h/3
	draw.sprites.draw("mogila", WIN.w/2 - 100, y - 100, 200, 200, 0)
	y = y + 110 + 10
	draw.textCenter(locale.t_lose_msg, WIN.w/2, y, 35)
	y = y + 25 + 10
	draw.textCenter("Runs : "..tostring(runs_count), WIN.w/2, y, 25)
	y = y + 55 + 10
	retb:moveCenter(WIN.w/2, y, 100, 35);
  y = y + 35 + 10
  backbb:moveCenter(WIN.w/2, y, 100, 35);
end

function gameover.update()
	guiover:update()
	if not gameworks then gui:update()
	prgame()
	end
end

return game;
