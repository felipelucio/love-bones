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
local effects = {
	LOVELi.AlphaPulseEffect:new(0.25, 0.75, 2), 
	LOVELi.HueShiftEffect:new(2), 
	LOVELi.ScalePulseEffect:new(0.8, 1, 1), 
	LOVELi.RotateEffect:new(-0.05, 0.05, 1), 
	LOVELi.ShakeEffect:new(4, 4), 
	LOVELi.InvertColorShaderEffect:new()
}
local currenteffect = 0
function changeeffect(drawmanager)
	currenteffect = currenteffect + 1
	if currenteffect > #effects then
		currenteffect = 1
	end
	drawmanager:getfocusedeffects()[1] = effects[currenteffect]
	drawmanager:getunfocusedeffects()[1] = effects[currenteffect] -- For demo purposes
	layoutmanager:invalidate()
end
function love.load(arg)
	enabledebugger(arg)	
	local style = loveli.Style.parse("blue")
	local drawmanager = LOVELi.DrawManager:new{}
	layoutmanager = loveli.LayoutManager:new{ drawmanager = drawmanager }
		:with(loveli.Border:new{ width = "*", height = "*", style = style }
			:with(loveli.StackLayout:new{ orientation = "vertical", spacing = 5, width = "auto", height = "auto", margin = loveli.Thickness.parse(20), horizontaloptions = "center" } 
				:with(loveli.Button:new{ clicked = function(sender) changeeffect(drawmanager) end, text = "Change Effect", width = "auto", height = 23, margin = loveli.Thickness.parse("0,0,0,10") } ) 
				:with(loveli.Label:new{ text = "Button:" } )
				:with(loveli.Button:new{ clicked = function(sender) print("Clicked!") end, text = "Button", width = 75, height = 23 } )
				:with(loveli.Label:new{ text = "CheckBox:" } )
				:with(loveli.CheckBox:new{ checkedchanged = function(sender, oldvalue, newvalue) print(oldvalue, newvalue) end, ischecked = false } )
				:with(loveli.CheckBox:new{ checkedchanged = function(sender, oldvalue, newvalue) print(oldvalue, newvalue) end, ischecked = true } )
				:with(loveli.CheckBox:new{ checkedchanged = function(sender, oldvalue, newvalue) print(oldvalue, newvalue) end, ischecked = nil } )
				:with(loveli.Label:new{ text = "RadioButton:" } )
				:with(loveli.RadioButton:new{ checkedchanged = function(sender, oldvalue, newvalue) print(oldvalue, newvalue) end, ischecked = false, groupname = "1" } )
				:with(loveli.RadioButton:new{ checkedchanged = function(sender, oldvalue, newvalue) print(oldvalue, newvalue) end, ischecked = true, groupname = "1" } )			
				:with(loveli.Label:new{ text = "Switch:" } )
				:with(loveli.Switch:new{ toggled = function(sender, oldvalue, newvalue) print(oldvalue, newvalue) end, istoggled = false } )
				:with(loveli.Switch:new{ toggled = function(sender, oldvalue, newvalue) print(oldvalue, newvalue) end, istoggled = true } )
				:with(loveli.Label:new{ text = "Slider:" } )
				:with(loveli.Slider:new{ valuechanged = function(sender, oldvalue, newvalue) print(oldvalue, newvalue) end, value = 5, minimum = 0, maximum = 10 } )
				:with(loveli.Label:new{ text = "TextBox:" } )
				:with(loveli.TextBox:new{ textchanged = function(sender, oldvalue, newvalue) print(oldvalue, newvalue) end, text = "TextBox", width = 100, height = 23 } )
			)
		)
	changeeffect(drawmanager)
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
	love.graphics.clear(0.18, 0.18, 0.18)
	layoutmanager:draw()
end
function enabledebugger(arg)
	if arg[#arg] == "-debug" then 
		local debugger = require("mobdebug")
		debugger.start() 
	end	
	io.stdout:setvbuf("no")
end