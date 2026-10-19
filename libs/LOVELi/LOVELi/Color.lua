-- MIT License
-- 
-- Copyright (c) 2025 mtanksl
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell		
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

LOVELi.Color = {
	basecolors = {
		["red"] = { red = 1, green = 0, blue = 0, alpha = 1 },
		["green"] = { red = 0, green = 1, blue = 0, alpha = 1 },
		["blue"] = { red = 0, green = 0, blue = 1, alpha = 1 },
		["cyan"] = { red = 0, green = 1, blue = 1, alpha = 1 },
		["magenta"] = { red = 1, green = 0, blue = 1, alpha = 1 },
		["yellow"] = { red = 1, green = 1, blue = 0, alpha = 1 },
		["grey"] = { red = 0.5, green = 0.5, blue = 0.5, alpha = 1 },
		["gray"] = { red = 0.5, green = 0.5, blue = 0.5, alpha = 1 },
		["white"] = { red = 1, green = 1, blue = 1, alpha = 1 },
		["black"] = { red = 0, green = 0, blue = 0, alpha = 1 },
		["transparent"] = { red = 0, green = 0, blue = 0, alpha = 0 }
	}
}
LOVELi.Color.__index = LOVELi.Color
function LOVELi.Color:new(red, green, blue, alpha) -- LOVELi.Color LOVELi.Color:new(float red = 0, float green = 0, float blue = 0, float alpha = 1)
	local o = { 
		red = red or 0, 
		green = green or 0, 
		blue = blue or 0, 
		alpha = alpha or 1
	}	
	setmetatable(o, self)
	return o
end
function LOVELi.Color:getred()
	return self.red
end
function LOVELi.Color:getgreen()
	return self.green
end
function LOVELi.Color:getblue()
	return self.blue
end
function LOVELi.Color:getalpha()
	return self.alpha
end
function LOVELi.Color:getrgba()
	return self.red, self.green, self.blue, self.alpha
end	
function LOVELi.Color:type()
	return "Color"
end
function LOVELi.Color.parse(value) -- static
	local red = nil
	local green = nil
	local blue = nil
	local alpha = nil
	if type(value) == "number" then
		red = (math.floor(value / 16777216) % 256) / 255
		green = (math.floor(value / 65536) % 256) / 255
		blue = (math.floor(value / 256) % 256) / 255 
		alpha = (value % 256) / 255
	elseif type(value) == "string" then
		if value:sub(1, 1) == "#" then
			value = value:sub(2)
			if #value == 3 then 
				-- #RGB
				value = value:sub(1, 1):rep(2) .. value:sub(2, 2):rep(2) .. value:sub(3, 3):rep(2) .. "FF"
			elseif #value == 4 then 
				-- #RGBA
				value = value:sub(1, 1):rep(2) .. value:sub(2, 2):rep(2) .. value:sub(3, 3):rep(2) .. value:sub(4, 4):rep(2)
			elseif #value == 6 then
				-- #RRGGBB
				value = value .. "FF"
			end
			if #value == 8 then
				-- #RRGGBBAA
				red = tonumber(value:sub(1, 2), 16) / 255
				green = tonumber(value:sub(3, 4), 16) / 255
				blue = tonumber(value:sub(5, 6), 16) / 255
				alpha = tonumber(value:sub(7, 8), 16) / 255
			end
		else
			local basecolor = LOVELi.Color.basecolors[value:lower()]
			if basecolor then 
				red = basecolor.red
				green = basecolor.green
				blue = basecolor.blue
				alpha = basecolor.alpha
			end
		end
	elseif type(value) == "table" then
		red = value.red
		green = value.green
		blue = value.blue
		alpha = value.alpha	
	end
	return LOVELi.Color:new(red, green, blue, alpha)
end
