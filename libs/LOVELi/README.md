# LOVELi (LÖVE Layout & GUI)

A [LÖVE 2D](https://love2d.org/) retained mode layout and GUI library.
Includes StackLayout, AbsoluteLayout, Grid and FlexLayout layouts.
Includes Label, Button, ImageButton, Image, CheckBox, RadioButton, Switch, ProgressBar, Slider, TextBox, MaskedTextBox, Picker, Border, GraphicsView and ScrollView controls.
This library was inspired by .NET's MAUI controls.
Tested on version 11.5.

![Menu](/menu.png)

See [menu.lua](/examples/menu.lua) example.

![Control](/controls.png)

See [controls.lua](/examples/controls.lua) example.

![Layout](/layouts.png)

See [layouts.lua](/examples/layouts.lua) example.

# Why?

I needed a simple way for creating game menus and overlays. Since I did not find any simple - yet complete - library, I've written my own.

# How to

1. Copy LOVELi folder to your project.
2. Import the library and hook the following methods:
```lua
local loveli = require("LOVELi")
function love.load(arg)
  -- See below --
  layoutmanager = loveli.LayoutManager:new{}
    :with(rootcontrol)
end
function love.keypressed(key, scancode, isrepeat)
  layoutmanager:keypressed(key, scancode, isrepeat)
end
function love.textinput(text)
  layoutmanager:textinput(text)
end
function love.mousepressed(x, y, button, istouch, presses)
  layoutmanager:mousepressed(x, y, button, istouch, presses)
end
function love.mousereleased(x, y, button, istouch, presses)
  layoutmanager:mousereleased(x, y, button, istouch, presses)
end
function love.mousemoved(x, y, dx, dy, istouch)
  layoutmanager:mousemoved(x, y, dx, dy, istouch)
end
function love.wheelmoved(dx, dy)
  layoutmanager:wheelmoved(dx, dy)
end
function love.joystickhat(joystick, hat, direction)
  layoutmanager:joystickhat(joystick, hat, direction)
end
function love.joystickpressed(joystick, button)
  layoutmanager:joystickpressed(joystick, button)
end
function love.resize(w, h)
  layoutmanager:resize(w, h)
end
function love.update(dt)
  layoutmanager:update(dt)
end
function love.draw()	
  layoutmanager:draw()
end
```

## Layouts

3. Use one of the following layouts:

### StackLayout

A StackLayout organizes elements in a one-dimensional stack, either horizontally or vertically.

```lua
local stacklayout = loveli.StackLayout:new{ orientation = "vertical", spacing = 5, width = "*", height = "*", margin = loveli.Thickness.parse(10) } 
  :with(loveli.Button:new{ text = "Button 1", horizontaltextalignment = "start", verticaltextalignment = "center", width = 75, height = 23, horizontaloptions = "start" } )
  :with(loveli.Button:new{ text = "Button 2", horizontaltextalignment = "center", verticaltextalignment = "center", width = 75, height = "*", horizontaloptions = "center" } )
  :with(loveli.Button:new{ text = "Button 3", horizontaltextalignment = "end", verticaltextalignment = "center", width = 75, height = 23, horizontaloptions = "end" } )		
local rootcontrol = stacklayout
```

### AbsoluteLayout

An AbsoluteLayout is used to position and size elements using explicit values.

```lua
local absolutelayout = loveli.AbsoluteLayout:new{ width = 250, height = 250, margin = loveli.Thickness.parse(10) } 
  :with(loveli.Button:new{ text = "Top Left", horizontaltextalignment = "center", verticaltextalignment = "center", x = 0, y = 0, width = 75, height = 23 } )
  :with(loveli.Button:new{ text = "Top Center", horizontaltextalignment = "center", verticaltextalignment = "center", x = 125 -38.5, y = 0, width = 75, height = 23 } )
  :with(loveli.Button:new{ text = "Top Right", horizontaltextalignment = "center", verticaltextalignment = "center", x = 250 -75, y = 0, width = 75, height = 23 } )	
  :with(loveli.Button:new{ text = "Center Left", horizontaltextalignment = "center", verticaltextalignment = "center", x = 0, y = 125 -11.5, width = 75, height = 23 } )
  :with(loveli.Button:new{ text = "Center", horizontaltextalignment = "center", verticaltextalignment = "center", x = 125 -38.5, y = 125 -11.5, width = 75, height = 23 } )
  :with(loveli.Button:new{ text = "Center Right", horizontaltextalignment = "center", verticaltextalignment = "center", x = 250 -75, y = 125 -11.5, width = 75, height = 23 } )	
  :with(loveli.Button:new{ text = "Bottom Left", horizontaltextalignment = "center", verticaltextalignment = "center", x = 0, y = 250 -23, width = 75, height = 23 } )
  :with(loveli.Button:new{ text = "Bottom Center", horizontaltextalignment = "center", verticaltextalignment = "center", x = 125 -38.5, y = 250 -23, width = 75, height = 23 } )
  :with(loveli.Button:new{ text = "Bottom Right", horizontaltextalignment = "center", verticaltextalignment = "center", x = 250 -75, y = 250 -23, width = 75, height = 23 } )
local rootcontrol = absolutelayout
```

### Grid

A Grid is used for displaying elements in rows and columns, which can have proportional or absolute sizes. 

```lua
local grid = loveli.Grid:new{ rowdefinitions = { "auto", "1*", "1*" }, columndefinitions = { "auto", "1*", 150 }, width = "*", height = "*", margin = loveli.Thickness.parse(10) } 
  :with(1, 1, absolutelayout)
  :with(2, 2, stacklayout)
local rootcontrol = grid
```

### FlexLayout

FlexLayout is a layout that can arrange its children horizontally and vertically in a stack, and can also wrap its children if there are too many to fit in a single row or column. In addition, FlexLayout can control orientation and alignment, and adapt to different screen sizes.

```lua
local flexlayout = loveli.FlexLayout:new{ direction = "row", justifycontent = "spaceevenly", aligncontent = "center", width = 300, height = 100, verticaloptions = "center", horizontaloptions = "center", margin = loveli.Thickness.parse(10) }
  :with(loveli.Button:new{ text = "Button 1", width = 75, height = 23 } )
  :with(loveli.Button:new{ text = "Button 2", width = 75, height = 23, margin = loveli.Thickness.parse(10)  } )
  :with(loveli.Button:new{ text = "Button 3", width = 75, height = 23, verticaloptions = "start" } )
  :with(loveli.Button:new{ text = "Button 4", width = 75, height = 23 } )
  :with(loveli.Button:new{ text = "Button 5", width = 75, height = 23 } )		
local rootcontrol = flexlayout
```

## Controls

4. And the following controls:

### Label

Label displays single, or multiple, lines of text. 

```lua
loveli.Label:new{ text = "Label" }
```

### Button

Button displays text and responds to a tap or click that directs an app to carry out a task.

```lua
loveli.Button:new{
  text = "Button",
  clicked = function(sender) end, 
  -- Default values for text controls:
    ismultiline = false,
    font = love.graphics.getFont(),
    horizontaltextalignment = "center",
    verticaltextalignment = "center",
    textcolor = loveli.Color.parse(0x000000FF),
  -- Default values for colors:
    backgroundcolor = loveli.Color.parse(0xC0C0C0FF),
    bordercolor = loveli.Color.parse(0xFFFFFFFF),
  -- Default values for size and position:
    x = 0,
    y = 0,
    width = "auto",
    height = "auto",
    minwidth = 0,
    maxwidth = math.huge,
    minheight = 0,
    maxheight = math.huge,
    margin = loveli.Thickness.parse(0),
    horizontaloptions = "start",
    verticaloptions = "start",
    zindex = 0,
  -- Default values for all controls:
    name = nil,
    isvisible = true,
    isenabled = true,
    style = LOVELi.Style:new()
}
```

### ImageButton

ImageButton view combines the Button view and Image view to create a button whose content is an image. 

```lua
loveli.ImageButton:new{ source = "icon.png", aspect = "aspectfit", width = 64, height = 32, clicked = function(sender) end }
```

### Image

Image displays an image that can be loaded from a local file.

```lua
loveli.Image:new{ source = "icon.png", aspect = "aspectfit", width = 64, height = 32 }
```

### CheckBox

CheckBox enables you to select a boolean value using a type of button that can either be checked or empty.

```lua
loveli.CheckBox:new{ ischecked = false, checkedchanging = function(sender, oldvalue, newvalue) return true end, checkedchanged = function(sender, oldvalue, newvalue) end }
```

### RadioButton

RadioButton is a type of button that allows the selection of one option from a set. 

```lua
loveli.RadioButton:new{ ischecked = false, groupname = "1", checkedchanging = function(sender, oldvalue, newvalue) return true end, checkedchanged = function(sender, oldvalue, newvalue) end }
```

### Switch

Switch enables you to select a boolean value using a type of button that can either be on or off.

```lua
loveli.Switch:new{ istoggled = false, toggling = function(sender, oldvalue, newvalue) return true end, toggled = function(sender, oldvalue, newvalue) end }
```

### ProgressBar

ProgressBar uses an animation to show that the app is progressing through a lengthy activity.

```lua
loveli.ProgressBar:new{ progress = 0.75 }
```

### Slider

Slider enables you to select a value from a range. 

```lua
loveli.Slider:new{ value = 5, minimum = 0, maximum = 10, valuechanging = function(sender, oldvalue, newvalue) return true end, valuechanged = function(sender, oldvalue, newvalue) end }
```

### TextBox 

TextBox enables you to enter and edit a single, or multiple, lines of text.

```lua
local textbox = loveli.TextBox:new{ text = "TextBox", ispassword = false, maxlength = 255, textchanging = function(sender, oldvalue, newvalue) return true end, textchanged = function(sender, oldtext, newtext) end }
```

### MaskedTextBox 

```lua
local maskedtextbox = loveli.MaskedTextBox:new{ mask = "(000) 000-0000", patterns = { ["0"] = { pattern = "%d" } }, textchanging = function(sender, oldvalue, newvalue) return true end, textchanged = function(sender, oldtext, newtext) end }
```

### Picker 

Picker displays a short list of items, from which the user can select an item.

```lua
local picker = loveli.Picker:new{ selectedindexchanged = function(sender, oldindex, newindex) print(oldindex, newindex) end, itemssource = { "Option 1", "Option 2", "Option 3", "Option 4", { tostring = function(self) return "Option 5" end } }, text = "Select...", width = 100, height = "auto" } )
```

### Border

Border is a container control that adds padding, draws a border, background, or both, around another control. 

```lua
local border = loveli.Border:new{ padding = loveli.Thickness.parse(10), bordercolor = loveli.Color.parse(0x00000000), backgroundcolor = loveli.Color.parse(0x00000000) }
  :with(textbox)
```

### GraphicsView

GraphicsView is a graphics canvas on which 2D graphics can be drawn. 

```lua
local graphicsview = loveli.GraphicsView:new{ drawable = function(sender, x, y) end, width = "*", height = "*" }
```

### ScrollView

ScrollView is a view that's capable of scrolling its content.

```lua
local scrollview = loveli.ScrollView:new{ scrolled = function(sender, dx, dy) end, orientation = "both", verticalscrollbarvisibility = "default", verticalscrollbarwidth = 5, verticalscrollbarincrement = 100, width = "*", height = "*" }
  :with(stacklayout)
```

# Styles and Themes

5. If you want, controls can be styled by using the Style class to group a collection of property values into one object that can then be applied to multiple visual elements.
This helps to reduce repetitive work, and allows the appearance to be more easily changed.

```lua
local basestyle = loveli.Style:new ( { ["Button"] = { backgroundcolor = loveli.Color.parse("black"), textcolor = loveli.Color.parse("white") } } )
local mystyle = loveli.Style:new ( { ["Button"] = { textcolor = loveli.Color.parse("blue") } }, basestyle)
loveli.Button:new{ text = "Button", width = 75, height = 23, style = mystyle }
```

See [styles.lua](/examples/styles.lua) example for implicit/explicit style usage.

See [themes.lua](/examples/themes.lua) example for theme usage.

# Effects

6. You can add effects to, for example, the focused control:

```lua
layoutmanager = loveli.LayoutManager:new{ 
    drawmanager = LOVELi.DrawManager:new{ 
        focusedeffects = { 
            LOVELi.AlphaPulseEffect:new(0.25, 0.75, 2), 
            -- Try these too:
            -- LOVELi.HueShiftEffect:new(2), 
            -- LOVELi.ScalePulseEffect:new(0.8, 1, 1), 
            -- LOVELi.RotateEffect:new(-0.05, 0.05, 1), 
            -- LOVELi.ShakeEffect:new(4, 4), 
            -- LOVELi.InvertColorShaderEffect:new()
            -- Have fun!
        },
        unfocusedeffects = {}
    }
}
```

Customize other drawing aspects by inheriting DrawManager class:

```lua
layoutmanager = loveli.LayoutManager:new{ 
    drawmanager = LOVELi.FocusedBorderDrawManager:new{ 
        bordercolor = LOVELi.Color.parse("#FF0000FF"), 
        linewidth = 3,
        focusedeffects = {},
        unfocusedeffects = {}
    }
}
```

See [effects.lua](/examples/effects.lua) example for effects usage.

# Keyboard Accessibility

This library supports `tab`, `shift + tab`, `down` arrow and `up` arrow for navigation, `space` and `return` for action.

# Joystick Accessibility

This library supports `down` hat and `up` hat for navigation, `any button` for action.

# Support Us

If you enjoy using open source projects and would like to support our work, consider making a donation! Your contributions help us maintain and improve the project. You can support us by sending directly to the following address:

Bitcoin (BTC) Address: bc1qc2p79gtjhnpff78su86u8vkynukt8pmfnr43lf

Monero (XMR) Address: 87KefRhqaf72bYBUF3EsUjY89iVRH72GsRsEYZmKou9ZPFhGaGzc1E4URbCV9oxtdTYNcGXkhi9XsRhd2ywtt1bq7PoBfd4

Thank you for your support! Every contribution, no matter the size, makes a difference.