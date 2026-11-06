local constants = require('constants')
local Flux = require('libs.flux.flux')
local Camera = require('game.camera')

---@class Animation
---@field parent Entity
---@field position Point
---@field tween any
---@field spritesheet Spritesheet
---@field state string
---@field animations table
---@field time number
---@field curr_frame integer
---@field fps integer
---@field paused boolean
local Animation = {}
Animation.__index = Animation

---Constructor
---@param parent Entity
---@param spritesheet Spritesheet
---@param animations table
function Animation.new(parent, spritesheet, animations, fps)
    local o = setmetatable({
        parent = parent,
        position = parent.position:copy(),
        tween = nil,
        spritesheet = spritesheet,
        state = "idle",
        animations = animations or {},
        time = 0.0,
        curr_frame = 1,
        fps = fps or 8,
        paused = false,
    }, Animation)
    return o
end

---Set current animation state
---@param state string
function Animation:setState(state)
    if self.animations[state] ~= nil then
        self.state = state
    end
end

---Get current animation frames
---@return table|nil
function Animation:getCurrentAnim()
    if self.animations and self.animations[self.state] then
        return self.animations[self.state]
    end
    return nil
end

---Get curr frame index
---@return integer|nil
function Animation:getCurrentFrame()
    if self.animations and self.animations[self.state] and self.animations[self.state] then
        return self.animations[self.state].frames[self.curr_frame]
    end
    return nil
end

return Animation