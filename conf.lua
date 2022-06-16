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

function love.conf(t)
	t.appendidentity = true,
	t.version = "11.4",
	t.console = false,
	t.accelerometerjoystick = false,
	t.gammacorrect = false,
	t.audio.mixwithsystem = true,
	t.window.title = "Loading...",
	t.window.icon = "res/game-icon.png",
	t.window.width = 800,
	t.window.height = 600,
	t.window.borderless = false,
	t.window.resizable = true,
	t.window.minwidth = 128,	-- Минимально возможная ширина окна (число)
	t.window.minheight = 128,	-- Минимально возможная высота окна (число)
	t.window.fullscreen = false,
	t.window.fullscreentype = "desktop",
	t.window.vsync = 1,
	t.window.msaa = 0
end
