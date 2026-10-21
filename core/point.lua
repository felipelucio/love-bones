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

---Return a copy to the point
---@return Point
function Point:copy()
    return Point.new(self.x, self.y, self.z)
end

function Point.__unm(a)
	return Point.new(-a.x, -a.y, -a.z)
end

function Point.__add(a,b)
	return Point.new(a.x+b.x, a.y+b.y, a.z+b.z)
end

function Point.__sub(a,b)
	return Point.new(a.x-b.x, a.y-b.y, a.z-b.z)
end

function Point.__mul(a,b)
	if type(a) == "number" then
		return Point.new(a*b.x, a*b.y, a*b.z)
	elseif type(b) == "number" then
		return Point.new(b*a.x, b*a.y, b*a.z)
	else
		return a.x*b.x + a.y*b.y, a.z*b.z
	end
end

function Point.__div(a,b)
	return Point.new(a.x / b, a.y / b, a.z / b)
end

function Point.__eq(a,b)
	return a.x == b.x and a.y == b.y and a.z == b.z
end

return Point