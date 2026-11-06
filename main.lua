local Log = require("core.log").Log
local LogOpt = require("core.log").LogOptions
local log_conf = LogOpt.default()
table.insert(log_conf.drivers, "console")
log_conf.canvas.mem_size = "k"
log_conf.canvas.show_camera = true
love.logger = Log.new(log_conf)

local GameState = require('libs.hump.gamestate')

local Input = require('core.input').getInstance()
Input:registerAction("move_n", {"w"})
Input:registerAction("move_s", {"s"})
Input:registerAction("move_e", {"d"})
Input:registerAction("move_w", {"a"})
Input:registerAction("move_up", {"up"})
Input:registerAction("move_down", {"down"})

local TestScene = require('scenes.test_scene')

function love.load()
    love.window.setMode(1280, 720)
    love.graphics.setDefaultFilter("nearest", "nearest")
    GameState.switch(TestScene)
    --GameState.registerEvents()
end

function love.update(dt)
    GameState.update(dt)
end

function love.draw()
    GameState.draw()
    love.logger:draw()
end