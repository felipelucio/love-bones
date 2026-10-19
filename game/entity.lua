local Lume = require('libs.lume')
local Point = require('core.point')

---@class Entity
---@field id string
---@field position Point
---@field size Point
---@field actor Actor
---@field ai ActorAI
---@field animation Animation
---@field item Item
---@field container Container
local Entity = {}
Entity.__index = Entity

---Constructor
---@return Entity
function Entity.new()
    return setmetatable({
        id = Lume.uuid(),
        position = Point.new(0, 0, 0),
        size = Point.new(0, 0, 0),
        actor = nil,
        ai = nil,
        animation = nil,
        item = nil,
        container = nil,
    })
end

---Check if entity has a given component
---@param comp string
---@return boolean
function Entity:hasComponent(comp)
   return self[comp] ~= nil
end

return Entity