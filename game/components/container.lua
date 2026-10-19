---@class Container
---@field max_slots integer
---@field slots table<Item>
---@field weight integer
local Container = {}
Container.__index = Container

---Constructor
---@param parent Entity
---@param max_slots integer
---@return Container
function Container.new(parent, max_slots)
    local o = setmetatable({
        parent = parent,
        max_slots = max_slots,
        slots = {},
        weight = 0,
    }, Container)
    return o
end

---Set slot with item
---@param slot integer
---@param item Item
---@return boolean
function Container:setSlot(slot, item)
    if slot < 1 or slot > self.max_slots then
        love.logger:warn("Container:setSlot is out of bounds")
        return false
    end
    if self.slots[slot] ~= nil then
        love.logger:warn(("Container:setSlot: slot '%s' is already holding item"):format(slot))
        return false
    end
    self.slots[slot] = item
    self:calcWeight()
    return true
end

---Get the item from a given slot
---@param slot integer
---@return Item|nil
function Container:getSlot(slot)
    if slot < 1 or slot > self.max_slots then
        love.logger:warn("Container:getSlot is out of bounds")
        return
    end
    return self.slots[slot]
end

---Remove item from a given slot
---@param slot integer
---@return Item|nil
function Container:removeSlot(slot)
    if slot < 1 or slot > self.max_slots then
        love.logger:warn("Container:removeSlot is out of bounds")
        return
    end
    local item = self.slots[slot]
    self.slots[slot] = nil
    return item
end

---Try to hold item, if there is available slot. 
---If has been hold, returns the slot number.
---If there is no space, returns -1
---@param item Item
---@return integer
function Container:holdIfPossible(item)
    for i = 1, self.max_slots do
        if self.slots[i] == nil then
            self.slots[i] = item
            return i
        end
    end
    return -1
end

---Calculate the weight of the container
---@private
function Container:calcWeight()
    local w = 0
    for _, i in ipairs(self.slots) do
        if i ~= nil then
            w = w + i.weight
        end
    end
    self.weight = w
end

return Container