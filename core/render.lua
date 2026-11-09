local constants = require('constants')

local instance = nil

---@class Render
---@field internal_resolution_width integer
---@field internal_resolution_height integer
---@field window_width integer
---@field window_height integer
---@field zoom_factor number
---@field tile_size integer
local Render = {}
Render.__index = Render

---Get instance
---@return Render
function Render.getInstance()
    if not instance then
        instance = setmetatable({
            internal_resolution_width = constants.INTERNAL_RES_W,
            internal_resolution_height = constants.INTERNAL_RES_H,
            window_width = love.graphics.getWidth(),
            window_height = love.graphics.getHeight(),
            tile_size = constants.TILE_SIZE,
            zoom_factor = 1.0,
        }, Render)
        instance:recalc()
    end
    return instance
end

---Recalculate the rendering zoom factor
function Render:recalc()
    self.window_width = love.graphics.getWidth()
    self.window_height = love.graphics.getHeight()
    self.zoom_factor = self.window_width / self.internal_resolution_width
end

---Set internal resolution
---@param w integer
---@param h integer
function Render:setInternalResolution(w, h)
    self.internal_resolution_width = w
    self.internal_resolution_height = h
    self:recalc()
end

---Return how many tiles fit in screen
---@return integer, integer
function Render:getSizeTiles()
    return math.ceil(self.window_width / (self.tile_size * self.zoom_factor)),
        math.ceil(self.window_height / (self.tile_size * self.zoom_factor))
end

return Render