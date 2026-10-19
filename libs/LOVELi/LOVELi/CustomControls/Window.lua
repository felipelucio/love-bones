-- MIT License
-- 
-- Copyright (c) 2026 mtanksl, felipelucio
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

LOVELi.Window = {}
LOVELi.Window.__index = LOVELi.Window
setmetatable(LOVELi.Window, LOVELi.AbsoluteLayout)
function LOVELi.Window:new(options) -- LOVELi.Window LOVELi.Window:new( { string title, int x, int y, Union<"*", "auto", int> width, Union<"*", "auto", int> height, int minwidth, int maxwidth, int minheight, int maxheight, LOVELi.Color backgroundcolor, LOVELi.Color bordercolor, LOVELi.Thickness margin, string name, bool isvisible, LOVELi.Style style } options)
	local o = LOVELi.AbsoluteLayout.new(self, options)
    o.backgroundcolor = LOVELi.Property.parse(options.backgroundcolor, LOVELi.Color.parse(0xC0C0C0FF))
    o.bordercolor = LOVELi.Property.parse(options.bordercolor, LOVELi.Color.parse(0xFFFFFFFF))
    o._title = LOVELi.Grid:new{ rowdefinitions = { "auto" }, columndefinitions = { "1*", "5*", "1*" }, x = 0, y = 5, orientation = "horizontal", horizontaloptions = "center", width = "*", height = "40" }
    o._title:with(1, 2, LOVELi.Label:new{ text = o.title or "Window", horizontaloptions = "center" })
    o._title:with(1, 3, LOVELi.StackLayout:new{ orientation = "horizontal", width = "auto", height = "auto", horizontaloptions = "end", margin = LOVELi.Thickness.parse("5,0,5,0") }
        :with(LOVELi.Button:new{ text = "X", width = "auto", height = "auto", horizontaloptions = "end", clicked = function(sender) o:setisvisible(false) end })
    )
    o._content = LOVELi.StackLayout:new{ x = 0, y = 0, orientation = "horizontal", width = "auto", height = "auto" }
    o:with(o._title)
    o:with(LOVELi.ScrollView:new{ x = 5, y = 45, orientation = "both", verticalscrollbarincrement = 10, horizontalscrollbarincrement = 10, width = o:getwidth() - 20, height = o:getheight() - 65, margin = LOVELi.Thickness.parse(10) }
        :with(o._content)
    )
	return o
end

function LOVELi.Window:getbackgroundcolor()
	return self.backgroundcolor:getvalue()
end
function LOVELi.Window:setbackgroundcolor(value)
	self.backgroundcolor:setvalue(value)
end
function LOVELi.Window:getbordercolor()
	return self.bordercolor:getvalue()
end
function LOVELi.Window:setbordercolor(value)
	self.bordercolor:setvalue(value)
end

function LOVELi.Window:initoverride(layoutmanager) -- override
	local function onclicked()
		return
	end
	layoutmanager:subscribe("keypressed", self, function(key, scancode, isrepeat)
		if key == "space" or key == "return" or key == "kpenter" then
			onclicked()
		end
	end)
	layoutmanager:subscribe("mousepressed", self, function(x, y, button, istouch, presses)
		onclicked()
	end)
end

function LOVELi.Window:render(x, y)
    love.graphics.setColor(self:getbackgroundcolor():getrgba() )	
	love.graphics.rectangle(
		"fill", 
		x + self:getmargin():getleft(), 
		y + self:getmargin():gettop(), 
		self:getdesiredwidth(), 
		self:getdesiredheight() )

    love.graphics.setColor(self:getbordercolor():getrgba() )
	love.graphics.rectangle(
		"line",
		x + self:getmargin():getleft() + 0.5, 
		y + self:getmargin():gettop() + 0.5,
		self:getdesiredwidth() - 1,
		self:getdesiredheight() - 1)
end

function LOVELi.Window:type() -- override
	return "Window"
end