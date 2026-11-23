local Tileset = require('core.tileset').getInstance()
local LOVELi = require('libs.LOVELi.LOVELi')

---@class TileEditor
---@field tileset Tileset
local TileEditor = {}
TileEditor.__index = TileEditor

---Constructor
---@return TileEditor
function TileEditor.new()
    local o = setmetatable({
        tileset = Tileset,
    }, TileEditor)
    return o
end

function TileEditor:draw()
    self.tile_list = LOVELi.StackLayout:new{ orientation = "vertical", spacing = 5, width = "auto", height = "auto" }

    for i, t in ipairs(self.tileset.tiles) do
        self.tile_list:with(LOVELi.StackLayout:new{ orientation = "horizontal", width = "auto", height = 100 }
            :with(LOVELi.Button:new{ text = "Item "..i })
            :with(LOVELi.Label:new{ text = "Item "..i })
            :with(LOVELi.GraphicsView:new{ width = 32, height = 32, drawable = function (sender, x, y)
                self.tileset:draw(i, x, y)
            end})
        )
    end
    return LOVELi.LayoutManager:new{}:with(LOVELi.StackLayout:new{ orientation = "vertical", width = 800, height = 600,  }
        :with(LOVELi.ScrollView:new{ orientation = "vertical", verticalscrollbarincrement = 10, width = 800, height = 600 }
            :with(LOVELi.StackLayout:new{ orientation = "vertical", }
                :with(LOVELi.Label:new{ text = "TileEditor" })
                :with(LOVELi.Button:new{ text = "Teste" })
            )
        )
    )
end

return TileEditor