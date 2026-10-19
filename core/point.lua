---@class Point
---@field x integer
---@field y integer
---@field z integer
local Point = {}
Point.__index = Point

---Constructor
---@param x integer
---@param y integer
---@param z integer
---@return Point
function Point.new(x, y, z)
    return setmetatable({
        x = x or 0,
        y = y or 0,
        z = z or 0,
    }, Point)
end

return Point