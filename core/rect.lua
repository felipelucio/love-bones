---@class Rect
---@field x number
---@field y number
---@field w number
---@field h number
local Rect = { class = "Rect" }
Rect.__index = Rect

---Constructor
---@param x number
---@param y number
---@param w number
---@param h number
function Rect.new(x, y, w, h)
    local o = setmetatable({
        x = x or 0,
        y = y or 0,
        w = w or 0,
        h = h or 0,
    }, Rect)
    return o
end

---Return the left position
---@return number
function Rect:left()
    return self.x
end

---Return the right position
---@return number
function Rect:right()
    return self.x + self.w
end

---Return the top position
---@return number
function Rect:top()
    return self.y
end

---Return the bottom position
---@return number
function Rect:bottom()
    return self.y + self.h
end

---Check if point is inside
---@param p hump.Vector|integer
---@param y? integer
---@return boolean
function Rect:pointInside(p, y)
    if type(p) == "table" then
        return p.x >= self:left() and p.x <= self:right() and p.y >= self:top() and p.y <= self:bottom()
    end
    return p >= self:left() and p <= self:right() and y >= self:top() and y <= self:bottom()
end

---Clone this rect
---@return Rect
function Rect:clone()
    return Rect.new(self.x, self.y, self.w, self.h)
end

return Rect