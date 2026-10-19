local generators = {
    love.math.newRandomGenerator()
} --[[@as table<love.RandomGenerator>]]

---@class Random
local Random = { class = "Random" }
Random.__index = Random

function Random.resetGenerators()
    generators = {}
    table.insert(generators, love.math.newRandomGenerator())
end

function Random.pushGenerator(seed)
    table.insert(generators, love.math.newRandomGenerator(Random.scrambleSeed(seed)))
end

--scrambles a given seed, this helps eliminate patterns between the outputs of similar seeds
--Algorithm used is MX3 by Jon Maiga (jonkagstrom.com), CC0 license.
-- TODO implement
function Random.scrambleSeed(seed)
    -- seed = seed ^ >>> 32
    -- seed *= 0xbea225f9eb34556dL
    -- seed ^= seed >>> 29
    -- seed *= 0xbea225f9eb34556dL
    -- seed ^= seed >>> 32
    -- seed *= 0xbea225f9eb34556dL
    -- seed ^= seed >>> 29
    return seed
end

function Random.popGenerator()
    if #generators == 1 then
        print("this is the last generator!")
    else
        generators[#generators] = nil
    end
end

---Returns an index from chances, the probability of each index is the weight values in changes.
---Negative values are treated as 0.
---@param chances table<number>
---@return integer
function Random.chances(chances)
    local length = #chances
    local sum = 0
    for i = 1, length do
        sum = sum + chances[i]
    end
    if sum <= 0 then
        return -1
    end

    local value = Random.float(sum)
    sum = 0
    for i = 1, length do
        sum = sum + math.max(0, chances[i])
        if value <= sum then
            return i
        end
    end
    return -1
end

---Get random float number
---@param min? number
---@param max? number
---@param use_stack? boolean
---@return number
function Random.float(min, max, use_stack)
    local rng = generators[1] --[[@as love.RandomGenerator]]
    if use_stack == nil or use_stack then
        rng = generators[#generators]
    end
---@diagnostic disable-next-line: param-type-mismatch
    return rng:random(min, max)
end

---Get random normal distributed float number
---@param min? number
---@param max? number
---@param use_stack? boolean
---@return number
function Random.normalFloat(min, max, use_stack)
    local rng = generators[1] --[[@as love.RandomGenerator]]
    if use_stack == nil or use_stack then
        rng = generators[#generators]
    end
    if not min then
        min = 0.0
    end
    if not max then
        max = 1.0
    end

    return rng:randomNormal() * (max-min) + min
end

---Get random integer
---@param min? integer
---@param max? integer
---@param use_stack? boolean
---@return integer
function Random.int(min, max, use_stack)
    local rng = generators[1] --[[@as love.RandomGenerator]]
    if use_stack == nil or use_stack then
        rng = generators[#generators]
    end
---@diagnostic disable-next-line: param-type-mismatch
    return math.floor(rng:random(min, max))
end

---Get random normal distributed integer 
---@param min integer
---@param max integer
---@param use_stack? boolean
---@return integer
function Random.normalInt(min, max, use_stack)
    local rng = generators[1] --[[@as love.RandomGenerator]]
    if use_stack == nil or use_stack then
        rng = generators[#generators]
    end
    return math.floor(rng:randomNormal() * (max-min) + min)
end

---Get an inverse triangulary distributed integer
---This makes results more likely as they get further from the middle of the range
---@param min integer
---@param max integer
---@param use_stack? boolean
function Random.invNormalInt(min, max, use_stack)
    local rng = generators[1] --[[@as love.RandomGenerator]]
    if use_stack == nil or use_stack then
        rng = generators[#generators]
    end
    
    local roll1 = Random.float()
    local roll2 = Random.float()
    if math.abs(roll1 - 0.5) >= math.abs(roll2 - 0.5) then
        return math.floor(min + (roll1 * (max - min + 1)))
    else
        return math.floor(min + (roll2 * (max - min + 1)))
    end
end

---Get a random index, given a array
---@param collection table
---@return integer
function Random.index(collection)
    return Random.int(#collection)
end

---Get one random element, given an array
---@param collection table<any>
---@return any
function Random.oneOf(collection)
    return collection[Random.index(collection)]
end

---Get random element up to max index, given an array. 
---If `max`not informed, use all array possibilities
---@param collection table<any>
---@param max? integer
---@return unknown
function Random.element(collection, max)
    if not max then
        max = #collection
    end
    return collection[Random.int(1, max)]
end

---Shuffle a given array IN PLACE
---@param arr table<any>
function Random.shuffle(arr)
    for i = 1, #arr do
        local j = Random.int(i, #arr)
        if j ~= i then
            local t = arr[i]
            arr[i] = arr[j]
            arr[j] = t
        end
    end
end

---Shuffle two arrays IN PLACE. 
---They must have same sizes!
---@param arr1 table<any>
---@param arr2 table<any>
function Random.shuffle2(arr1, arr2)
    for i = 1, #arr1 do
        local j = Random.int(i, #arr1)
        if j ~= i then
            local arr1t = arr1[i]
            arr1[i] = arr1[j]
            arr1[j] = arr1t

            local arr2t = arr2[i]
            arr2[i] = arr2[j]
            arr2[j] = arr2t
        end
    end
end

return Random