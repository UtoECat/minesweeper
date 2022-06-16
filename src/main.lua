--[[
Minesweeper
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

print(inspect(love))

local loopfunc = function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						os.exit()
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		dt = love.timer.step()

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		love.timer.sleep(0.001)
end

local esc = love.keyboard.getKeyFromScancode("escape")

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end
	love.math.setRandomSeed(os.time())
	love.timer.step()

	local dt = 0

	return function() 
		local suc, msg = xpcall(loopfunc, debug.traceback)
		if not suc then
			print(msg);
			love.window.setMode(640,360)
			while msg do
				love.event.pump()
				for e, a, b, c in love.event.poll() do if e == "keypressed" and a == "escape" then
					msg = nil
				elseif e == "quit" then
					if love.quit then love.quit() end
					os.exit()
				end end
    		love.event.pump()
    		love.graphics.origin()
				love.graphics.clear(love.graphics.getBackgroundColor())
				love.graphics.setColor(255,255,255)
    		love.graphics.printf("Error : "..tostring(BOOT).."\n\n\n\nPress ESC to restart", 0, 160, 640, 'center')
				love.graphics.present()
				love.timer.sleep(0.1)
			end
			
		end
	end
	
end

function love.draw()
	error("abaobu")
end

