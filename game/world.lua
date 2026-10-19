local Render = require('core.render').getInstance()
local Point = require('core.point')
local Stack = require('core.stack')
local Camera = require('game.camera')
---------------------------------------
---------- WorldCell ------------------
---------------------------------------

---@class WorldCell
---@field chunk WorldChunk
---@field tile_id integer
---@field passable boolean
---@field stack Stack
---@field stack_height integer
---@field actor Entity
local WorldCell = {}
WorldCell.__index = WorldCell

function WorldCell.new(chunk)
    return setmetatable({
        chunk = chunk,
        tile_id = 0,
        passable = false,
        stack = Stack.new(),
        stack_height = 0,
        actor = nil,
    }, WorldCell)
end

---Add entity to cell
---@param entity Entity
---@return boolean
function WorldCell:add(entity)
    if entity.actor ~= nil then
        if self.actor ~= nil then
            return false
        end
        self.actor = entity
        self.passable = false
    elseif entity.item ~= nil then
        if self.stack:add(entity) then
            self.stack_height = self.stack_height + entity.item.height
            if self.stack_height > 1 then
                self.passable = false
            end
            return true
        end
    end
    return false
end

---Add entity to cell
---@param entity Entity
---@return boolean
function WorldCell:remove(entity)
    if entity.actor.parent.id == entity.id then
        self.actor = nil
        self.passable = true
        return true
    elseif entity.item ~= nil then
        if self.stack:remove(entity) then
            self.stack_height = self.stack_height - entity.item.height
            if self.stack_height > 1 then
                self.passable = false
            else
                self.passable = true
            end
            return true
        end
    end
    return false
end

----------------------------------------
---------- WorldChunk ------------------
----------------------------------------

---@class WorldChunk
---@field world World
---@field pos Point
---@field size Point
---@field cells table<WorldCell>
local WorldChunk = {}
WorldChunk.__index = WorldChunk

---Constructor
---@param world World
---@param pos Point
---@param size Point
function WorldChunk.new(world, pos, size)
   local o = setmetatable({
        world = world,
        pos = pos,
        size = size,
        cells = {},
   }, WorldChunk)
   o:clear()
   return o
end

---Clear the chunk
function WorldChunk:clear()
    self.cells = {}
    for z = 1, self.size.z do
        self.cells[z] = {}
        for y = 1, self.size.y do
            self.cells[z][y] = {}
            for x = 1, self.size.x do
               self.cells[z][y][x] = WorldCell.new(self)
            end
        end
    end
end

---Get cell
---@param pos Point World Position
---@return WorldCell
function WorldChunk:getCell(pos)
    local posx = math.floor(pos.x / self.pos.x) + 1
    local posy = math.floor(pos.y / self.pos.y) + 1
    local posz = math.floor(pos.z / self.pos.z) + 1
    if posx < 1 or posx > self.size.x
        or posy < 1 or posy > self.size.y
        or posz < 1 or posz > self.size.z
    then
        love.logger:error("WorldChunk:getCell out of bounds")
    end
    return self.cells[posz][posy][posx]
end

--------------------------------
------------ WORLD -------------
--------------------------------

---@class World
---@field chunks table<table<WorldChunk>>
---@field size Point
---@field chunk_size integer
---@field camera Camera
local World = {}
World.__index = World

---Constructor
---@return World
function World.new()
    local tW, tH = Render:getSizeTiles()
    local o = setmetatable({
        chunks = {},
        size = Point.new(0, 0, 0),
        chunk_size = 0,
        camera = Camera.new(Point.new(tW, tH, 1)),
    }, World)
    return o
end

---Init map structure
---@param size Point
---@param chunk_size integer
function World:init(size, chunk_size)
    local xchunks = math.floor(size.x / chunk_size)
    local ychunks = math.floor(size.y / chunk_size)
    self.chunks = {}
    self.size = size
    self.chunk_size = chunk_size
    for y = 1, ychunks do
        self.chunks[y] = {}
        for x = 1, xchunks do
            self.chunks[y][x] = WorldChunk.new(
                self,
                Point.new(xchunks*chunk_size, ychunks*chunk_size, size.z),
                Point.new(chunk_size, chunk_size, size.z)
            )
        end
    end
end

---Get chunk by position
---@param pos Point
---@return WorldChunk|nil
function World:getChunk(pos)
    if pos.x < 1 or pos.x > self.size.x
        or pos.y < 1 or pos.y > self.size.y
        or pos.z < 1 or pos.z > self.size.z
    then
        love.logger:error("World:getChunk is out of bounds!")
        return
    end
    local x = math.ceil(pos.x / (self.chunk_size))
    local y = math.ceil(pos.y / (self.chunk_size))
    return self.chunks[y][x]
end

---Get Cell
---@param pos Point
---@return WorldCell|nil
function World:getCell(pos)
    local chunk = self:getChunk(pos)
    if chunk ~= nil then
        return chunk:getCell(pos)
    end
end

---Get Cell relative to another one
---@param pos Point
---@param rel Point
---@return WorldCell|nil
function World:getCellRelative(pos, rel)
    local rpos = Point.new(pos.x + rel.x, pos.y + rel.y, pos.z + rel.z)
    return self:getCell(rpos)
end

---Check if cell can be occupied
---@param pos Point
---@return boolean
function World:canMove(pos)
    local cell = self:getCell(pos)
    return cell.passable
end

return World