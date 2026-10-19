---@class ActorAI
---@field parent Entity
local ActorAI = {}
ActorAI.__index = ActorAI

---Constructor
---@param parent Entity
---@return ActorAI
function ActorAI.new(parent)
    local o = setmetatable({
        parent = parent,
    }, ActorAI)
    return o
end

return ActorAI