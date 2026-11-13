local constants = require('constants')
local Point = require('core.point')
local Render = require('core.render').getInstance()

---@class Camera
---@field size Point
---@field position Point
---@field center Point
---@field global_position Point
---@field global_center Point
---@field follow Entity
---@field tween any
local Camera = {}
Camera.__index = Camera

---Constructor
---@return Camera
function Camera.new()
    local tsw, tsh = Render:getSizeTiles()
    local o = setmetatable({
        follow = nil,
        position = Point.new(0, 0, 0),
        center = Point.new(0, 0, 0),
        size = Point.new(tsw, tsh, 1),
        global_position = Point.new(0, 0, 0),
        global_center = Point.new(0, 0, 0),
        global_size = Point.new(Render.internal_resolution_width, Render.internal_resolution_height, 1),
        tween = nil,
    }, Camera)
    return o
end

---Follow a given entity
---@param entity Entity
function Camera:setFollow(entity)
    if entity and entity.position then
        self.follow = entity
    end
end

return Camera