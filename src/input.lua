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

local inmt = {}

function upd_key (self)
	local new
	for i = 1, #self.array, 2 do
		new = self.array[i].rawkeys[self.array[i+1]] or new;
	end
	
	if new ~= self.down then
		if new then
			self.pressed = true;
			--print("key "..self.name.." prerssed!");
		else 
			self.released = true;
			--print("key "..self.name.." released!");
		end;
	else 
		if new then
			self.pressed = false;
		else 
			self.released = false;
		end;
	end
	
	self.down = new;
end;

function joy_upd_gamepad(dev, self)
	local newx = dev.rawaxis[self.idx]
	local newy = dev.rawaxis[self.idy]
	
	self.x = newx;
	self.y = newy;
end

function joy_upd_mouse(dev, self)
	local newx = dev[self.idx]
	local newy = dev[self.idy]
	
	self.x, self.y = vec.nor(newx, newy) -- normalize it! :)
end

local input = {
	keys = {}, -- key have device and id + down, pressed, released
	joysticks = {}, -- 2d joysticks
	device = {
		mouse = {
			rawkeys = {};
			key_reg = function(d, a) return type(a)=="number" and a or error("input: bad key_id") end;
			x = 0;
			y = 0;
			xdiff = 0;
			ydiff = 0;
			w = 1;
			h = 1;
			wheel = 0;
			joy_upd = joy_upd_mouse;
			joy_reg = function(d, a) return (a=="xdiff" or a=="ydiff" or a=="wheel") and a or error("input: bad axis_id") end;
		},
		keyboard = {
			rawkeys = {};
			key_reg = function(d, a) return type(a)=="string" and a or error("input: bad key_id") end;
		},
		window = {
			x = 0, -- x and y will be always zero!
			y = 0,
			w = love.graphics.getWidth(),
			h = love.graphics.getHeight()
		},
		gamepad = {
			rawaxis = {},
			rawkeys = {},
			joy_upd = joy_upd_gamepad,
			joy_reg = function(d, a) return type(a)=="string" and a or error("input: bad axis_id") end,
			key_reg = function(d, a) return type(a)=="string" and a or error("input: bad key_id") end;
		}
	};
};

function inmt.getDevice(name)
	local dev = input.device[name];
	if not dev then error("input: bad device name "..tostring(name)) end;
	return dev;
end

function inmt.getKey(name)
	local k = input.keys[name];
	if not k then error("input: bad key name (or key not registered) "..tostring(name)) end;
	return k;
end

function inmt.registerKey(name, ...)
	if type(name) ~= "string" then 
		error("input: bad key name!")
	end
	
	local array = {}
	local k = {array = array, device = dev, name = name}
	
	for i = 1, select("#", ...), 2 do
		local devname = select(i, ...)
		local keyid = select(i+1, ...)
		array[i] = input.device[devname] or error("input: bad device name "..tostring(devname))
		array[i+1] = array[i].key_reg and array[i]:key_reg(keyid) or error(
			"input: mpossible to register keys for device" .. devname .. "!"
		);
	end
	
	k.down = false
	k.pressed = false
	k.released = false
	input.keys[name] = k
	
	print("input: registered key "..name)
	return k
end

function inmt.getJoystick(name)
	local k = input.joysticks[name];
	if not k then error("input: bad joystick name (or not registered) "..tostring(name)) end;
	return k;
end

function inmt.registerJoystick(name, devname, idx, idy)
	local dev = input.device[devname];
	if not dev then error("input: bad device name "..tostring(devname)) end;
	if type(name) ~= "string" then error("input: bad joystick name!") end
	local regfun = dev.joy_reg and dev.joy_reg or error(
		"input: mpossible to register axis for device" .. devname .. "!");
	
	local k = {idx = 0, idy=0, device = dev};
	k.idx = regfun(dev, idx)
	k.idy = regfun(dev, idy)
	
	k.x = 0
	k.y = 0
	input.joysticks[name] = k;
	
	print("input: registered joystick "..name.." for device "..devname.." with axis "
		..tostring(k.idx)..", "..tostring(k.idy))
	return k
end

local function btn(b)
	return b and 1 or 0
end

local keydevice = {
	joy_upd = function(dev, self)
		local newx = (btn(self.px.down) * 1) + (btn(self.nx.down) * -1)
		local newy = (btn(self.py.down) * 1) + (btn(self.ny.down) * -1)
	
		self.x, self.y = vec.nor(newx, newy) -- normalize it! :)
	end;
}

function inmt.registerJoystickByKeys(name, npx, nnx, npy, nny)
	if type(name) ~= "string" then error("input: bad joystick name!") end
	
	local k = {
		device = keydevice,
		px = inmt.getKey(npx),
		py = inmt.getKey(npy),
		nx = inmt.getKey(nnx),
		ny = inmt.getKey(nny)
	};
	
	k.x = 0
	k.y = 0
	input.joysticks[name] = k;
	
	print("input: registered joystick "..name.." with keys "
		..tostring(npx)..tostring(nnx)..", "..tostring(npy)..tostring(nny))
	return k
end

function inmt.update()
	for name, key in pairs(input.keys) do
		upd_key(key);
	end
	for name, j in pairs(input.joysticks) do
		local dev = j.device;
		dev.joy_upd(dev, j);
	end
	input.device.mouse.xdiff = 0
	input.device.mouse.ydiff = 0
	input.device.mouse.lastkey = nil
	input.device.keyboard.lastkey = nil
	input.device.gamepad.lastkey = nil
end

inmt.__index = inmt;
setmetatable(input, inmt);

-- mouse
function love.mousepressed(x, y, key)
	local m = input.device.mouse;
	m.rawkeys[key] = true;
	m.xdiff = x - m.x;
	m.ydiff = y - m.y;
	m.x = x; m.y = y;
	input.device.mouse.lastkey = key
end

function love.gamepadpressed(j, key)
	local m = input.device.gamepad;
	m.rawkeys[key] = true;
	m.lastkey = key
end

function love.gamepadreleased(j, key)
	local m = input.device.gamepad;
	m.rawkeys[key] = false;
end

function love.joystickadded(j)
	print("Connected new joystick!")
end

function love.gamepadaxis(_, axis, val)
	local m = input.device.gamepad;
	m.rawaxis[axis] = val;
end

function love.mousereleased(x, y, key)
	local m = input.device.mouse;
	m.rawkeys[key] = false;
	m.xdiff = x - m.x;
	m.ydiff = y - m.y;
	m.x = x;m.y = y;
end

function love.wheelmoved(_, k)
	input.device.mouse.wheel = k;
end

function love.mousemoved(x, y)
	local m = input.device.mouse;
	m.xdiff = x - m.x;
	m.ydiff = y - m.y;
	m.x = x;m.y = y;
end

-- keyboard
function love.keypressed(_, key)
	input.device.keyboard.rawkeys[key] = true;
	input.device.keyboard.lastkey = key
end

function love.keyreleased(_, key)
	input.device.keyboard.rawkeys[key] = false;
end

function love.textinput(...)
	-- idk how to use this
end

-- window

function love.resize(w, h)
	local win = input.device.window;
	win.w = w;
	win.h = h;
end

function love.focus(b)
	input.device.window.focus = b;
end

function StartInput()
	love.keyboard.setTextInput(true)
end

return input;
