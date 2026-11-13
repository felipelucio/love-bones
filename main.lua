local constants = require('constants')
local Log = require("core.log").Log
local LogOpt = require("core.log").LogOptions
local log_conf = LogOpt.default()
table.insert(log_conf.drivers, "console")
log_conf.canvas.mem_size = "k"
log_conf.canvas.show_camera = true
log_conf.canvas.show_player = true
love.logger = Log.new(log_conf)

local Render = require('core.render').getInstance()
local GameState = require('libs.hump.gamestate')

local Input = require('core.input').getInstance()
Input:registerAction("move_n", {"w"})
Input:registerAction("move_s", {"s"})
Input:registerAction("move_e", {"d"})
Input:registerAction("move_w", {"a"})
Input:registerAction("move_up", {"up"})
Input:registerAction("move_down", {"down"})
Input:registerAction("toggle_debug", {"lshift", "f12"}, {"rshift", "f12"})

local show_debug = true

function love.load()
    love.window.setMode(1280, 720)
    Render:setInternalResolution(constants.INTERNAL_RES_W, constants.INTERNAL_RES_H)
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    local TestScene = require('scenes.test_scene')
    GameState.switch(TestScene)
    --GameState.registerEvents()
end

function love.update(dt)
    GameState.update(dt)
    love.window.setTitle(string.format("FPS: %d", love.timer.getFPS()))
    if Input:isPressed("toggle_debug") then
        show_debug = not show_debug
    end
end

function love.draw()
    GameState.draw()
    if show_debug then
        love.logger:draw()
    end
end

function love.keypressed(key, scancode, isrepeat)
    GameState.keypressed(key, scancode, isrepeat)
end
function love.textinput(text)
    GameState.textinput(text)
end
function love.mousepressed(x, y, button, istouch, presses)
    GameState.mousepressed(x, y, button, istouch, presses)
end
function love.mousereleased(x, y, button, istouch, presses)
    GameState.mousereleased(x, y, button, istouch, presses)
end
function love.mousemoved(x, y, dx, dy, istouch)
    GameState.mousemoved(x, y, dx, dy, istouch)
end
function love.wheelmoved(dx, dy)
    GameState.wheelmoved(dx, dy)
end
function love.joystickhat(joystick, hat, direction)
    GameState.joystickhat(joystick, hat, direction)
end
function love.joystickpressed(joystick, button)
    GameState.joystickpressed(joystick, button)
end
function love.resize(w, h)
    GameState.resize(w, h)
end