local instance = nil

---@class InputAction
---@field name string
---@field keys table<string>
---@field alt_keys table<string>
---@field joystick table<string>
---@field repeating number
---@field last_press number
---@field last_release number
local InputAction = {}
InputAction.__index = InputAction

---Constructor
---@param name string
---@param keys? table<string>
---@param alt_keys? table<string>
---@param joystick? table<string>
---@param repeating? number
function InputAction.new(name, keys, alt_keys, joystick, repeating)
    local o = setmetatable({
        name = name,
        keys = keys or {},
        alt_keys = alt_keys or {},
        joystick = joystick or {},
        repeating = repeating or 0.2,
        last_press = -1,
        last_release = 0,
    }, InputAction)
    return o
end

---@class Input
---@field actions table<string, table<string>>
local Input = {}
Input.__index = Input

---Get Input handling instance
---@return Input
function Input.getInstance()
    if instance == nil then
        instance = setmetatable({
            actions = {},
        }, Input)
    end
    return instance
end

---Check if action is pressed
---@param action string
---@param repeat_enabled? boolean
function Input:isPressed(action, repeat_enabled)
    if repeat_enabled == nil then
        repeat_enabled = true
    end
    local act = self.actions[action] --[[@as InputAction]]
    if act then
        local pressed = true
        for _, a in ipairs(act.keys) do
            if not love.keyboard.isDown(a) then
                pressed = false
                break
            end
        end
        local now = love.timer.getTime()
        if pressed and (not repeat_enabled or now - act.last_press > act.repeating) then
            act.last_press = love.timer.getTime()
            return pressed
        end
    end
    return false
end

---Check if action is just pressed
---@param action string
function Input:justPressed(action)
    local act = self.actions[action] --[[@as InputAction]]
    if act then
        local pressed = true
        for _, a in ipairs(act.keys) do
            if not love.keyboard.isDown(a) then
                pressed = false
                break
            end
        end
        if pressed then
            if act.last_release >= act.last_press then
                act.last_press = love.timer.getTime()
                return true
            end
        else
            act.last_release = love.timer.getTime()
        end
    end
    return false
end

---Check if action is released
---@param action string
function Input:isReleased(action)
    local act = self.actions[action] --[[@as InputAction]]
    if act then
        local released = true
        for _, a in ipairs(act.keys) do
            if love.keyboard.isDown(a) then
                released = false
                break
            end
            act.last_release = love.timer.getTime()
        end
        return released
    end
    return false
end

---Check if action is just released
---@param action string
function Input:justReleased(action)
    local act = self.actions[action] --[[@as InputAction]]
    if act then
        local now = love.timer.getTime()
        local is_pressed = self:isPressed(action, false)
        if (not is_pressed) and now - act.last_press < love.timer.getDelta() then
            act.last_release = act.last_press
            return true
        end
    end
    return false
end

---Register action
---@param name string
---@param keys? table<string>
---@param alt_keys? table<string>
---@param joystick? table<string>
---@param repeating? number
function Input:registerAction(name, keys, alt_keys, joystick, repeating)
    local act = InputAction.new(name, keys, alt_keys, joystick, repeating)
    self.actions[name] = act
end

return Input