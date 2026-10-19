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

LOVELi.Style = {
	basethemes = {
		["default"] = {
			textcolor = LOVELi.Color.parse(0x000000FF),
			textcontrolbackgroundcolor = LOVELi.Color.parse(0xFFFFFFFF),
			textcontrolbordercolor = LOVELi.Color.parse(0xC0C0C0FF),			
			controlforecolor = LOVELi.Color.parse(0xFFFFFFFF),
			controlbackgroundcolor = LOVELi.Color.parse(0xC0C0C0FF),
			controlonbackgroundcolor = LOVELi.Color.parse(0xC0C0C0FF),
			controloffbackgroundcolor = LOVELi.Color.parse(0xE6E6E6FF),
			controlbordercolor = LOVELi.Color.parse(0xFFFFFFFF),
			backgroundcolor = LOVELi.Color.parse(0xECECECFF)
		},
		["blue"] = {
			textcolor = LOVELi.Color.parse(0xFFFFFFFF),
			textcontrolbackgroundcolor = LOVELi.Color.parse(0x25A4D9FF),
			textcontrolbordercolor = LOVELi.Color.parse(0xFFFFFFFF),			
			controlforecolor = LOVELi.Color.parse(0xFFFFFFFF),
			controlbackgroundcolor = LOVELi.Color.parse(0x25A4D9FF),
			controlonbackgroundcolor = LOVELi.Color.parse(0x25A4D9FF),
			controloffbackgroundcolor = LOVELi.Color.parse(0xC0C0C0FF),
			controlbordercolor = LOVELi.Color.parse(0xFFFFFFFF),
			backgroundcolor = LOVELi.Color.parse(0x00000000)
		},
		["pink"] = {
			textcolor = LOVELi.Color.parse(0xFFFFFFFF),
			textcontrolbackgroundcolor = LOVELi.Color.parse(0xDF4794FF),
			textcontrolbordercolor = LOVELi.Color.parse(0xFFFFFFFF),			
			controlforecolor = LOVELi.Color.parse(0xFFFFFFFF),
			controlbackgroundcolor = LOVELi.Color.parse(0xDF4794FF),
			controlonbackgroundcolor = LOVELi.Color.parse(0xDF4794FF),
			controloffbackgroundcolor = LOVELi.Color.parse(0xC0C0C0FF),
			controlbordercolor = LOVELi.Color.parse(0xFFFFFFFF),
			backgroundcolor = LOVELi.Color.parse(0x00000000)
		},
		["dark"] = {
			textcolor = LOVELi.Color.parse(0xFFFFFFFF),
			textcontrolbackgroundcolor = LOVELi.Color.parse(0x000000FF),
			textcontrolbordercolor = LOVELi.Color.parse(0xFFFFFFFF),			
			controlforecolor = LOVELi.Color.parse(0xFFFFFFFF),
			controlbackgroundcolor = LOVELi.Color.parse(0x000000FF),
			controlonbackgroundcolor = LOVELi.Color.parse(0x00FF00FF),
			controloffbackgroundcolor = LOVELi.Color.parse(0x000000FF),
			controlbordercolor = LOVELi.Color.parse(0xFFFFFFFF),
			backgroundcolor = LOVELi.Color.parse(0x000000FF)
		},
		["light"] = {
			textcolor = LOVELi.Color.parse(0x000000FF),
			textcontrolbackgroundcolor = LOVELi.Color.parse(0xFFFFFFFF),
			textcontrolbordercolor = LOVELi.Color.parse(0x000000FF),			
			controlforecolor = LOVELi.Color.parse(0x000000FF),
			controlbackgroundcolor = LOVELi.Color.parse(0xFFFFFFFF),
			controlonbackgroundcolor = LOVELi.Color.parse(0x00FF00FF),
			controloffbackgroundcolor = LOVELi.Color.parse(0xFFFFFFFF),
			controlbordercolor = LOVELi.Color.parse(0x000000FF),
			backgroundcolor = LOVELi.Color.parse(0xFFFFFFFF)
		}
	}
}
LOVELi.Style.__index = LOVELi.Style
function LOVELi.Style:new(styles, parent) -- LOVELi.Style LOVELi.Style:new(Dictionary<string targettype, Dictionary<string key, object option> options> styles, LOVELi.Style parent)
	local o = { 
		styles = styles or {},
		parent = parent
	}
	for targettype, options in pairs(o.styles) do
		for key, option in pairs(options) do
			options[key] = LOVELi.Property.parse(option)
		end
	end
	setmetatable(o, self)
	return o
end
function LOVELi.Style:getstyles()
	return self.styles
end
function LOVELi.Style:getoptions(targettype)
	return self.styles[targettype]
end
function LOVELi.Style:getoption(targettype, key)
	if self.styles[targettype] then
		return self.styles[targettype][key]
	end
end
function LOVELi.Style:setoption(targettype, key, option)
	if self.styles[targettype] then
		self.styles[targettype][key] = LOVELi.Property.parse(option)
	else
		self.styles[targettype] = {
			[key] = LOVELi.Property.parse(option)
		}
	end
end
function LOVELi.Style:getparent()
	return self.parent
end
function LOVELi.Style:type()
	return "Style"
end
function LOVELi.Style.parse(value) -- static
	local textcolor = nil
	local textcontrolbackgroundcolor = nil
	local textcontrolbordercolor = nil
	local controlforecolor = nil
	local controlbackgroundcolor = nil
	local controlonbackgroundcolor = nil
	local controloffbackgroundcolor = nil
	local controlbordercolor = nil
	local backgroundcolor = nil
	if type(value) == "string" then
		local basetheme = LOVELi.Style.basethemes[value:lower()]
		if basetheme then
			textcolor = basetheme.textcolor
			textcontrolbackgroundcolor = basetheme.textcontrolbackgroundcolor
			textcontrolbordercolor = basetheme.textcontrolbordercolor
			controlforecolor = basetheme.controlforecolor
			controlbackgroundcolor = basetheme.controlbackgroundcolor
			controlonbackgroundcolor = basetheme.controlonbackgroundcolor
			controloffbackgroundcolor = basetheme.controloffbackgroundcolor
			controlbordercolor = basetheme.controlbordercolor
			backgroundcolor = basetheme.backgroundcolor
		end
	elseif type(value) == "table" then -- Please note: these values may change in a future release
		textcolor = value.textcolor
		textcontrolbackgroundcolor = value.textcontrolbackgroundcolor
		textcontrolbordercolor = value.textcontrolbordercolor
		controlforecolor = value.controlforecolor
		controlbackgroundcolor = value.controlbackgroundcolor
		controlonbackgroundcolor = value.controlonbackgroundcolor
		controloffbackgroundcolor = value.controloffbackgroundcolor
		controlbordercolor = value.controlbordercolor
		backgroundcolor = value.backgroundcolor
	end
	local styles = {
		["Label"] = {
			textcolor = textcolor
		},
		["ProgressBar"] = {
			forecolor = controlforecolor,
			backgroundcolor = controlbackgroundcolor,
			bordercolor = controlbordercolor
		},
		["Button"] = {
			textcolor = textcolor,
			backgroundcolor = controlbackgroundcolor,
			bordercolor = controlbordercolor
		},
		["CheckBox"] = {
			forecolor = controlforecolor,
			backgroundcolor = controlbackgroundcolor,
			bordercolor = controlbordercolor
		},
		["RadioButton"] = {
			forecolor = controlforecolor,
			backgroundcolor = controlbackgroundcolor,
			bordercolor = controlbordercolor
		},
		["Switch"] = {
			forecolor = controlforecolor,
			onbackgroundcolor = controlonbackgroundcolor,
			offbackgroundcolor = controloffbackgroundcolor,
			bordercolor = controlbordercolor
		},
		["Slider"] = {
			forecolor = controlforecolor,
			backgroundcolor = controlbackgroundcolor,
			bordercolor = controlbordercolor
		},
		["TextBox"] = {
			textcolor = textcolor,
			backgroundcolor = textcontrolbackgroundcolor,
			bordercolor = textcontrolbordercolor
		},
		["MaskedTextBox"] = {
			textcolor = textcolor,
			backgroundcolor = textcontrolbackgroundcolor,
			bordercolor = textcontrolbordercolor
		},
		["Picker"] = {
			textcolor = textcolor,
			backgroundcolor = controlbackgroundcolor,
			bordercolor = controlbordercolor
		},
		["Border"] = {
			backgroundcolor = backgroundcolor
		}
	}
	return LOVELi.Style:new(styles)
end