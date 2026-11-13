return function (world, action)
    action = action --[[@as MoveByAction]]
    local ent = world:getEntity(action.entity_id)
    if ent then
        ent.position.x = action.dest.x
        ent.position.y = action.dest.y
        ent.position.z = action.dest.z
    end
end