local Point = require('core.point')

-------------------------------------------
--------    Path       --------------------
-------------------------------------------
---@class Path
---@field nodes table<PathNode>
---@field total_cost number
local Path = {}
Path.__index = Path

---Constructor
---@param nodes table<PathNode>
---@param total_cost number
---@return Path
function Path.new(nodes, total_cost)
    local o = setmetatable({
        nodes = nodes,
        total_cost = total_cost,
    }, Path)
    return o
end

---Get all Nodes
---@return table<PathNode>
function Path:getNodes()
    return self.nodes
end

---Get the move total cost
---@return number
function Path:getTotalMoveCost()
    return self.total_cost
end

-------------------------------------------
--------    PathNode   --------------------
-------------------------------------------
---@class PathNode
---@field location Point
---@field mCost number
---@field parent PathNode
---@field score number
---@field lid integer
local PathNode = {}
PathNode.__index = PathNode

---Constructor
---@param location Point
---@param mCost number
---@param lid integer
---@param parent PathNode
---@return PathNode
function PathNode.new(location, mCost, lid, parent)
    local o = setmetatable({
        location = location, -- Where is the node located
        mCost = mCost, -- Total move cost to reach this node
        parent = parent, -- Parent node
        score = 0, -- Calculated score for this node
        lid = lid, -- set the location id - unique for each location in the map
    }, PathNode)
    return o
end

function PathNode.__eq(a, b)
  return a.lid == b.lid
end


-------------------------------------------
--------    Pathfind   --------------------
-------------------------------------------
---@class Pathfind
---@field mh any
---@field open table<PathNode>
---@field closed table<PathNode>
local Pathfind = {}
Pathfind.__index = Pathfind

---Constructor
---@param maphandler any
function Pathfind.new(maphandler)
    local o = setmetatable({
        mh = maphandler,
    }, Pathfind)
    return o
end

---Get best open PathNode
---@private
---@return PathNode
function Pathfind:_getBestOpenNode()
    local bestNode = nil

    for lid, n in pairs(self.open) do
        if bestNode == nil then
            bestNode = n
        else
            if n.score <= bestNode.score then
                bestNode = n
            end
        end
    end
    return bestNode
end

---Trace path
---@private
---@param n PathNode
---@return Path
function Pathfind:_tracePath(n)
    local nodes = {}
    local totalCost = n.mCost
    local p = n.parent

    table.insert(nodes, 1, n)

    while true do
        if p.parent == nil then
            break
        end
        table.insert(nodes, 1, p)
        p = p.parent
    end
    return Path(nodes, totalCost)
end

---Handle PathNode
---@private
---@param node PathNode
---@param goal Point
---@return unknown
function Pathfind:_handleNode(node, goal)
    self.open[node.lid] = nil
    self.closed[node.lid] = node.lid

    assert(node.location ~= nil, 'About to pass a node with nil location to getAdjacentNodes')

    local nodes = self.mh:getAdjacentNodes(node, goal)

    for lid, n in pairs(nodes) do repeat
        if self.mh:locationsAreEqual(n.location, goal) then
            return n
        elseif self.closed[n.lid] ~= nil then -- Alread in close, skip this
            break
        elseif self.open[n.lid] ~= nil then -- Already in open, check if better score   
            local on = self.open[n.lid] --[[@as PathNode]]

            if n.mCost < on.mCost then
                self.open[n.lid] = nil
                self.open[n.lid] = n
            end
        else -- New node, append to open list
            self.open[n.lid] =  n
        end
    until true end

    return nil
end

---Find the path from Point to Point
---@param fromlocation Point
---@param tolocation Point
---@return Path|nil
function Pathfind:findPath(fromlocation, tolocation)
    self.open = {}
    self.closed = {}

    local goal = tolocation
    local fnode = self.mh:getNode(fromlocation)

    local nextNode = nil
    if fnode ~= nil then
        self.open[fnode.lid] = fnode
        nextNode = fnode
    end
    while nextNode ~= nil do
        local finish = self:_handleNode(nextNode, goal)
        if finish then
            return self:_tracePath(finish)
        end
        nextNode = self:_getBestOpenNode()
    end
    return nil
end

-------------------------------------------
--------    MapHandler   ------------------
-------------------------------------------
---@class MapHandler
---@field world World
local MapHandler = {}
MapHandler.__index = MapHandler

---Constructor
---@param world World
---@return MapHandler
function MapHandler.new(world)
    return setmetatable({
        world = world,
    }, MapHandler)
end

---Get PathNode
---@param location Point
---@return PathNode|nil
function MapHandler:getNode(location)
    -- Here you make sure the requested node is valid (i.e. on the map, not blocked)
    -- if the location is not valid, return nil, otherwise return a new Node object
    local cell = self.world:getCell(location)
    if not cell then
        return nil
    end
    if not cell.passable then
        return nil
    end
    return PathNode(location, 1, location.y * self.world.size.x + location.x)
end

---Check if location `a` is equal to `b`
---@param a Point
---@param b Point
---@return boolean
function MapHandler:locationsAreEqual(a, b)
  -- Here you check to see if two locations (not nodes) are equivalent
  -- If you are using a vector for a location you may be able to simply
  -- return a == b
  -- however, if your location is represented some other way, you can handle 
  -- it correctly here without having to modufy the AStar class
  return a.x == b.x and a.y == b.y
end

---Get adjacent nodes
---@param curnode PathNode
---@param dest Point
---@return table<PathNode>
function MapHandler:getAdjacentNodes(curnode, dest)
    -- Given a node, return a table containing all adjacent nodes
    -- The code here works for a 2d tile-based game but could be modified
    -- for other types of node graphs
    local result = {}
    local cl = curnode.location
    local dl = dest

    local n = nil
    n = self:_handleNode(cl.x + 1, cl.y, cl.z, curnode, dl.x, dl.y, dl.z)
    if n then
        table.insert(result, n)
    end
    n = self:_handleNode(cl.x - 1, cl.y, cl.z, curnode, dl.x, dl.y, dl.z)
    if n then
        table.insert(result, n)
    end
    n = self:_handleNode(cl.x, cl.y + 1, cl.z, curnode, dl.x, dl.y, dl.z)
    if n then
        table.insert(result, n)
    end
    n = self:_handleNode(cl.x, cl.y - 1, cl.z, curnode, dl.x, dl.y, dl.z)
    if n then
        table.insert(result, n)
    end
    return result
end

---Handle PathNode
---@private
---@param x integer
---@param y integer
---@param z integer
---@param fromnode PathNode
---@param destx integer
---@param desty integer
---@param destz integer
---@return PathNode|nil
function MapHandler:_handleNode(x, y, z, fromnode, destx, desty, destz)
    -- Fetch a Node for the given location and set its parameters
    local n = self:getNode(Point.new(x, y, z))
    if n ~= nil then
        local dx = math.max(x, destx) - math.min(x, destx)
        local dy = math.max(y, desty) - math.min(y, desty)
        local dz = math.max(z, destz) - math.min(z, destz)
        local emCost = dx + dy + dz

        n.mCost = n.mCost + fromnode.mCost
        n.score = n.mCost + emCost
        n.parent = fromnode
        return n
    end
    return nil
end

return {
    Pathfind = Pathfind,
    MapHandler = MapHandler,
}