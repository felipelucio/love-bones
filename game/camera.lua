local constants = require('constants')
local Point = require('core.point')

---@class Camera
---@field size Point
---@field position Point
---@field center Point
---@field global_size Point
---@field global_position Point
---@field global_center Point
---@field follow Entity
local Camera = {}
Camera.__index = Camera

---Constructor
---@param global_size Point
---@return Camera
function Camera.new(global_size)
    local size_tiles = global_size:copy()
    size_tiles.x = math.ceil(global_size.x / constants.TILE_SIZE)
    size_tiles.y = math.ceil(global_size.y / constants.TILE_SIZE)
    local o = setmetatable({
        follow = nil,
        position = Point.new(1, 1, 1),
        center = Point.new(1, 1, 1),
        size = size_tiles,
        global_position = Point.new(1, 1, 1) * constants.TILE_SIZE,
        global_center = Point.new(1, 1, 1) * constants.TILE_SIZE,
        global_size = global_size,
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