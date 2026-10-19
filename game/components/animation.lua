---@class Animation
---@field parent Entity
local Animation = {}
Animation.__index = Animation

---Constructor
---@param parent Entity
function Animation.new(parent)
    local o = setmetatable({
        parent = parent,
    }, Animation)
end

return Animation