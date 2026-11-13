local GUI = require('gui.main').GetInstance()
local Point = require('core.point')
local World = require('game.world')
local Entity = require('game.entity')
local Animation = require('game.components.animation')
local Camera = require('game.camera')
local Spritesheet = require('core.spritesheet')
local Random = require('core.random')
local Tileset = require('core.tileset').getInstance()

--- SYSTEMS
local inputSystem = require('game.systems.input_system')
local updateAnimationSystem = require('game.systems.update_animation_system')
local drawAnimationSystem = require('game.systems.draw_animation_system')
local drawTilemapSystem = require('game.systems.draw_tilemap_system')
local cameraSystem = require('game.systems.camera_system')

--- ACTIONS
local EntityActionID = require('game.entity_action_id')
local MoveToAction = require('game.actions.move_to_action')
local MoveByAction = require('game.actions.move_by_action')

--- ACTION HANDLERS
local moveToHandler = require('game.systems.action_handlers.move_to_handler')
local moveByHandler = require('game.systems.action_handlers.move_by_handler')

---@class TestScene
---@field world World
---@field hero Entity
---@field tileset Tileset
local TestScene = {}
TestScene.__index = TestScene

function TestScene:init()
    local ts = Tileset:loadFile('assets/main_tileset.lua')
    if not ts then
        error()
    end
    self.tileset = ts

    -- Camera
    self.camera = Camera.new()
    love.logger:setCamera(self.camera)

    -- World
    self.world = World.new(self.tileset, self.camera)
    self.world:init(Point.new(200, 200, 24), 20)
    self.world:registerActionHandler(EntityActionID.MOVE_TO, moveToHandler)
    self.world:registerActionHandler(EntityActionID.MOVE_BY, moveByHandler)

    -- Hero
    local spritesheet = Spritesheet.loadImageSize("assets/sprites/warrior.png", 16, 16)
    self.hero = Entity.new()
    self.hero.is_player = true
    self.hero.position = Point.new(1, 1, 1)
    self.hero.animation = Animation.new(self.hero, spritesheet, { idle = { frames = {1, 2}}}, 4)
    self.world.hero = self.hero
    self.world:addEntity(self.hero)
    self.camera:setFollow(self.hero)
    love.logger:setPlayer(self.hero)

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

    local p = Point.new(0, 0, 0)
    for z = 1, 2 do
        for y = 1, 200 do
            for x = 1, 200 do
                p.x = x
                p.y = y
                p.z = z
                self.world:setCellTile(p, love.math.random(1, 5))
            end
        end
    end
end

function TestScene:update(dt)
    local entities = {}
    for _, e in pairs(self.world.entities) do
        table.insert(entities, e)
    end
    inputSystem(self.world, entities)

    self.world:processActionQueue(EntityActionID.MOVE_TO)
    self.world:processActionQueue(EntityActionID.MOVE_BY)

    updateAnimationSystem(self.world, entities, dt)
    cameraSystem(self.world, {}, dt)

    -- aiSystem(self.world, entities)
    -- moveSystem(self.world, entities)
    -- attackSystem(self.world, entities)

    -- animationSystem(self.world, entities)
    -- clockSystem(self.world)
    -- itemDecaySystem(self.world, entities)
    -- weatherSystem(self.world, entities)
    -- respawnSystem(self.world, entities)
    
    -- cameraSystem(self.world)

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
    self.world:updateChunks(dt)
    GUI:update(dt)
end

function TestScene:draw()
    -- Draw the map
    drawTilemapSystem(self.world, self.tileset)

    local entities = {}
    for _, e in pairs(self.world.entities) do
        table.insert(entities, e)
    end
    drawAnimationSystem(self.world, entities)
    GUI:draw()
end

function TestScene:keypressed(key, scancode, isrepeat)
    GUI:keypressed(key, scancode, isrepeat)
end
function TestScene:textinput(text)
    GUI:textinput(text)
end
function TestScene:mousepressed(x, y, button, istouch, presses)
    GUI:mousepressed(x, y, button, istouch, presses)
end
function TestScene:mousereleased(x, y, button, istouch, presses)
    GUI:mousereleased(x, y, button, istouch, presses)
end
function TestScene:mousemoved(x, y, dx, dy, istouch)
    GUI:mousemoved(x, y, dx, dy, istouch)
end
function TestScene:wheelmoved(dx, dy)
    GUI:wheelmoved(dx, dy)
end
function TestScene:joystickhat(joystick, hat, direction)
    GUI:joystickhat(joystick, hat, direction)
end
function TestScene:joystickpressed(joystick, button)
    GUI:joystickpressed(joystick, button)
end
function TestScene:resize(w, h)
    GUI:resize(w, h)
end

return TestScene