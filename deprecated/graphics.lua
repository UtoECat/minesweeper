--[[
Drawing system :) (modified!)
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

-- DONE : fix rotation in centerazed figures and images
-- DONE : added back compability with old system :)

-- HEADER

local draw = {}

local Font = {
	minsize = 0,
	font = nil,
	height = 0
}

local quad = love.graphics.newQuad(0, 0, 0, 0, 0, 0); -- quad for texture drawing
local tbl = {} -- empity table for drawing

local function good_center_rotation( x, y, w, h, angle)
	love.graphics.translate(x+w/2, y+h/2, 0)
	love.graphics.rotate(angle or 0, 0, 0, 1)
	love.graphics.scale(w/1,h/1,0)
	love.graphics.translate(1/-2, 1/-2, 0)
end


-- Settings

local glRotatef = love.graphics.rotate
local glTranslatef = love.graphics.translate
local glScalef = love.graphics.scale

local getFont = love.graphics.getFont
local newFont = love.graphics.newFont
local newTexture = love.graphics.newImage
local drawRect = love.graphics.rectangle
local drawLine = love.graphics.line
local drawText = love.graphics.print
draw.size = love.graphics.setLineWidth;
draw.getSize = love.graphics.getLineWidth;
local pushMatrix = love.graphics.push
local popMatrix = love.graphics.pop

-- CODE

function draw.libinit()
	Font.minsize = 100
	local err, msg
	err, msg = pcall(newFont, "resources/default.ttf", Font.minsize);
	if err == true then	
		Font.font = msg
		Font.height = Font.font:getHeight();
		draw.font = Font
	else
		Font.font = getFont() -- else sets deafult font :)
		Font.minsize = Font.font:getHeight()
		Font.height = Font.font:getHeight();
		print(msg)
	end
end

local mode = "fill"

function draw.mode(m)
	mode = tostring(m)
end

function draw.reset ()
	love.graphics.reset();
	love.graphics.setFont(Font.font);
end

function draw.quad (x, y, w, h, angle) -- corner quad. Rotates around corner
	pushMatrix()
	glTranslatef(x + w/2, y + h/2, 0)
	glRotatef(angle or 0, 0,0,1)
	drawRect(mode, 0, 0, w, h);
	popMatrix()
end

function draw.rect (x, y, w, h, a) -- a - round value of corners
	drawRect(mode,x,y,w,h,a);
end

draw.rectangle = function(a, ...) draw.mode(a); draw.rect(...) end

function draw.rectCenter (x, y, w, h, a)
	drawRect(mode, x - w/2, y - h/2, w, h, a);
end

draw.rectangleCenter = function(a, ...) draw.mode(a); draw.rectCenter(...) end

function draw.quadCenter (x, y, w, h, angle) -- angle - angle of rotation :D what (rotates around center)
	pushMatrix()
	glTranslatef(x, y, 0)
	glRotatef(angle or 0, 0,0,1)
	drawRect(mode, -w/2, -h/2, w, h);
	popMatrix()
end

function draw.line ( x, y, a, b)
	drawLine(x, y, a, b);
end

function draw.text (text, x, y, size, r)
  drawText(text, x, y, r or 0, size/Font.minsize);
end

draw.print = draw.text;

function draw.textWidth(text, size)
	local f = Font.font
	local ksize  = size / Font.minsize
  return f:getWidth(text) * ksize
end

function draw.textCenter (text, x, y, size, angle)
  local ksize  = size / Font.minsize
  local width  = Font.font:getWidth(text) * ksize
  local height = Font.height * ksize
	
	pushMatrix()
	glTranslatef(x, y, 0)
	glRotatef(angle or 0, 0,0,1)
  drawText(text, -width/2, -height/2, 0, ksize);
  popMatrix()
  
end

function draw.color (r,g,b,a) 
	love.graphics.setColor((r or 0) / 255, (g or 0) / 255, (b or 0) / 255, (a or 255) / 255);
end

function draw.getColor () return love.graphics.getColor() end

-- Texture and sprite system header

-- Sprites are combination of texture and quads
-- Quad is coodinates on texture == frame of animation or like that
-- Diffirent sprites can have one texture
-- Textures are loaded only when needed (troubles with unloading now, but... :) don't matter)
-- You dan overload sprites by name without any troubles

local sprites = { 
	tex_loaded = {};
	spr_inform = {};
};

-- Texture system code

function sprites.registerTexture(name, filename) -- ex : registerTexture("grass", "grass1.png")
	sprites.spr_inform[name] = {
		["filename"] = filename;
		frames = {}; -- array of quads
	};
end;

function sprites.registerSprite(name, filename, quads) --[[example : registerSprite("guy", "guy_anim.png", {{1,1,50,50}, {51,1,50,50}}) -- define two frames for guy]]
	sprites.spr_inform[name] = {
		["filename"] = filename;
		frames = quads; -- array of quads
	};
end;

function sprites.framesCount(name) -- returns count of frames in sprite (0 in texture sprite)
	if sprites.spr_inform[name] then
		return #(sprites.spr_inform[name].frames)
	end
	return nil
end;

function sprites.getTexture (filename) -- internal function, don't use it
	local tex = sprites.tex_loaded[filename];
	if not tex then -- then load this texture
		local err
		err, tex = pcall(newTexture, filename);
		if err == false then
			print("Can't load texture "..filename.."! Getting error texture...")
			if filename ~= "error.png" then
				sprites.tex_loaded[filename] = sprites.getTexture("error.png")
			else
				error("Fatal : no error texture founded! Add error.png file to game resource folder!")
			end
		else
			print("Texture "..filename.." loaded!")
			sprites.tex_loaded[filename] = tex;
			tex:setFilter("nearest", "nearest");
		end
	end;
	return tex;
end;

function sprites.draw(name, x, y, w, h, frame, angle) -- draws sprite. select invalid frame to draw full texture of sprite
	local spr = sprites.spr_inform[name];
	if not spr then return end; -- don't draw invalid sprite!
	local image = sprites.getTexture(spr.filename); 
	local image_width = image:getWidth();
	local image_height = image:getHeight();
	local frame = frame or 1;
	
	local t = spr.frames[frame]
	if not t then 
		t = tbl
		t[1] = 0; t[2] = 0; t[3] = image_width; t[4] = image_height;
	end
	
	quad:setViewport(t[1] or 0,t[2] or 0, t[3] or 0, t[4] or 0, image_width, image_height);
	love.graphics.draw(image, quad, x, y, angle or 0, w/(t[3] or 1),h/(t[4] or 1));
end;

function sprites.drawCenter(name, x, y, w, h, frame, angle)
	local spr = sprites.spr_inform[name];
	if not spr then return end; -- don't draw invalid sprite!
	local image = sprites.getTexture(spr.filename); 
	local image_width = image:getWidth();
	local image_height = image:getHeight();
	local frame = frame or 1;
	
	local t = spr.frames[frame]
	if not t then 
		t = tbl
		t[1] = 0; t[2] = 0; t[3] = image_width; t[4] = image_height;
	end
	
	local width = w/(t[3] or 1)
	local height = h/(t[4] or 1)
	quad:setViewport(t[1] or 0,t[2] or 0, t[3] or 0, t[4] or 0, image_width, image_height);
	
	pushMatrix()
	glTranslatef(x, y, 0)
	glRotatef(angle or 0, 0,0,1)
	love.graphics.translate(w/-2, h/-2, 0)
	love.graphics.draw(image, quad, 0, 0, 0, width, height);
	popMatrix()
end

--[[function sprites.drawfull(name, x, y, s, angle) -- draws texture of sprite. Use it, if you don't know what id is invalid
	local spr = sprites.spr_inform[name];
	if not spr then error ("Sprite "..tostring(name).." is not exist!") end;
	local image = sprites.getTexture(spr.filename); 
	local w = image:getWidth();
	local h = image:getHeight();
	
	-- Code below fixes rotation : image rotates in center, not in corner!
	love.graphics.push()
	love.graphics.translate(x+s/2, y+s/2, 0)
	love.graphics.rotate(angle or 0, 0, 0, 1)
	love.graphics.scale(s/w,s/h,0)
	love.graphics.translate(w/-2, h/-2, 0)
	love.graphics.draw(image, 0, 0, 0, 1, 1);
	love.graphics.pop()
end; ]]

--setmetatable(sprites.tex_loaded, {__mode="v"});
setmetatable(sprites, {__call=sprites.draw});
draw.sprites = sprites;

return draw
