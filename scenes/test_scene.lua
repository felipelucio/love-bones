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

---@class TestScene
---@field world World
---@field hero Entity
---@field tileset Tileset
local TestScene = {}
TestScene.__index = TestScene

---Handle Entity Actions
---@param world World
---@param action EntityAction
function ActionHandler(world, action)
    if action.action_id == EntityActionID.MOVE_TO then
        
    elseif action.action_id == EntityActionID.MOVE_BY then
        
    else
        love.logger:error(("[World:processEntityAction] EntityAction #%d is not defined"):format(action.action_id))
    end
end

function TestScene:init()
    local ts = Tileset:loadFile('assets/main_tileset.lua')
    if not ts then
        error()
    end
    self.tileset = ts
    
    -- Camera
    local win_w, win_h = love.window.getDesktopDimensions()
    --local win_w, win_h = Render.internal_resolution_width, Render.internal_resolution_height
    self.camera = Camera.new()
    love.logger:setCamera(self.camera)

    -- World
    self.world = World.new(self.tileset, self.camera)
    self.world:init(Point.new(200, 200, 24), 20)
    self.world:registerActionHandler(EntityActionID.MOVE_TO, function (world, action)
        action = action --[[@as MoveByAction]]
        local ent = world:getEntity(action.entity_id)
        if ent then
            ent.position.x = action.dest.x
            ent.position.y = action.dest.y
            ent.position.z = action.dest.z
        end
    end)
    self.world:registerActionHandler(EntityActionID.MOVE_BY, function (world, action)
        action = action --[[@as MoveByAction]]
        local ent = world:getEntity(action.entity_id)
        if ent then
            ent.position.x = ent.position.x + action.dest.x
            ent.position.y = ent.position.y + action.dest.y
            ent.position.z = ent.position.z + action.dest.z
        end
    end)

    -- Hero
    local spritesheet = Spritesheet.loadImageSize("assets/sprites/warrior.png", 16, 16)
    self.hero = Entity.new()
    self.hero.is_player = true
    self.hero.position = Point.new(1, 1, 1)
    self.hero.animation = Animation.new(self.hero, spritesheet, { idle = { frames = {1, 2}}}, 4)
    self.world.hero = self.hero
    self.world:addEntity(self.hero)
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

    updateAnimationSystem(self.world, entities)
    cameraSystem(self.world, {})

    -- aiSystem(self.world, entities)
    -- moveSystem(self.world, entities)
    -- attackSystem(self.world, entities)

    Flux.update(dt)
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
end

function TestScene:draw()
    -- local cam_text = ("Camera: (%d, %d, %d)"):format(self.camera.position.x, self.camera.position.y, self.camera.position.z)
    -- love.graphics.printf(cam_text, 10, 100, 200)
    -- local hero_text = ("Hero: (%d, %d, %d)"):format(self.hero.position.x, self.hero.position.y, self.hero.position.z)
    -- love.graphics.printf(hero_text, 10, 120, 200)

	-- love.graphics.push()
    -- love.graphics.scale(Render.zoom_factor, Render.zoom_factor)

    -- Draw the map
    drawTilemapSystem(self.world, self.tileset)

    local entities = {}
    for _, e in pairs(self.world.entities) do
        table.insert(entities, e)
    end
    drawAnimationSystem(self.world, entities)
    -- self.world:draw()
    -- love.graphics.pop()
    
end

return TestScene