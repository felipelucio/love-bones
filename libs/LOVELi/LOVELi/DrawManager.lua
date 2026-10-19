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

LOVELi.DrawManager = {}
LOVELi.DrawManager.__index = LOVELi.DrawManager
function LOVELi.DrawManager:new(options) -- LOVELi.DrawManager LOVELi.DrawManager:new( { LOVELi.Effect[] focusedeffects, LOVELi.Effect[] unfocusedeffects } options)
	local o = {
		focusedeffects = LOVELi.Property.parse(options.focusedeffects, {} ),
		unfocusedeffects = LOVELi.Property.parse(options.unfocusedeffects, {} )
	}
	setmetatable(o, self)
	return o
end
function LOVELi.DrawManager:getfocusedeffects()
	return self.focusedeffects:getvalue()
end
function LOVELi.DrawManager:getunfocusedeffects()
	return self.unfocusedeffects:getvalue()
end
function LOVELi.DrawManager:update(dt) -- virtual
	for _, focusedeffect in ipairs(self:getfocusedeffects() ) do
		focusedeffect:update(dt)
	end
	for _, unfocusedeffect in ipairs(self:getunfocusedeffects() ) do
		unfocusedeffect:update(dt)
	end
end
function LOVELi.DrawManager:draw(controls, focusedcontrol) -- virtual
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(1, 1, 1, 1)
	local mode, alphamode = love.graphics.getBlendMode()
	love.graphics.setBlendMode("alpha", "premultiplied")
	local focusedeffects = self:getfocusedeffects()
	local unfocusedeffects = self:getunfocusedeffects()
	for _, control in ipairs(controls) do
		local canvas = control:getcanvas()
		if canvas then	
			local x = math.floor(control:getrenderx() ) -- Snap to grid
			local y = math.floor(control:getrendery() )
			local width = control:getrenderwidth()
			local height = control:getrenderheight()
			if control == focusedcontrol then				
				for i = 1, #focusedeffects do
					focusedeffects[i]:apply(x, y, width, height)
				end
				love.graphics.draw(canvas, x, y)
				for i = #focusedeffects, 1, -1 do
					focusedeffects[i]:clear()
				end
			else				
				if control:getisfocusable() then
					for i = 1, #unfocusedeffects do
						unfocusedeffects[i]:apply(x, y, width, height)
					end
					love.graphics.draw(canvas, x, y)
					for i = #unfocusedeffects, 1, -1 do
						unfocusedeffects[i]:clear()
					end
				else 
					love.graphics.draw(canvas, x, y)
				end
			end			
		end
	end
	love.graphics.setBlendMode(mode, alphamode)
	love.graphics.setColor(r, g, b, a)
end
function LOVELi.DrawManager:type()
	return "DrawManager"
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

LOVELi.FocusedBorderDrawManager = {}
LOVELi.FocusedBorderDrawManager.__index = LOVELi.FocusedBorderDrawManager
setmetatable(LOVELi.FocusedBorderDrawManager, LOVELi.DrawManager)
function LOVELi.FocusedBorderDrawManager:new(options) -- LOVELi.FocusedBorderDrawManager LOVELi.FocusedBorderDrawManager:new( { LOVELi.Color bordercolor, float linewidth, LOVELi.Effect[] focusedeffects, LOVELi.Effect[] unfocusedeffects } options)
	local o = LOVELi.DrawManager.new(self, options)
	o.bordercolor = LOVELi.Property.parse(options.bordercolor, LOVELi.Color.parse(0xFF0000FF) )
	o.linewidth = LOVELi.Property.parse(options.linewidth, 3)
	return o
end
function LOVELi.FocusedBorderDrawManager:getbordercolor()
	return self.bordercolor:getvalue()
end
function LOVELi.FocusedBorderDrawManager:getlinewidth()
	return self.linewidth:getvalue()
end
function LOVELi.FocusedBorderDrawManager:draw(controls, focusedcontrol) -- override
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(1, 1, 1, 1)
	local mode, alphamode = love.graphics.getBlendMode()
	love.graphics.setBlendMode("alpha", "premultiplied")
	local focusedeffects = self:getfocusedeffects()
	local unfocusedeffects = self:getunfocusedeffects()
	for _, control in ipairs(controls) do
		local canvas = control:getcanvas()
		if canvas then	
			local x = math.floor(control:getrenderx() ) -- Snap to grid
			local y = math.floor(control:getrendery() )
			local width = control:getrenderwidth()
			local height = control:getrenderheight()
			if control == focusedcontrol then				
				for i = 1, #focusedeffects do
					focusedeffects[i]:apply(x, y, width, height)
				end
				love.graphics.draw(canvas, x, y)
				for i = #focusedeffects, 1, -1 do
					focusedeffects[i]:clear()
				end
			else				
				for i = 1, #unfocusedeffects do
					unfocusedeffects[i]:apply(x, y, width, height)
				end
				love.graphics.draw(canvas, x, y)
				for i = #unfocusedeffects, 1, -1 do
					unfocusedeffects[i]:clear()
				end
			end			
		end
	end
	love.graphics.setBlendMode(mode, alphamode)
	love.graphics.setColor(r, g, b, a)	
	if focusedcontrol then
		local x = math.floor(focusedcontrol:getrenderx() ) -- Snap to grid
		local y = math.floor(focusedcontrol:getrendery() )
		local width = focusedcontrol:getrenderwidth()
		local height = focusedcontrol:getrenderheight()
		local r, g, b, a = love.graphics.getColor()
		love.graphics.setColor(self:getbordercolor():getrgba() )
		local lw = love.graphics.getLineWidth()
		love.graphics.setLineWidth(self:getlinewidth() )
			love.graphics.rectangle("line", x, y, width, height)
		love.graphics.setLineWidth(lw)
		love.graphics.setColor(r, g, b, a)
	end	
end
function LOVELi.FocusedBorderDrawManager:type()
	return "FocusedBorderDrawManager"
end