local constants = require('constants')
local AssetManager = require('core.asset_manager').getInstance()
local Spritesheet = require('core.spritesheet')
local Utils = require('core.utils')
local inspect = require('libs.inspect_lua.inspect')

---@class Tile
---@field id integer
---@field spritesheet string
---@field name string
---@field description string
---@field group string
---@field frames table<string, table<integer>>
---@field passable boolean
---@field transparent boolean
local Tile = {}
Tile.__index = Tile

---@class TileData
---@field id integer
---@field spritesheet string
---@field name string
---@field description string
---@field group string
---@field frames table<string, table<integer>>
---@field passable boolean
---@field transparent boolean

---Constructor
---@param spritesheet string
---@param id integer
---@param name string
---@param description string
---@param frames table<string, table<integer>>
---@param passable? boolean
---@param transparent? boolean
---@return Tile
function Tile.new(spritesheet, id, name, description, group, frames, passable, transparent)
	return setmetatable({
		id = id,
		spritesheet = spritesheet,
		name = name,
		description = description,
		group = group,
		frames = frames or {},
		passable = passable or false,
		transparent = transparent or false,
	}, Tile)
end

------------------------------------------------
-------        TILESET         -----------------
------------------------------------------------
local instance = nil

---@class Tileset 
---@field private spritesheets table<string, Spritesheet>
---@field tiles table<Tile>
---@field groups table<string, table<integer>>
local Tileset = { class = "Tileset" }
Tileset.__index = Tileset

---Get instance
---@return Tileset
function Tileset.getInstance()
	if not instance then
		instance = Tileset.new()
	end
	return instance
end

---Constructor
---@private
---@return Tileset
function Tileset.new()
	local obj = setmetatable({
		spritesheets = {},
		tiles = {},
		groups = {},
	}, Tileset)
	return obj
end

---Load tile from file
---@param tdata TileData
---@return boolean
function Tileset:loadTile(tdata)
	if not self.spritesheets[tdata.spritesheet] then
		self.spritesheets[tdata.spritesheet] = Spritesheet.loadImageSize(tdata.spritesheet, constants.TILE_SIZE, constants.TILE_SIZE)
	end
	local tile = Tile.new(tdata.spritesheet, tdata.id, tdata.name, tdata.description, tdata.group, tdata.frames, tdata.passable, tdata.transparent)
	if not self.groups[tdata.group] then
		self.groups[tdata.group] = {}
	end
	table.insert(self.groups[tdata.group], tile.id)
	table.insert(self.tiles, tile)
	return true
end

---Load file with TileData
---@param filename string
---@return Tileset|nil
function Tileset:loadFile(filename)
	local ok, data = Utils.runFile(filename)
	if not ok then
		love.logger:error(("[Tileset:loadFile] Unable to load '%s' file"):format(filename))
		return nil
	end

---@diagnostic disable-next-line: param-type-mismatch
	for _, tdata in ipairs(data) do
		self:loadTile(tdata)
	end
	return self
end

---Draw a tile
---@param tid integer
---@param x integer
---@param y integer
---@param state? string
---@param frame? integer
function Tileset:draw(tid, x, y, state, frame)
	state = state or 'default'
	frame = frame or 1
	local t = self.tiles[tid] --[[@as Tile]]
	local ss = self.spritesheets[t.spritesheet]
	local frs = t.frames[state]
	local f = ss:get(frs[frame])
	love.graphics.draw(ss:getTexture(), f, x, y)
end

return Tileset
