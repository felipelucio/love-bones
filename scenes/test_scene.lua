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

--- ACTIONS
local MoveToAction = require('game.actions.move_to_action')

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

    local dest = self.hero.position:copy()
    if Input:isPressed("move_n") then
        dest.y = dest.y - 1

    elseif Input:isPressed("move_s") then
        dest.y = dest.y + 1
    end

    if Input:isPressed("move_w") then
        dest.x = dest.x - 1
    elseif Input:isPressed("move_e") then
        dest.x = dest.x + 1
    end

    if Input:isPressed("move_up") then
        dest.z = dest.z - 1
    elseif Input:isPressed("move_down") then
        dest.z = dest.z + 1
    end

    if self.hero.position ~= dest then
        self.world:queueAction(MoveToAction.new(self.hero, self.world:nextTick(0), dest))
    end

    for _, row in ipairs(self.world.chunks) do
        for _, chunk in ipairs(row) do
            if chunk.active then
                for _, e in pairs(chunk.entities) do
                    if e.animation ~= nil and e.id ~= self.hero.id then
                        local dest = e.position:copy()
                        if Random.int(1, 10) > 8 then
                            if Random.int(1, 2) == 1 then
                                if dest.x + 1 < 100 then
                                    dest.x = dest.x + 1
                                end
                            else
                                if dest.x - 1 > 1 then
                                    dest.x = dest.x - 1
                                end
                            end
                        end
                        if Random.int(1, 10) > 8 then
                            if Random.int(1, 2) == 1 then
                                if dest.y + 1 < 100 then
                                    dest.y = dest.y + 1
                                end
                            else
                                if dest.y - 1 > 1 then
                                    dest.y = dest.y - 1
                                end
                            end
                        end
                        if dest ~= e.position then
                            self.world:queueAction(MoveToAction.new(e, self.world:nextTick(0), dest))
                        end
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