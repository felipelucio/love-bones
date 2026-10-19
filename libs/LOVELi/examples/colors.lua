-- MIT License
-- 
-- Copyright (c) 2026 mtanksl
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

local loveli = require("LOVELi")
function love.load(arg)
	enabledebugger(arg)	
	local stacklayout = loveli.StackLayout:new{ orientation = "vertical", spacing = 5, width = "*", height = "*", margin = loveli.Thickness.parse(10) } 
	local colors = { 
		0xff0000ff, 
		"#f00", 
		"#f00f",
		"#ff0000", 
		"#ff0000ff", 
		"red", 
		{ red = 1, green = 0, blue = 0, alpha = 1 },
		loveli.Color.basecolors.red,
		
		0x00ff00ff, 
		"#0f0", 
		"#0f0f",
		"#00ff00", 
		"#00ff00ff", 
		"green", 
		{ red = 0, green = 1, blue = 0, alpha = 1 },
		loveli.Color.basecolors.green,
		
		0x0000ffff, 
		"#00f", 
		"#00ff",
		"#0000ff", 
		"#0000ffff", 
		"blue", 
		{ red = 0, green = 0, blue = 1, alpha = 1 },
		loveli.Color.basecolors.blue,
	}
	for _, color in pairs(colors) do
		stacklayout:with(loveli.Label:new{ text = "The quick brown fox jumps over the lazy dog", textcolor = loveli.Color.parse(color), x = 0, y = 0, width = "auto", height = "auto", horizontaloptions = "center", verticaloptions = "center" } )
	end	
	layoutmanager = loveli.LayoutManager:new{}
		:with(stacklayout)
end
function love.keypressed(key, scancode, isrepeat)
	layoutmanager:keypressed(key, scancode, isrepeat)
end
function love.textinput(text)
	layoutmanager:textinput(text)
end
function love.mousepressed(x, y, button, istouch, presses)
	layoutmanager:mousepressed(x, y, button, istouch, presses)
end
function love.mousereleased(x, y, button, istouch, presses)
	layoutmanager:mousereleased(x, y, button, istouch, presses)
end
function love.mousemoved(x, y, dx, dy, istouch)
  layoutmanager:mousemoved(x, y, dx, dy, istouch)
end
function love.wheelmoved(dx, dy)
  layoutmanager:wheelmoved(dx, dy)
end
function love.joystickhat(joystick, hat, direction)
	layoutmanager:joystickhat(joystick, hat, direction)
end
function love.joystickpressed(joystick, button)
	layoutmanager:joystickpressed(joystick, button)
end
function love.resize(w, h)
	layoutmanager:resize(w, h)
end
function love.update(dt)
	layoutmanager:update(dt)
end
function love.draw()	
	love.graphics.clear()
	layoutmanager:draw()
end
function enabledebugger(arg)
	if arg[#arg] == "-debug" then 
		local debugger = require("mobdebug")
		debugger.start() 
	end	
	io.stdout:setvbuf("no")
end