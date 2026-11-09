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
    for z = 0, 1 do
        for y = 0, ytiles do
            for x = 0, xtiles do
                p.x = cam.position.x + x
                p.y = cam.position.y + y
                p.z = cam.position.z + z
                -- love.graphics.rectangle("line", x*constants.TILE_SIZE* Render.zoom_factor, y*constants.TILE_SIZE* Render.zoom_factor, constants.TILE_SIZE * Render.zoom_factor, constants.TILE_SIZE * Render.zoom_factor)
                if p.x < 1 or p.x > world.size.x or p.y < 1 or p.y > world.size.y then
                    goto continue
                end
                local c = world:getCell(p)
                if c then
                    tileset:draw(c.tile_id, x*constants.TILE_SIZE, y*constants.TILE_SIZE, nil, nil, Render.zoom_factor)
                end
                ::continue::
            end
        end
    end
end