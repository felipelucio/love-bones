local Input = require('core.input').getInstance()
local Point = require('core.point')
local MoveByAction = require('game.actions.move_by_action')

---handle Inputs
---@param world World
---@param entities table<Entity>
return function (world, entities)
    local dest = Point.new(0, 0, 0)
    if Input:isPressed("move_n") then
        dest.y = -1
    elseif Input:isPressed("move_s") then
        dest.y = 1
    end

    if Input:isPressed("move_w") then
        dest.x = -1
    elseif Input:isPressed("move_e") then
        dest.x = 1
    end

    if Input:isPressed("move_up") then
        dest.z = - 1
    elseif Input:isPressed("move_down") then
        dest.z = 1
    end

    if dest:len() > 0 then
        world:queueAction(MoveByAction.new(world.hero, world.tick, dest))
    end
end