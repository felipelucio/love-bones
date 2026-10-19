local Log = require("core.log").Log
local LogOpt = require("core.log").LogOptions
local log_conf = LogOpt.default()
table.insert(log_conf.drivers, "console")
log_conf.canvas.mem_size = "k"
love.logger = Log.new(log_conf)

local World = require('game.world')
local Point = require('core.point')
local Input = require('core.input').getInstance()

Input:registerAction("walk_n", {"w"})
Input:registerAction("walk_s", {"s"})
Input:registerAction("walk_e", {"d"})
Input:registerAction("walk_w", {"a"})

function love.load()
    local w = World.new()
    w:init(Point.new(100, 100, 12), 10)
    love.logger:info(("cam: (%d, %d, %d)"):format(w.camera.position.x, w.camera.position.y, w.camera.position.z))

    
end

function love.update(dt)
    if Input:justReleased("walk_n") then
        love.logger:info("north")
    end
end

function love.draw()
    love.logger:draw()
end