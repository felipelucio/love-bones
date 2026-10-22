local EntityAction = require('game.entity_action')
local EntityActionID = require('game.entity_action_id')

---@class MoveToAction: EntityAction
---@field dest Point
local MoveToAction = setmetatable({}, EntityAction)
MoveToAction.__index = MoveToAction

---Constructor
---@param entity Entity
---@param tick EntityActionID
---@param dest_point Point
---@return MoveToAction
function MoveToAction.new(entity, tick, dest_point)
    local o = EntityAction.new(entity, EntityActionID.MOVE_TO, tick)
    o = setmetatable(o, MoveToAction) --[[@as MoveToAction]]
    o.dest = dest_point
    return o
end

return MoveToAction