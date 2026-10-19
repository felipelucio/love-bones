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
	local implicitstyle = loveli.Style:new( { ["Button"] = { textcolor = loveli.Color.parse("red") } } )
	local basestyle = loveli.Style:new ( { ["Button"] = { textcolor = loveli.Color.parse("white"), backgroundcolor = loveli.Color.parse("black") } } )
	local explicitstyle = loveli.Style:new ( { ["Button"] = { textcolor = loveli.Color.parse("blue") } }, basestyle) -- use base style
	layoutmanager = loveli.LayoutManager:new{}
		:with(loveli.StackLayout:new{ orientation = "vertical", spacing = 5, width = "*", height = "*", margin = loveli.Thickness.parse(10), style = implicitstyle } 
			:with(loveli.Button:new{ text = "Button 1", width = 75, height = 23, horizontaloptions = "center" } ) -- use the implicit style (aka style inheritance)
			:with(loveli.Button:new{ text = "Button 2", width = 75, height = 23, horizontaloptions = "center", textcolor = loveli.Color.parse("green") } ) -- override the implicit style
			:with(loveli.Button:new{ text = "Button 3", width = 75, height = 23, horizontaloptions = "center", style = explicitstyle } ) -- use the explicit style
			:with(loveli.Button:new{ text = "Button 4", width = 75, height = 23, horizontaloptions = "center", style = explicitstyle, textcolor = loveli.Color.parse("yellow") } ) -- override the explicit style
		)
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