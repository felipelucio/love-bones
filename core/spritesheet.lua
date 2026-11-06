--  Load image with alpha color
---@param imagePath string
---@param transR integer
---@param transG integer
---@param transB integer
---@return love.Image
local function loadTransparent(imagePath, transR, transG, transB)
	local imageData = love.image.newImageData(imagePath)
	local function mapFunction(x, y, r, g, b, a)
		local _ = x
		local _ = y
		if r == transR and g == transG and b == transB then
			a = 0
		end
		return r, g, b, a
	end
	imageData:mapPixel(mapFunction)
	return love.graphics.newImage(imageData)
end

---Regular grid Spritesheet
---@class Spritesheet 
---@field private tile_w integer
---@field private tile_h integer
---@field private tilesheet love.Image
---@field private tiles table<love.Quad>
local Spritesheet = { class = "Spritesheet" }
Spritesheet.__index = Spritesheet

---Constructor
---@private
---@param tile_w integer
---@param tile_h integer
---@param tilesheet love.Image
---@return Spritesheet
function Spritesheet.new(tile_w, tile_h, tilesheet)
	local obj = setmetatable({
		tile_w = tile_w,
		tile_h = tile_h,
		tilesheet = tilesheet,
		tiles = {},
	}, Spritesheet)
	return obj
end

---Create Spritesheet based on an image
---@param imagepath string
---@param cols number
---@param rows number
---@param mask? Color
function Spritesheet.loadImage(imagepath, cols, rows, mask)
	local image
	if mask ~= nil then
		image = loadTransparent(imagepath, 1, 0, 1)
	else
		image = love.graphics.newImage(imagepath)
	end
	local imgW, imgH = image:getDimensions()
	local tsize_w = math.floor(imgW / cols)
    local tsize_h = math.floor(imgH / rows)
	local ts = Spritesheet.new(tsize_w, tsize_h, image)

	for y = 0, rows - 1 do
		for x = 0, cols - 1 do
			table.insert(ts.tiles, love.graphics.newQuad(x * tsize_w, y * tsize_h, tsize_w, tsize_h, image))
		end
	end
	return ts
end

---Create Spritesheet based on an image
---@param imagepath string
---@param frame_w integer
---@param frame_h integer
---@param mask? Color
function Spritesheet.loadImageSize(imagepath, frame_w, frame_h, mask)
	local image
	if mask ~= nil then
		image = loadTransparent(imagepath, 1, 0, 1)
	else
		image = love.graphics.newImage(imagepath)
	end
	local imgW, imgH = image:getDimensions()
	local cols = math.floor(imgW / frame_w)
    local rows = math.floor(imgH / frame_h)
	local ts = Spritesheet.new(frame_w, frame_h, image)
	for y = 0, rows - 1 do
		for x = 0, cols - 1 do
			table.insert(ts.tiles, love.graphics.newQuad(x * frame_w, y * frame_h, frame_w, frame_h, image))
		end
	end
	return ts
end

---Get a tile based on the internal id
---@param id integer
---@return love.Quad
function Spritesheet:get(id)
	local t = self.tiles[id]
	if not t then
		t = self.tiles[1]
	end
	return t
end

---Get the tile width
---@return integer
function Spritesheet:getTileWidth()
	return self.tile_w
end

---Get the tile height
---@return integer
function Spritesheet:getTileHeight()
	return self.tile_h
end

---Get the tile size
---@return integer, integer
function Spritesheet:getTileSize()
	return self.tile_w, self.tile_h
end

---Get the tilesheet texture
---@return love.Image
function Spritesheet:getTexture()
	return self.tilesheet
end

---Get the total number of tiles
---@return integer
function Spritesheet:getTileCount()
	return #self.tiles
end

return Spritesheet
