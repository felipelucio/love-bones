local Flux = require('libs.flux.flux')
local Point = require('core.point')

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

---Update Animation
---@param dt number
function Animation:update(dt)
    self.time = self.time + dt
    local curr_anim = self:getCurrentAnim()
    if curr_anim then
        if self.time >= 1/self.fps then
            self.time = 0
            self.curr_frame = self.curr_frame + 1
            if self.curr_frame > #curr_anim.frames then
                self.curr_frame = 1
            end
        end
    end

    local anim_pos = self.position
    local ent_pos = self.parent.position:copy() * 16
    if ent_pos.x ~= anim_pos.x or
        ent_pos.y ~= anim_pos.y
    then
        local dest = { x = ent_pos.x, y = ent_pos.y }
        self.tween = Flux.to(self.position, 0.2, dest)
    end
end

function Animation:draw(offset)
    local curr_frame = self.animations[self.state].frames[self.curr_frame]
    if curr_frame then
        love.graphics.draw(self.spritesheet:getTexture(), self.spritesheet:get(curr_frame), self.position.x, self.position.y)
    end
end

return Animation