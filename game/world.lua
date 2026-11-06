local Render = require('core.render').getInstance()
local Point = require('core.point')
local Stack = require('core.stack')
local EntityActionID = require('game.entity_action_id')
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

---Constructor
---@param chunk WorldChunk
---@return WorldCell
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
---@field entities table<string, Entity>
---@field active boolean
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
        entities = {},
        active = false,
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
    local posx = pos.x - self.pos.x + 1
    local posy = pos.y - self.pos.y + 1
    local posz = pos.z
    if posx < 1 or posx > self.size.x
        or posy < 1 or posy > self.size.y
        or posz < 1 or posz > self.size.z
    then
        love.logger:error(("WorldChunk:getCell (%d, %d, %d) is out of bounds"):format(posx, posy, posz))
    end
    return self.cells[posz][posy][posx]
end

---Add entity to the chunk
---@param entity Entity
function WorldChunk:addEntity(entity)
    if self.entities[entity.id] == nil then
        self.entities[entity.id] = entity
    end
end

---Remove entity from the chunk
---@param entity Entity
function WorldChunk:removeEntity(entity)
    if self.entities[entity.id] ~= nil then
        self.entities[entity.id] = nil
    end
end

--------------------------------
------------ WORLD -------------
--------------------------------

---@class World
---@field tileset Tileset
---@field chunks table<table<WorldChunk>>
---@field size Point
---@field chunk_size integer
---@field entities table<string, Entity>
---@field action_queue table<EntityActionID, table<EntityAction>>
---@field hero Entity
---@field camera Camera
---@field tick integer
---@field entity_action_handlers table<EntityActionID, function<World, EntityAction>>
local World = {}
World.__index = World

---Constructor
---@param tileset Tileset
---@param camera Camera
---@return World
function World.new(tileset, camera)
    local o = setmetatable({
        tileset = tileset,
        chunks = {},
        size = Point.new(0, 0, 0),
        chunk_size = 0,
        camera = camera,
        entities = {},
        hero = nil,
        action_queue = {},
        tick = 1,
        entity_action_handlers = {},
    }, World)
    return o
end

---Get next tick number
---@param offset? integer
---@return integer
function World:nextTick(offset)
    offset = offset or 1
    return self.tick + offset
end

---Queue action in world
---@param action EntityAction
function World:queueAction(action)
    if not self.action_queue[action.action_id] then
        self.action_queue[action.action_id] = {}
    end
    table.insert(self.action_queue[action.action_id], action)
end

---Sort comparator for EntityAction queue
---@param a EntityAction
---@param b EntityAction
---@return boolean
local function sortActionQueue(a, b)
    return a.tick < b.tick
end

---Process Queue action in world
---@param action_id EntityActionID
function World:processActionQueue(action_id)
    local queue = self.action_queue[action_id]
    local handler = self.entity_action_handlers[action_id]
    if queue and handler then
        table.sort(queue, sortActionQueue)
        self.action_queue[action_id] = {}
        for _, a in ipairs(queue) do
            if a.tick <= self.tick then
                handler(self, a)
            else
                self:queueAction(a)
            end
        end
    end
end

---Register the entity action handler
---@param entity_action_id EntityActionID
---@param func function<World, EntityAction>
function World:registerActionHandler(entity_action_id, func)
    self.entity_action_handlers[entity_action_id] = func
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
                Point.new(((x-1)*chunk_size)+1, ((y-1)*chunk_size)+1, size.z),
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
        love.logger:error(("World:getChunk (%d, %d, %d) is out of bounds!"):format(pos.x, pos.y, pos.z))
        return
    end
    local x = math.ceil(pos.x / self.chunk_size)
    local y = math.ceil(pos.y / self.chunk_size)
    if x < 1 or x > #self.chunks or y < 1 or x > #self.chunks[1] then
        love.logger:error(("World:getChunk Chunk (%d, %d) is out of bounds"):format(x, y))
    end
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

---Set Cell tile_id
---@param pos Point
---@param tile_id integer
function World:setCellTile(pos, tile_id)
    local cell = self:getCell(pos)
    if cell then
        cell.tile_id = tile_id
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

---Add entity to the world
---@param entity Entity
function World:addEntity(entity)
    if self.entities[entity.id] == nil then
        self.entities[entity.id] = entity
        local chunk = self:getChunk(entity.position)
        if chunk ~= nil then
            chunk:addEntity(entity)
        end
    end
end

---Remove entity from the world
---@param entity Entity
function World:removeEntity(entity)
    if self.entities[entity.id] ~= nil then
        local chunk = self:getChunk(entity.position)
        chunk:removeEntity(entity)
        self.entities[entity.id] = nil
    end
end

---Get Entity by id
---@param entity_id string
---@return Entity
function World:getEntity(entity_id)
    return self.entities[entity_id]
end

---Update the active chunks indicator
---@private
function World:updateActiveChunks()
    local start_x = math.ceil(self.camera.center.x / self.chunk_size)
    local end_x = math.ceil((self.camera.center.x + self.camera.size.x) / self.chunk_size)
    local start_y = math.ceil(self.camera.center.y / self.chunk_size)
    local end_y = math.ceil((self.camera.center.y + self.camera.size.y) / self.chunk_size)
    for y = 1, #self.chunks do
        for x = 1, #self.chunks[y] do
            local chunk = self.chunks[y][x]
            if x >= start_x and x <= end_x and y >= start_y and y <= end_y then
                chunk.active = true
            else
                chunk.active = false
            end
        end
    end
end

---Update the world state
---@param dt number
function World:updateChunks(dt)
    self:updateActiveChunks()
end

return World