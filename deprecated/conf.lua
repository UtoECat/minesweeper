--[[
i don't know name of my project now...
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
    t.identity = nil                    -- saves dirname
    t.appendidentity = true             -- searching saves in root game folder too
    t.version = "11.4"                  -- LÖVE version (string)
    t.console = false                   -- enable console output (for debug, only for windows)
    t.accelerometerjoystick = false      -- that a bad thing, that disallow us to use joystik on android, so set in to false :)
    t.externalstorage = false           -- Saves data on external Android Data Directory
    t.gammacorrect = false              -- Gamma correction
    t.audio.mixwithsystem = true        -- don't stop other music, when game opened (only for Android and iOS)
    t.window.title = "loading..."       -- Window caption
    t.window.icon = "resources/game-icon.png" -- Game icon
    t.window.width = 800                -- Ширина окна (число)
    t.window.height = 600               -- Высота окна (число)
    t.window.borderless = false         -- Убрать рамки у окна (логическое)
    t.window.resizable = true           -- Can user change window size (makes harder to make gui, but better)
    t.window.minwidth = 128             -- Минимально возможная ширина окна (число)
    t.window.minheight = 128            -- Минимально возможная высота окна (число)
    t.window.fullscreen = false         -- Включить полноэкранный режим (логическое)
    t.window.fullscreentype = "desktop" -- Выбор полноэкранного режима "desktop" или "exclusive" (строка)
    t.window.vsync = 1                  -- Использовать вертикальную синхронизацию (число)
    t.window.msaa = 0                   -- Степень мультисемплинга (число)
    t.window.display = 1                -- Номер монитора, на котором будет показано окно игры (число)
    t.window.highdpi = false            -- Включить режим высокой чёткости (логическое, только для Retina дисплеев)
    t.window.x = nil                    -- Расположение окна на дисплее по X, при значении nil - середина ширины дисплея (число)
    t.window.y = nil                    -- Расположение окна на дисплее по Y, при значении nil - середина высоты дисплея (число)

    t.modules.audio = true              -- Включить модуль audio (логическое)
    t.modules.data = true               -- Включить модуль data (логическое)
    t.modules.event = true              -- Включить модуль event (логическое)
    t.modules.font = true               -- Включить модуль font (логическое)
    t.modules.graphics = true           -- Включить модуль graphics (логическое)
    t.modules.image = true              -- Включить модуль image (логическое)
    t.modules.joystick = true           -- Включить модуль oystick (логическое)
    t.modules.keyboard = true           -- Включить модуль keyboard (логическое)
    t.modules.math = true               -- Включить модуль math (логическое)
    t.modules.mouse = true              -- Включить модуль mouse (логическое)
    t.modules.physics = true            -- Включить модуль physics (логическое)
    t.modules.sound = true              -- Включить модуль sound (логическое)
    t.modules.system = true             -- Включить модуль system (логическое)
    t.modules.thread = true             -- Включить модуль thread (логическое)
    t.modules.timer = true              -- Включить модуль timer (логическое, при выключении этого модуля deltatime будет всегда 0)
    t.modules.touch = true              -- Включить модуль touch (логическое)
    t.modules.video = true              -- Включить модуль video (логическое)
    t.modules.window = true             -- Включить модуль window (логическое)
end
