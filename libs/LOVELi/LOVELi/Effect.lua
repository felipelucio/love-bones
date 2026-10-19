-- MIT License
-- 
-- Copyright (c) 2026 mtanksl
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

LOVELi.Effect = {}
LOVELi.Effect.__index = LOVELi.Effect
function LOVELi.Effect:new() -- LOVELi.Effect LOVELi.Effect:new()
	local o = {}
	setmetatable(o, self)
	return o
end
function LOVELi.Effect:update(dt) -- virtual
end
function LOVELi.Effect:apply(x, y, width, height) -- virtual
end
function LOVELi.Effect:clear() -- virtual
end
function LOVELi.Effect:type()
	return "Effect"
end

-- MIT License
-- 
-- Copyright (c) 2026 mtanksl
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

LOVELi.AlphaPulseEffect = {}
LOVELi.AlphaPulseEffect.__index = LOVELi.AlphaPulseEffect
setmetatable(LOVELi.AlphaPulseEffect, LOVELi.Effect)
function LOVELi.AlphaPulseEffect:new(minimumalpha, maximumalpha, interval) -- LOVELi.AlphaPulseEffect LOVELi.AlphaPulseEffect:new(float minimumalpha, float maximumalpha, float interval)
	local o = LOVELi.Effect.new(self)
	o.minimumalpha = minimumalpha
	o.maximumalpha = maximumalpha
	o.interval = interval -- in seconds
	o.alpha = 0 -- private
	return o
end
function LOVELi.AlphaPulseEffect:getminimumalpha()
	return self.minimumalpha
end
function LOVELi.AlphaPulseEffect:getmaximumalpha()
	return self.maximumalpha
end
function LOVELi.AlphaPulseEffect:getinterval()
	return self.interval
end
function LOVELi.AlphaPulseEffect:update(dt) -- override
	self.alpha = ( (self.maximumalpha + self.minimumalpha) + (self.maximumalpha - self.minimumalpha) * math.sin(2 * math.pi / self.interval * love.timer.getTime() ) ) / 2
end
function LOVELi.AlphaPulseEffect:apply(x, y, width, height) -- override
	self.r, self.g, self.b, self.a = love.graphics.getColor()	
	love.graphics.setColor(self.r * self.alpha, self.g * self.alpha, self.b * self.alpha, self.alpha)
end
function LOVELi.AlphaPulseEffect:clear() -- override
	love.graphics.setColor(self.r, self.g, self.b, self.a)
end
function LOVELi.AlphaPulseEffect:type()
	return "AlphaPulseEffect"
end

-- MIT License
-- 
-- Copyright (c) 2026 mtanksl
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

LOVELi.HueShiftEffect = {}
LOVELi.HueShiftEffect.__index = LOVELi.HueShiftEffect
setmetatable(LOVELi.HueShiftEffect, LOVELi.Effect)
function LOVELi.HueShiftEffect:new(interval) -- LOVELi.HueShiftEffect LOVELi.HueShiftEffect:new(float interval)
	local o = LOVELi.Effect.new(self)
	o.interval = interval -- in seconds
	o.red = 0 -- private	
	o.green = 0 -- private
	o.blue = 0 -- private
	return o
end
function LOVELi.HueShiftEffect:getinterval()
	return self.interval
end
function LOVELi.HueShiftEffect:update(dt) -- override
	self.red = (math.sin(2 * math.pi / self.interval * love.timer.getTime() ) + 1) / 2
	self.green = (math.sin(2 * math.pi / self.interval * love.timer.getTime() + 2.1) + 1 / 2) -- 2.1 = 2π/3
	self.blue = (math.sin(2 * math.pi / self.interval * love.timer.getTime() + 4.2) + 1) / 2 -- 4.2 = 4π/3
end
function LOVELi.HueShiftEffect:apply(x, y, width, height) -- override
	self.r, self.g, self.b, self.a = love.graphics.getColor()	
	love.graphics.setColor(self.r * self.red, self.g * self.green, self.b * self.blue, self.a)
end
function LOVELi.HueShiftEffect:clear() -- override
	love.graphics.setColor(self.r, self.g, self.b, self.a)
end
function LOVELi.HueShiftEffect:type()
	return "HueShiftEffect"
end

-- MIT License
-- 
-- Copyright (c) 2026 mtanksl
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

LOVELi.ScalePulseEffect = {}
LOVELi.ScalePulseEffect.__index = LOVELi.ScalePulseEffect
setmetatable(LOVELi.ScalePulseEffect, LOVELi.Effect)
function LOVELi.ScalePulseEffect:new(minimumscale, maximumscale, interval) -- LOVELi.ScalePulseEffect LOVELi.ScalePulseEffect:new(float minimumscale, float maximumscale, float interval)
	local o = LOVELi.Effect.new(self)
	o.minimumscale = minimumscale
	o.maximumscale = maximumscale
	o.interval = interval -- in seconds
	o.scale = 0 -- private
	return o
end
function LOVELi.ScalePulseEffect:getminimumscale()
	return self.minimumscale
end
function LOVELi.ScalePulseEffect:getmaximumscale()
	return self.maximumscale
end
function LOVELi.ScalePulseEffect:getinterval()
	return self.interval
end
function LOVELi.ScalePulseEffect:update(dt) -- override
	self.scale = ( (self.maximumscale + self.minimumscale) + (self.maximumscale - self.minimumscale) * math.sin(2 * math.pi / self.interval * love.timer.getTime() ) ) / 2
end
function LOVELi.ScalePulseEffect:apply(x, y, width, height) -- override
	love.graphics.push()
	love.graphics.translate(x + width / 2, y + height / 2)
	love.graphics.scale(self.scale, self.scale)
	love.graphics.translate(-(x + width / 2), -(y + height / 2) )
end
function LOVELi.ScalePulseEffect:clear() -- override
	love.graphics.pop()
end
function LOVELi.ScalePulseEffect:type()
	return "ScalePulseEffect"
end

-- MIT License
-- 
-- Copyright (c) 2026 mtanksl
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

LOVELi.RotateEffect = {}
LOVELi.RotateEffect.__index = LOVELi.RotateEffect
setmetatable(LOVELi.RotateEffect, LOVELi.Effect)
function LOVELi.RotateEffect:new(minimumangle, maximumangle, interval) -- LOVELi.RotateEffect LOVELi.RotateEffect:new(float minimumangle, float maximumangle, float interval)
	local o = LOVELi.Effect.new(self)
	o.minimumangle = minimumangle -- in radians
	o.maximumangle = maximumangle -- in radians
	o.interval = interval -- in seconds
	o.angle = 0 -- private
	return o
end
function LOVELi.RotateEffect:getminimumangle()
	return self.minimumangle
end
function LOVELi.RotateEffect:getmaximumangle()
	return self.maximumangle
end
function LOVELi.RotateEffect:getinterval()
	return self.interval
end
function LOVELi.RotateEffect:update(dt) -- override
	self.angle = ( (self.maximumangle + self.minimumangle) + (self.maximumangle - self.minimumangle) * math.sin(2 * math.pi / self.interval * love.timer.getTime() ) ) / 2
end
function LOVELi.RotateEffect:apply(x, y, width, height) -- override
	love.graphics.push()
	love.graphics.translate(x + width / 2, y + height / 2)
	love.graphics.rotate(self.angle)
	love.graphics.translate(-(x + width / 2), -(y + height / 2) )
end
function LOVELi.RotateEffect:clear() -- override
	love.graphics.pop()
end
function LOVELi.RotateEffect:type()
	return "RotateEffect"
end

-- MIT License
-- 
-- Copyright (c) 2026 mtanksl
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

LOVELi.ShakeEffect = {}
LOVELi.ShakeEffect.__index = LOVELi.ShakeEffect
setmetatable(LOVELi.ShakeEffect, LOVELi.Effect)
function LOVELi.ShakeEffect:new(amplitude, intensity) -- LOVELi.ShakeEffect LOVELi.ShakeEffect:new(float amplitude, float intensity)
	local o = LOVELi.Effect.new(self)
	o.amplitude = amplitude
	o.intensity = intensity
	o.offsetx = 0 -- private
	o.offsety = 0 -- private
	return o
end
function LOVELi.ShakeEffect:getamplitude()
	return self.amplitude
end
function LOVELi.ShakeEffect:getintensity()
	return self.intensity
end
function LOVELi.ShakeEffect:update(dt) -- override
	local time = self.intensity * love.timer.getTime()
	self.offsetx = self.amplitude * (love.math.noise(time) * 2 - 1)
	self.offsety = self.amplitude * (love.math.noise(time + 10) * 2 - 1)
end
function LOVELi.ShakeEffect:apply(x, y, width, height) -- override
	love.graphics.push()
	love.graphics.translate(self.offsetx, self.offsety)
end
function LOVELi.ShakeEffect:clear() -- override
	love.graphics.pop()
end
function LOVELi.ShakeEffect:type()
	return "ShakeEffect"
end

-- MIT License
-- 
-- Copyright (c) 2026 mtanksl
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

LOVELi.InvertColorShaderEffect = {}
LOVELi.InvertColorShaderEffect.__index = LOVELi.InvertColorShaderEffect
setmetatable(LOVELi.InvertColorShaderEffect, LOVELi.Effect)
function LOVELi.InvertColorShaderEffect:new() -- LOVELi.InvertColorShaderEffect LOVELi.InvertColorShaderEffect:new()
	local o = LOVELi.Effect.new(self)
	o.shader = love.graphics.newShader([[
		vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) { 
			vec4 texcolor = Texel(texture, texture_coords); 
			return vec4(1 - texcolor.r, 1 - texcolor.g, 1 - texcolor.b, texcolor.a) * color; 
		}
	]]) -- private
	return o
end
function LOVELi.InvertColorShaderEffect:apply(x, y, width, height) -- override
	self.sh = love.graphics.getShader()
	love.graphics.setShader(self.shader)
end
function LOVELi.InvertColorShaderEffect:clear() -- override
	love.graphics.setShader(self.sh)
end
function LOVELi.InvertColorShaderEffect:type()
	return "InvertColorShaderEffect"
end