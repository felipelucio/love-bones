local Point = require('core.point')
local Render = require('core.render').getInstance()

---@class Camera
---@field size Point
---@field position Point
---@field center Point
---@field follow Entity
local Camera = {}
Camera.__index = Camera

---Constructor
---@param size Point
---@return Camera
function Camera.new(size)
    local o = setmetatable({
        follow = nil,
        position = Point.new(1, 1, 1),
        center = Point.new(1, 1, 1),
        size = size,
    }, Camera)
    o:moveTo(Point.new(1, 1, 1))
    return o
end

---Follow a given entity
---@param entity Entity
function Camera:setFollow(entity)
    if entity and entity.position then
        self.follow = entity
    end
end

---Update camera position
---@param dt number
function Camera:update(dt)
    if self.follow ~= nil then
        self:moveTo(self.follow.position)
    end
end

---Move camera to position (centered)
---@param pos Point
function Camera:moveTo(pos)
    self.center.x = pos.x
    self.center.y = pos.y
    self.center.z = pos.z
    self.position.x = pos.x - math.floor(self.size.x / 2)
    self.position.y = pos.y - math.floor(self.size.y / 2)
    self.position.z = pos.z
end

return Camera