local Flux = require('libs.flux.flux')
local Render = require('core.render').getInstance()
local Point = require('core.point')
local World = require('game.world')
local Entity = require('game.entity')
local Animation = require('game.components.animation')
local Camera = require('game.camera')
local Input = require('core.input').getInstance()
local Spritesheet = require('core.spritesheet')
local Rect = require('core.rect')
local Random = require('core.random')

---@class TestScene
---@field world World
---@field camera Camera
---@field hero Entity
local TestScene = {}
TestScene.__index = TestScene

function TestScene:init()
    self.world = World.new()
    self.world:init(Point.new(100, 100, 24), 20)
    local spritesheet = Spritesheet.new("assets/sprites/warrior.png", {Rect.new(0, 0, 16, 16), Rect.new(16, 16, 16, 16)})
    self.hero = Entity.new()
    self.hero.position = Point.new(1, 1, 1)
    self.hero.animation = Animation.new(self.hero, spritesheet, { idle = { frames = {1, 2}}}, 4)
    self.world:addEntity(self.hero)
    local tW, tH = Render:getSizeTiles()
    self.camera = Camera.new(Point.new(tW, tH, 1))
    self.camera:setFollow(self.hero)

    for i = 1, 100 do
        local enem = Entity.new()
        enem.position.x = Random.int(1, 100)
        enem.position.y = Random.int(1, 100)
        enem.position.z = 1
        enem.animation = Animation.new(enem, spritesheet, { idle = { frames = {1, 2}}}, 4)
        self.world:addEntity(enem)
    end

    for i = 1, 10000 do
        local enem = Entity.new()
        enem.position.x = Random.int(1, 100)
        enem.position.y = Random.int(1, 100)
        enem.position.z = 1
        -- enem.animation = Animation.new(enem, spritesheet, { idle = { frames = {1, 2}}}, 4)
        self.world:addEntity(enem)
    end
end

function TestScene:update(dt)
    Flux.update(dt)

    if Input:isPressed("move_n") then
        self.hero.position.y = self.hero.position.y - 1
    elseif Input:isPressed("move_s") then
        self.hero.position.y = self.hero.position.y + 1
    end

    if Input:isPressed("move_w") then
        self.hero.position.x = self.hero.position.x - 1
    elseif Input:isPressed("move_e") then
        self.hero.position.x = self.hero.position.x + 1
    end

    if Input:isPressed("move_up") then
        self.hero.position.z = self.hero.position.z - 1
    elseif Input:isPressed("move_down") then
        self.hero.position.z = self.hero.position.z + 1
    end

    local chunk = self.world:getChunk(self.hero.position)
    for _, e in ipairs(chunk.entities) do
        if e.animation ~= nil then
            if Random.int(1, 10) > 8 then
                if Random.int(1, 2) == 1 then
                    if e.position.x + 1 < 100 then
                        e.position.x = e.position.x + 1
                    end
                else
                    if e.position.x - 1 > 1 then
                        e.position.x = e.position.x - 1
                    end
                end
            end
            if Random.int(1, 10) > 8 then
                if Random.int(1, 2) == 1 then
                    if e.position.y + 1 < 100 then
                        e.position.y = e.position.y + 1
                    end
                else
                    if e.position.y - 1 > 1 then
                        e.position.y = e.position.y - 1
                    end
                end
            end
        end
    end
    
    self.camera:update(dt)
    self.world:update(dt)
end

function TestScene:draw()
    local cam_text = ("Camera: (%d, %d, %d)"):format(self.camera.position.x, self.camera.position.y, self.camera.position.z)
    love.graphics.printf(cam_text, 10, 100, 200)
    local hero_text = ("Hero: (%d, %d, %d)"):format(self.hero.position.x, self.hero.position.y, self.hero.position.z)
    love.graphics.printf(hero_text, 10, 120, 200)

    self.world:draw()
end

return TestScene