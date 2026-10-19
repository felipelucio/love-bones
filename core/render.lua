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
        local win_w, win_h = love.window.getDesktopDimensions()
        instance = setmetatable({
            internal_resolution_width = constants.INTERNAL_RES_W,
            internal_resolution_height = constants.INTERNAL_RES_H,
            window_width = win_w,
            window_height = win_h,
            tile_size = 16,
            zoom_factor = 1.0,
        }, Render)
        instance:recalc()
    end
    return instance
end

---Recalculate the rendering zoom factor
function Render:recalc()
    self.zoom_factor = self.window_width / self.internal_resolution_width
end

---Set internal resolution
---@param w integer
---@param h integer
function Render:setInternalResolution(w, h)
    self.internal_resolution_width = w
    self.internal_resolution_height = w
    self:recalc()
end

---Return how many tiles fit in screen
---@return integer, integer
function Render:getSizeTiles()
    return math.ceil(self.internal_resolution_width / self.tile_size),
        math.ceil(self.internal_resolution_height / self.tile_size)
end

return Render