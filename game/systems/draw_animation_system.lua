local constants = require('constants')
local Render = require('core.render').getInstance()

---Draw Animation
---@param world World
---@param entities table<Entity>
return function (world, entities)
    local cam = world.camera
    for _, ent in ipairs(entities) do
        ent = ent --[[@as Entity]]
        if ent.animation then
            local anim = ent.animation
            local curr_frame = anim.animations[anim.state].frames[anim.curr_frame]
            if curr_frame then
                -- if anim.parent.is_player then
                --     love.logger:debug(("P(%d, %d) C(%d, %d)"):format(anim.position.x, anim.position.y, world.camera.global_position.x, world.camera.global_position.y))
                -- end
                love.graphics.draw(
                    anim.spritesheet:getTexture(),
                    anim.spritesheet:get(curr_frame),
                    (anim.position.x-cam.global_position.x), (anim.position.y-cam.global_position.y),
                    nil, Render.zoom_factor, Render.zoom_factor
                )
            end
        end
    end
end