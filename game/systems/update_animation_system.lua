local constants = require('constants')
local Flux = require('libs.flux.flux')
local Render = require('core.render').getInstance()

---update Animation state
---@param world World
---@param entities table<Entity>
return function (world, entities)
    for _, ent in ipairs(entities) do
        ent = ent --[[@as Entity]]
        if ent.animation then
            local anim = ent.animation
            anim.time = anim.time + world.tick
            local curr_anim = anim:getCurrentAnim()
            if curr_anim then
                if anim.time >= 1/anim.fps then
                    anim.time = 0
                    anim.curr_frame = anim.curr_frame + 1
                    if anim.curr_frame > #curr_anim.frames then
                        anim.curr_frame = 1
                    end
                end
            end

            local anim_pos = anim.position
            local ent_pos = anim.parent.position:copy() * constants.TILE_SIZE * Render.zoom_factor
            if ent_pos.x ~= anim_pos.x or
                ent_pos.y ~= anim_pos.y
            then
                local dest = { x = ent_pos.x, y = ent_pos.y }
                anim.tween = Flux.to(anim.position, 0.2, dest)
            end
        end
    end
end