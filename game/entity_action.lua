---@class EntityAction
---@field entity_id string
---@field action_id EntityActionID
---@field tick integer
local EntityAction = {}
EntityAction.__index = EntityAction

---Constructor
---@param entity Entity
---@param action_id EntityActionID
---@param tick any
---@return EntityAction
function EntityAction.new(entity, action_id, tick)
    return setmetatable({
        entity_id = entity.id,
        action_id = action_id,
        tick = tick,
    }, EntityAction)
end

return EntityAction