local constants = require('constants')
local Render = require('core.render').getInstance()
local Point = require('core.point')

---Draw Tilemap 
---@param world World
---@param tileset Tileset
return function (world, tileset)
    local cam = world.camera
    local p = Point.new(0, 0, 0)
    local xtiles, ytiles = Render:getSizeTiles()
    xtiles = xtiles + 2
    ytiles = ytiles + 2

    local offset = constants.TILE_SIZE
    -- draw layer below
    love.graphics.setColor(1, 1, 1, 0.2)
    for y = -3, ytiles do
        for x = -3, xtiles do
            p.x = math.floor(cam.position.x) + x
            p.y = math.floor(cam.position.y) + y
            p.z = cam.position.z + 1
            -- love.graphics.rectangle("line", x*constants.TILE_SIZE* Render.zoom_factor, y*constants.TILE_SIZE* Render.zoom_factor, constants.TILE_SIZE * Render.zoom_factor, constants.TILE_SIZE * Render.zoom_factor)
            if p.x < 1 or p.x > world.size.x or p.y < 1 or p.y > world.size.y then
                goto continue
            end
            local c = world:getCell(p)
            if c and c.tile_id ~= nil then
                tileset:draw(
                    c.tile_id,
                    (p.x*constants.TILE_SIZE)-cam.global_center.x-offset,
                    (p.y*constants.TILE_SIZE)-cam.global_center.y-offset,
                    nil, nil, Render.zoom_factor)
            end
            ::continue::
        end
    end
    love.graphics.setColor(1, 1, 1, 1)

    -- draw the actual layer camera is in
    for y = -3, ytiles do
        for x = -3, xtiles do
            p.x = math.floor(cam.position.x) + x
            p.y = math.floor(cam.position.y) + y
            p.z = cam.position.z
            -- love.graphics.rectangle("line", x*constants.TILE_SIZE* Render.zoom_factor, y*constants.TILE_SIZE* Render.zoom_factor, constants.TILE_SIZE * Render.zoom_factor, constants.TILE_SIZE * Render.zoom_factor)
            if p.x < 1 or p.x > world.size.x or p.y < 1 or p.y > world.size.y then
                goto continue
            end
            local c = world:getCell(p)
            if c and c.tile_id ~= nil then
                tileset:draw(
                    c.tile_id,
                    (p.x*constants.TILE_SIZE)-cam.global_center.x,
                    (p.y*constants.TILE_SIZE)-cam.global_center.y,
                    nil, nil, Render.zoom_factor)
            end
            ::continue::
        end
    end
end