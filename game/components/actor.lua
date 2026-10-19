---@enum ActorAffinity
local ActorAffinity = {
    ALLY = 1,
    NEUTRAL = 2,
    ENEMY = 3,
}


---@class Actor
---@field parent Entity
---@field affinity ActorAffinity
---@field hp integer
---@field max_hp integer
---@field mp integer
---@field max_mp integer
---@field xp integer
local Actor = {}
Actor.__index = Actor

---Constructor
---@param parent Entity
---@return Actor
function Actor.new(parent)
    local o = setmetatable({
        parent = parent,
        affinity = ActorAffinity.NEUTRAL,
        hp = 0,
        max_hp = 0,
        mp = 0,
        max_mp = 0,
        xp = 0,
    }, Actor)
    return o
end

return Actor