local EntityAction = require('game.entity_action')
local EntityActionID = require('game.entity_action_id')

---@class MoveByAction: EntityAction
---@field dest Point
local MoveByAction = setmetatable({}, EntityAction)
MoveByAction.__index = MoveByAction

---Constructor
---@param entity Entity
---@param tick EntityActionID
---@param dest_point Point
---@return MoveByAction
function MoveByAction.new(entity, tick, dest_point)
    local o = EntityAction.new(entity, EntityActionID.MOVE_BY, tick)
    o = setmetatable(o, MoveByAction) --[[@as MoveByAction]]
    o.dest = dest_point
    return o
end

return MoveByAction