local LOVELi = require('libs.LOVELi.LOVELi')

local instance = nil

---@class GUI
---@field layoutmanager LayoutManager
local GUI = {}
GUI.__index = GUI

---Get instance
---@return GUI
function GUI.GetInstance()
    if not instance then
        instance = setmetatable({
            layoutmanager = LOVELi.LayoutManager:new({})
                :with(LOVELi.AbsoluteLayout:new{ width = 250, height = 250, margin = LOVELi.Thickness.parse(10) }
                    :with(LOVELi.Button:new{ text = "Top Left", horizontaltextalignment = "center", verticaltextalignment = "center", x = 0, y = 0, width = 75, height = 23 } )
                )
        }, GUI)
    end
    return instance
end

function GUI:keypressed(key, scancode, isrepeat)
    self.layoutmanager:keypressed(key, scancode, isrepeat)
end
function GUI:textinput(text)
    self.layoutmanager:textinput(text)
end
function GUI:mousepressed(x, y, button, istouch, presses)
    self.layoutmanager:mousepressed(x, y, button, istouch, presses)
end
function GUI:mousereleased(x, y, button, istouch, presses)
    self.layoutmanager:mousereleased(x, y, button, istouch, presses)
end
function GUI:mousemoved(x, y, dx, dy, istouch)
    self.layoutmanager:mousemoved(x, y, dx, dy, istouch)
end
function GUI:wheelmoved(dx, dy)
    self.layoutmanager:wheelmoved(dx, dy)
end
function GUI:joystickhat(joystick, hat, direction)
    self.layoutmanager:joystickhat(joystick, hat, direction)
end
function GUI:joystickpressed(joystick, button)
    self.layoutmanager:joystickpressed(joystick, button)
end
function GUI:resize(w, h)
    self.layoutmanager:resize(w, h)
end
function GUI:update(dt)
    self.layoutmanager:update(dt)
end
function GUI:draw()	
    self.layoutmanager:draw()
end

return GUI