local constants = require('constants')
local Render = require('core.render').getInstance()
local Tween = require('libs.tween.tween')

---Update Camera state
---@param world World
---@param entities table<Entity>
---@param dt number
return function (world, entities, dt)
    local cam = world.camera
    if cam then
        if cam.follow ~= nil then
            if cam.center.x ~= cam.follow.position.x or cam.center.y ~= cam.follow.position.y then
                cam.tween = Tween.new(1, cam, {
                    global_position = cam.follow.position * constants.TILE_SIZE,
                    global_center = {
                        x = (cam.follow.position.x * constants.TILE_SIZE) - math.floor((cam.size.x * constants.TILE_SIZE) / 2),
                        y = (cam.follow.position.y * constants.TILE_SIZE) - math.floor((cam.size.y * constants.TILE_SIZE) / 2),
                    }
                }, 'outQuad')
            end
            if cam.tween ~= nil then
                local completed = cam.tween:update(dt)
                if completed then
                    cam.tween = nil
                end
            end
            cam.center.x = cam.follow.position.x
            cam.center.y = cam.follow.position.y
            cam.center.z = cam.follow.position.z
            cam.position.x = cam.follow.position.x - math.floor(cam.size.x / 2)
            cam.position.y = cam.follow.position.y - math.floor(cam.size.y / 2)
            cam.position.z = cam.follow.position.z
        end
    end
end