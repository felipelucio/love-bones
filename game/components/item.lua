---@enum ItemType
local ItemType = {
    RUBBLE = 0,
    -- Armors
    ARMOR_CHEST = 1,
    ARMOR_HELM = 2,
    ARMOR_HANDS = 3,
    ARMOR_LEGS = 4,
    ARMOR_SHOULDERS = 5,
    ARMOR_TRINKET = 6,
    ARMOR_RING = 7,
    -- Weapons
    WEAPON_SWORD = 20,
    WEAPON_2H_SWORD = 21,
    WEAPON_2H_AXE = 22,
    WEAPON_MACE = 23,
    WEAPON_2H_MACE = 24,
    WEAPON_WAND = 25,
    WEAPON_STAFF = 26,
    WEAPON_BOW = 27,
    WEAPON_THROW = 28,
    WEAPON_SHIELD = 29,
    WEAPON_CATALYST = 30,
    WEAPON_ARROW = 31,
    WEAPON_BOLT = 32,
    -- Consumables
    POTION = 50,
    FOOD = 51,
    RUNE = 52,
    -- Materials
    ORE = 70,
    PLANT = 71,
    WOOD = 72,
    LEATHER = 73,
    ROCK = 74,
    LIQUID = 75,
}

---@class Item
---@field parent Entity
---@field weight integer
---@field height integer
---@field type ItemType
local Item = {}
Item.__index = Item

Item.Type = ItemType

---Constructor
---@param parent Entity
---@return Item
function Item.new(parent)
    local o = setmetatable({
        parent = parent,
        weight = 0,
        height = 0,
        type = ItemType.RUBBLE,
    }, Item)
    return o
end

return Item