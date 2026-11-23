local Input = require('core.input').getInstance()
local Render = require('core.render').getInstance()

---System that gets cell information under then mouse pointer and draw the rectangle around it
---@param world World
return function (world)
    local mtile = Input:getMouseTile()
    local cell = world:getCell(mtile)
    local mx, my = love.mouse.getPosition()
    local ts = world.tileset
    if cell ~= nil then
        -- TODO: fix this... i don't know why y is half of x axis.
        love.graphics.rectangle("line",
            math.floor(mx - ((mx + (Render.tile_size * Render.zoom_factor)) % (Render.tile_size * Render.zoom_factor))),
            math.floor(my - ((my + (Render.tile_size * Render.zoom_factor)/2) % (Render.tile_size * Render.zoom_factor))),
            Render.tile_size * Render.zoom_factor, Render.tile_size * Render.zoom_factor
        )
        local tdef = ts:get(cell.tile_id)
        if tdef then
            love.logger:debug(("Tile (%d, %d): %s"):format(mtile.x, mtile.y, tdef.description))
        end
    end
    ---Draw the rectangle
end