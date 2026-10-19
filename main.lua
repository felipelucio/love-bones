local Log = require("core.log").Log
local LogOpt = require("core.log").LogOptions
local log_conf = LogOpt.default()
log_conf.canvas.mem_size = "k"
love.logger = Log.new(log_conf)

local World = require('game.world')
local Point = require('core.point')

function love.load()
    local w = World.new()
    w:init(Point.new(100, 100, 12), 10)
    local cell = w:getCell(Point.new(1, 1, 1))
    print(cell)
end