local constants = require('constants')
local Render = require('core.render').getInstance()

---Update Camera state
---@param world World
---@param entities table<Entity>
return function (world, entities)
    local cam = world.camera
    if cam then
        if cam.follow ~= nil then
            cam.center.x = cam.follow.position.x
            cam.center.y = cam.follow.position.y
            cam.center.z = cam.follow.position.z
            cam.position.x = cam.follow.position.x - math.floor(cam.size.x / 2)
            cam.position.y = cam.follow.position.y - math.floor(cam.size.y / 2)
            cam.position.z = cam.follow.position.z
            
            cam.global_center = cam.center * (constants.TILE_SIZE * Render.zoom_factor)
            cam.global_position = cam.position * (constants.TILE_SIZE * Render.zoom_factor)
        end
    end
end