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

function coll_rect(a, b)
	local check = a and b or error("bad rec passed");
	if a == b then 
		return a
	end
	if a.x < b.x+b.w and b.x < a.x+a.w and a.y < b.y+b.h and b.y < a.y+a.h then 
		return a 
	else 
		return nil
	end
end

function coll_rect_xor(a, b)
	local check = a and b or error("bad rec passed");
	if a == b then 
		return nil
	end
	if a.x < b.x+b.w and b.x < a.x+a.w and a.y < b.y+b.h and b.y < a.y+a.h then 
		return a 
	else 
		return nil
	end
end

function dist_rect(a, b, x, y, kx, ky) -- distance between rectangles
	local check = a and b or error("bad rec passed");
	if a == b then 
		return 0
	end
	return vec.distcoef(a.x+(a.w/2), a.y+(a.h/2), b.x+(b.w/2)*x, b.y+(b.h/2)*y, kx, ky)
end

function math.clamp (val, min, max) -- clamp value
	local v = (val > max) and max or val;
	return (v < min) and min or v;
end;

function math.lerp (a, b, v) -- linear interpolation (a - start, b - end, v - amount)
	return a + v * (b - a);
end;

function math.norm (val, a, b) -- normalizes input value
	return (val - a) / (b - a)
end;

vec = {}

function vec.zero ()
	return 0, 0;
end

function vec.one ()
	return 1, 1;
end

function vec.len (a, b)
	return math.sqrt(math.pow(a, 2) + math.pow(b, 2))
end;

function vec.add (a, b, c, d)
	return a + c, b + d;
end;

function vec.addval (a, b, c)
	return a + c, b + c;
end;

function vec.sub (a, b, c, d)
	return a - c, b - d;
end;

function vec.scale (a, b, c) -- multiply by value
	return a * c, b * c;
end;

function vec.mul (a, b, c, d) -- multiply by vector
	return a * c, b * d;
end;

function vec.div (a, b, c, d)
	return a / c, b / d;
end;

function vec.dot (a, b, c, d) -- dot product
	return (a * c + b * d)
end;

function vec.neg (a, b) -- negate 
	return -a, -b;
end;

function vec.distance (a, b, c, d) -- distance between two vectors
	return math.sqrt((a - c)*(a - c) + (b - d)*(b - d));
end;

function vec.distcoef (a, b, c, d, x, y) -- distance between two vectors with coefficients
	local x = x or 1
	local y = y or 1
	return math.sqrt((a - c)*(a - c)*x + (b - d)*(b - d)*y);
end;

local PI = math.pi or 3.1415

function vec.angle (a, b, c, d) -- calculate angle in X-axis
	local result = math.atan2(d - b, c - a)*(180.0 / PI);
	if (result < 0) then result = result + 360.0 end
	return result
end

function vec.lerp (a, b, c, d, amount) -- linear interpolation between vectors
	return a + amount*(c - a), b + amount*(d - b);
end

function vec.refl (a, b, c, d) -- calculate reflected vector to normal
	local dotp = vec.dot(a, b, c, d); -- dot product
	return a - (2 * c) * dotp, b - (2 * d) * dotp;
end

function vec.comp (a, b, c, d) 
	return a == b and c == d
end

function vec.rotate (a, b, angle) -- rotate by angle
	local x = a * math.cos(angle) - b * math.sin(angle);
	local y = a * math.sin(angle) + b * math.cos(angle);
	return x, y;
end

function vec.nor (a, b)
	local x = vec.len(a, b)
	if (x ~= 0) then
		return vec.scale(a, b, 1.0/x)
	else
		return a, b
	end
end;
