local inspect = require('libs.inspect_lua.inspect')

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

---Variable sized sprite sheet
---@class Spritesheet 
---@field private texture love.Image
---@field private frames table<love.Quad>
local Spritesheet = { class = "Spritesheet" }
Spritesheet.__index = Spritesheet

---Constructor
---@param texture_path string
---@param frames_rects table<Rect>
---@param mask? Color
---@return Spritesheet
function Spritesheet.new(texture_path, frames_rects, mask)
	local image
	if mask ~= nil then
		image = loadTransparent(texture_path, 1, 0, 1)
	else
		image = love.graphics.newImage(texture_path)
	end

	local frames = {}
	for _, r in ipairs(frames_rects) do
		local quad = love.graphics.newQuad(r.x, r.y, r.w, r.h, image)
		table.insert(frames, quad)
	end

	local obj = setmetatable({
		texture_path = texture_path,
		texture = image,
		frames = frames,
	}, Spritesheet)
	return obj
end


---Get a frame based on the internal id
---@param id integer
---@return love.Quad
function Spritesheet:get(id)
	local t = self.frames[id]
	if not t then
		t = self.frames[1]
	end
	return t
end

---Get the spritesheet texture
---@return love.Image
function Spritesheet:getTexture()
	return self.texture
end

---Get the total number of frames
---@return integer
function Spritesheet:getFramesCount()
	return #self.frames
end

return Spritesheet
