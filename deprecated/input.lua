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

function key_update (self)
	local new = self.device.is_down(self.id);
	if new ~= self.down then
		if new then
			self.pressed = true;
			--print("Key with id "..tostring(self.id).." pressed!");
		else 
			self.released = true;
		end;
	else 
		if new then
			self.pressed = false;
		else 
			self.released = false;
		end;
	end;
	self.down = new;
end;

local function updmouse(self) 
	self.x = love.mouse.getX(); 
	self.y = love.mouse.getY();
	self.wheel = self.wheelt
	self.wheelt = 0
end;

local input = {
	update = function(self)
		for k,v in next, self.dev, nil do -- update devices
			if v.update then v:update() end;
		end;
		for k,v in next, self.keys, nil do -- update keys
			key_update(v);
		end;
	end;
	register = function(self, name, id, dev)
		local key = {};
		self.keys[name] = key;
		key.device = self.dev[dev];
		if not key.device then error("bad device name!"); end;
		if key.device.make_id then 
			key.id = key.device.make_id(id);
		else
			key.id = id;
		end;
		print("Key "..name.."registered for device "..dev.." with id "..tostring(id));
	end;
	isPressed = function(self, name)
		if not self.keys[name] then return false end
		return self.keys[name].pressed;
	end;
	isReleased = function(self, name)
		if not self.keys[name] then return false end
		return self.keys[name].released;
	end;
	isDown = function(self, name)
		if not self.keys[name] then return false end
		return self.keys[name].down;
	end;
	isExists = function(self, name)
		if not self.keys[name] then return false end
		return true;
	end;
	isUp = function(self, name)
		return not self:isDown(name);
	end;
	getDevice = function (self, name) 
		return self.dev[name];
	end;
	keys = {};
	dev = {
		mouse = {
			is_down = love.mouse.isDown;
			x = 0;
			y = 0;
			update = updmouse;
			wheel = 0;
			wheelt = 0;
		};
		keyboard = {
			is_down = love.keyboard.isDown;
			make_id = love.keyboard.getKeyFromScancode;
		};
	};
};

function love.wheelmoved(b, a)
	local m = input:getDevice("mouse")
	m.wheelt = m.wheelt + a
end

input:register("ESC", "q", "keyboard");
input:register("LMB", 1, "mouse");
input:register("MMB", 3, "mouse");
input:register("RMB", 2, "mouse");
input:register("ZOOM+", "[", "keyboard");
input:register("ZOOM-", "]", "keyboard");
input:register("RESET", "r", "keyboard");
input:register("COLLECT", "c", "keyboard");

return input;
