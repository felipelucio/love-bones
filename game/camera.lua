local Point = require('core.point')
local Render = require('core.render').getInstance()

---@class Camera
---@field size Point
---@field position Point
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
        size = size,
    }, Camera)
    return o
end

---Update camera position
function Camera:update()
    if self.follow ~= nil then
        self:moveTo(self.follow.position)
    end
end

---Move camera to position (centered)
---@param pos Point
function Camera:moveTo(pos)
    self.position.x = pos.x - math.floor(self.size.x / 2)
    self.position.y = pos.y - math.floor(self.size.y / 2)
    self.position.z = pos.z
end

return Camera