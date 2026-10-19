local Point = require('core.point')
local Stack = require('core.stack')
---------------------------------------
---------- WorldCell ------------------
---------------------------------------

---@class WorldCell
---@field chunk WorldChunk
---@field tile_id integer
---@field passable boolean
---@field stack Stack
local WorldCell = {}
WorldCell.__index = WorldCell

function WorldCell.new(chunk)
    return setmetatable({
        chunk = chunk,
        tile_id = 0,
        passable = false,
        stack = Stack.new(),
    }, WorldCell)
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
    local posx = pos.x - self.pos.x
    local posy = pos.y - self.pos.y
    local posz = pos.z - self.pos.z
    if posx < 1 or posx > self.size.x
        or posy < 1 or posy > self.size.y
        or posz < 1 or posz > self.size.z
    then
        love.logger:error("WorldChunk:getCell out of bounds")
    end
    print(posx, posy, posz)
    return self.cells[posz][posy][posx]
end

--------------------------------
------------ WORLD -------------
--------------------------------

---@class World
---@field chunks table<table<WorldChunk>>
---@field size Point
---@field chunk_size integer
local World = {}
World.__index = World

---Constructor
---@return World
function World.new()
    local o = setmetatable({
        chunks = {},
        size = Point.new(0, 0, 0),
        chunk_size = 0,
    }, World)
    return o
end

---Init map structure
---@param size Point
---@param chunk_size integer
function World:init(size, chunk_size)
    local xchunks = math.ceil(size.x / chunk_size)
    local ychunks = math.ceil(size.y / chunk_size)
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
---@return WorldChunk
function World:getChunk(pos)
    local x = math.floor(pos.x / self.chunk_size) + 1
    local y = math.floor(pos.y / self.chunk_size) + 1
    print(x, y)
    return self.chunks[y][x]
end

---Get Cell
---@param pos Point
---@return WorldCell
function World:getCell(pos)
    local chunk = self:getChunk(pos)
    return chunk:getCell(pos)
end

return World