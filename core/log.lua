---@enum LogLevel
local LogLevel = {
	NOTSET = 0,
	DEBUG = 10,
	INFO = 20,
	WARN = 30,
	ERROR = 40,
	CRITICAL = 50,
}

---Get the level name
---@param level LogLevel
---@return string
local function LogLevel_getName(level)
	if level == LogLevel.DEBUG then
		return "debug"
	elseif level == LogLevel.INFO then
		return "info"
	elseif level == LogLevel.WARN then
		return "warn"
	elseif level == LogLevel.ERROR then
		return "error"
	elseif level == LogLevel.CRITICAL then
		return "critical"
	else
		return ""
	end
end

---Get the Operating System name
---@return string
local function getOS()
	return love.system.getOS()
end

---Get the FPS count
---@return number
local function getFPS()
	return love.timer.getFPS()
end

---Get the mouse coordinates
---@return number, number
local function getMouseCoords()
	return love.mouse.getPosition()
end

---Get the time since last frame, in milliseconds
---@return number
local function getDelta()
	return love.timer.getDelta() * 1000
end

---Get the memory usage (textures + Lua runtime + Love2D runtime)
---@param scale? string The scale to be show: "b" = bytes, "k" = kilobytes, "m" = megabytes or "g" = gigabytes. Default: "k"
---@return number
local function getMemoryUsage(scale)
	scale = scale or "k"
	local divisor = 1
	if scale == "k" then
		divisor = 1024
	elseif scale == "m" then
		divisor = 1024 * 1024
	elseif scale == "g" then
		divisor = 1024 * 1024 * 1024
	end

	local stats = love.graphics.getStats()
	return math.floor(((collectgarbage("count") + stats.texturememory) / divisor) + 0.5)
end

---Get the total running time
---@return number
local function getDuration()
	return love.timer.getTime()
end

---Get the formated total running time
---@return string
local function getFormatedDuration()
	local f = "Duration: %02d:%02d:%02d.%03d"
	local t = getDuration()
	local h = t % (24 * 3600) / 3600
	t = t % 3600
	local m = t / 60
	t = t % 60
	local s = t
	local ms = (s - math.floor(s)) * 1000
	return string.format(f, h, m, s, ms)
end

---@class LogConsoleOptions
---@field public text_color table<number> The log text color. Format: (R, G, B, A) where values are between [0.0, 1.0] space. Default: {1, 1, 1, 1}
---@field public show_os boolean Display the running OS. Default: false
---@field public show_fps boolean Display the FPS. Default: false
---@field public show_mem boolean Display the memory usage. Default: false
---@field public show_delta boolean Display the delta time between current and last frame. Default: false
---@field public show_duration boolean Display the duration since the application start. Default: false
---@field public show_mouse_pos boolean Display the mouse position coordinates. Default: false
local LogConsoleOptions = {}

---Constructor
---@return LogConsoleOptions
function LogConsoleOptions.default()
	return {
		text_color = { 1, 1, 1, 1 },
		show_os = false,
		show_fps = false,
		show_mem = false,
		show_duration = false,
		show_mouse_pos = false,
	}
end

---@class LogCanvasOptions
---@field public text_color table<number> The log text color. Format: (R, G, B, A) where values are between [0.0, 1.0] space. Default: {1, 1, 1, 1}
---@field public font_size integer The text font size. Default: 14
---@field public pos_x integer The log x position on screen. Default: 5
---@field public pos_y integer The log y position on screen. Default: 5
---@field public show_os boolean Display the running OS. Default: true
---@field public show_fps boolean Display the FPS. Default: true
---@field public show_mem boolean Display the memory usage. Default: true
---@field public show_delta boolean Display the delta time between current and last frame. Default: true
---@field public show_duration boolean Display the duration since the application start. Default: true
---@field public show_mouse_pos boolean Display the mouse position coordinates. Default: true
---@field public mem_size string Select the unit that the memory usage will be displayed. "b" = bytes, "k" = kilobytes, "m" = megabytes, "g" = gigabytes. Default: "k"
---@field public show_level boolean Enable or disable the coresponding level tag before the log entry
local LogCanvasOptions = {}

---Constructor
---@return LogCanvasOptions
function LogCanvasOptions.default()
	return {
		text_color = { 1, 1, 1, 1 },
		font_size = 14,
		pos_x = 5,
		pos_y = 5,
		show_os = true,
		show_fps = true,
		show_mem = true,
		show_duration = true,
		show_mouse_pos = true,
		mem_size = "k",
		show_level = true,
	}
end

-- TODO: Implement LogConsoleDriver
---@class LogConsoleDriver
---@field options LogOptions
---@field log table<LogEntry>
local LogConsoleDriver = {}
LogConsoleDriver.__index = LogConsoleDriver

---Constructor
---@param options LogOptions
---@return LogConsoleDriver
function LogConsoleDriver.new(options)
	return setmetatable({
		options = options,
		log = {},
	}, LogConsoleDriver)
end

---@class LogCanvasDriver
---@field options LogOptions
---@field log table<LogEntry>
---@field offset_x integer Used to offset the buffer draw
---@field offset_y integer Used to offset the buffer draw
local LogCanvasDriver = {}
LogCanvasDriver.__index = LogCanvasDriver

function LogConsoleDriver:addMessage(msg, level)
	level = level or LogLevel.NOTSET
	local lvl_name = ""
	if self.options.canvas.show_level then
		lvl_name = LogLevel_getName(level)
		if lvl_name ~= "" then
			lvl_name = "[" .. lvl_name .. "] "
		end
	end

	print(lvl_name .. msg)
end

function LogConsoleDriver:draw()
	
end

---Constructor
---@param options LogOptions
---@return LogCanvasDriver
function LogCanvasDriver.new(options)
	return setmetatable({
		options = options,
		log = {},
		offset_x = 0,
		offset_y = 0,
	}, LogCanvasDriver)
end

---Add message to the log
---@param msg string
---@param level? LogLevel Color as table
function LogCanvasDriver:addMessage(msg, level)
	level = level or LogLevel.NOTSET
	local lvl_name = ""
	if self.options.canvas.show_level then
		lvl_name = LogLevel_getName(level)
		if lvl_name ~= "" then
			lvl_name = "[" .. lvl_name .. "] "
		end
	end

	local color = self.options.color_notset
	if level == LogLevel.CRITICAL then
		color = self.options.color_critical
	elseif level == LogLevel.ERROR then
		color = self.options.color_error
	elseif level == LogLevel.WARN then
		color = self.options.color_warn
	elseif level == LogLevel.INFO then
		color = self.options.color_info
	elseif level == LogLevel.DEBUG then
		color = self.options.color_debug
	end
	self.log[#self.log + 1] = {
		msg = lvl_name .. msg .. "\n",
		level = level,
		color = color,
	}
end

---Draw the log to the canvas
function LogCanvasDriver:draw()
	local font = love.graphics.newFont(self.options.canvas.font_size)
	love.graphics.setFont(font)
	love.graphics.setColor(0, 1, 0, 1)

	local pos_x = self.options.canvas.pos_x - self.offset_x
	local pos_y = self.options.canvas.pos_y - self.offset_y
	local curr_y = 0
	local line = 0
	if self.options.canvas.show_os then
		line = line + 1
		curr_y = pos_y + (line - 1) * self.options.canvas.font_size
		love.graphics.print(string.format("OS: %s", getOS()), pos_x, curr_y)
	end

	if self.options.canvas.show_fps then
		line = line + 1
		curr_y = pos_y + (line - 1) * self.options.canvas.font_size
		love.graphics.print(string.format("FPS: %s", getFPS()), pos_x, curr_y)
	end

	if self.options.canvas.show_mem then
		line = line + 1
		curr_y = pos_y + (line - 1) * self.options.canvas.font_size
		local size = "bytes"
		if self.options.canvas.mem_size == "k" then
			size = "kilobytes"
		elseif self.options.canvas.mem_size == "m" then
			size = "megabytes"
		elseif self.options.canvas.mem_size == "g" then
			size = "gigabytes"
		end
		love.graphics.print(
			string.format("MEM: %.2f %s", getMemoryUsage(self.options.canvas.mem_size), size),
			pos_x,
			curr_y
		)
	end

	if self.options.canvas.show_mouse_pos then
		line = line + 1
		curr_y = pos_y + (line - 1) * self.options.canvas.font_size
		local x, y = getMouseCoords()
		local coords = string.format("Mouse: %d, %d", x, y)
		love.graphics.print(coords, pos_x, curr_y)
	end

	if self.options.canvas.show_delta then
		line = line + 1
		curr_y = pos_y + (line - 1) * self.options.canvas.font_size
		love.graphics.print(string.format("Delta: %.1fms", getDelta()), pos_x, curr_y)
	end

	if self.options.canvas.show_duration then
		line = line + 1
		curr_y = pos_y + (line - 1) * self.options.canvas.font_size
		love.graphics.print(getFormatedDuration(), pos_x, curr_y)
	end

	line = line + 1
	curr_y = pos_y + (line - 1) * self.options.canvas.font_size
	love.graphics.print("---------- Log ----------", pos_x, curr_y)

	local start = 1
	if #self.log > self.options.log_size then
		start = #self.log - self.options.log_size
	end
	local finish = #self.log
	for i = start, finish do
		line = line + 1
		curr_y = pos_y + (line - 1) * self.options.canvas.font_size

		local color = self.log[i].color
		local msg = self.log[i].msg
		love.graphics.setColor(unpack(color))
		love.graphics.print(msg, pos_x, curr_y)
	end
	love.graphics.reset()
end

---@class LogOptions
---@field public drivers table<string> List of output drivers. Implemented drivers: "canvas" and "console". Default: { "canvas" }
---@field public canvas LogCanvasOptions Options for canvas driver
---@field public console LogConsoleOptions Options for Console driver
---@field public level LogLevel The log level filter. Default: LogLevel.DEBUG
---@field public enabled boolean Enables or disables the log system. Default: true
---@field public log_size integer How many lines will be displayed. Default: 10
---@field public log_path string The output log file. Default: "lovelog.log"
---@field public date_format string The date format in the logs. Default: "%Y-%m-%dT%H:%M:%S"
---@field public color_notset table<number> Color used in NOTSET level. Format: (R, G, B, A) where values are in [0.0, 1.0] space. Default: {1, 1, 1, 1}
---@field public color_debug table<number> Color used in DEBUG level. Format: (R, G, B, A) where values are in [0.0, 1.0] space. Default: {0, 1, 0, 1}
---@field public color_info table<number> Color used in INFO level. Format: (R, G, B, A) where values are in [0.0, 1.0] space. Default: {0, 0, 1, 1}
---@field public color_warn table<number> Color used in WARN level. Format: (R, G, B, A) where values are in [0.0, 1.0] space. Default: {0, 1, 1, 1}
---@field public color_error table<number> Color used in ERROR level. Format: (R, G, B, A) where values are in [0.0, 1.0] space. Default {1, 0.5, 0, 1}
---@field public color_critical table<number> Color used in CRITICAL level. Format: (R, G, B, A) where values are in [0.0, 1.0] space. Default: {1, 0, 0, 1}
local LogOptions = {}

---Constructor
---@return LogOptions
function LogOptions.default()
	return {
		drivers = { "canvas" },
		canvas = LogCanvasOptions.default(),
		console = LogConsoleOptions.default(),
		level = LogLevel.DEBUG,
		enabled = true,
		log_size = 10,
		log_path = "lovelog.log",
		date_format = "%Y-%m-%dT%H:%M:%S",
		color_notset = { 1, 1, 1, 1 },
		color_debug = { 0, 1, 0, 1 },
		color_info = { 0, 0, 1, 1 },
		color_warn = { 0, 1, 1, 1 },
		color_error = { 1, 0.5, 0, 1 },
		color_critical = { 1, 0, 0, 1 },
	}
end

---@class LogEntry
---@field public level LogLevel
---@field public msg string

---@class Log
---@field private options LogOptions
---@field private _drivers table<any>
---@field private _log table<LogEntry>
local Log = {}
Log.__index = Log
Log._drivers_register = {}

---Register driver
---@param name string
---@param driver any
function Log.register(name, driver)
	Log._drivers_register[name] = driver
end

---Dump table
---@param tbl table
---@param indent? integer Indent size (spaces)
---@return string
function Log.dump(tbl, indent)
	indent = indent or 0
	local s = "{ "
	if indent > 0 then
		s = s .. "\n"
	end
	for k, v in pairs(tbl) do
		if indent > 0 then
			s = s .. string.rep(" ", indent) .. tostring(k) .. ":"
		else
			s = s .. tostring(k) .. ": "
		end
		if type(v) == "table" then
			if indent > 0 then
				s = s .. Log.dump(v, indent + 4) .. "\n"
			else
				s = s .. Log.dump(v) .. ", "
			end
		else
			if indent > 0 then
				s = s .. string.rep(" ", indent + 4) .. tostring(v) .. ",\n"
			else
				s = s .. tostring(v) .. ", "
			end
		end
	end
	s = s .. " }"
	return s
end

---Constructor
---@param options? any
---@return Log
function Log.new(options)
	options = options or LogOptions.default()
	local drivers = {}
	for _, d_name in ipairs(options.drivers) do
		local drv = Log._drivers_register[d_name]
		if drv then
			drivers[d_name] = drv.new(options)
		end
	end
	return setmetatable({
		options = options,
		_drivers = drivers,
		_log = {},
	}, Log)
end

---Offset the canvas drawing
---@param offset_x integer
---@param offset_y integer
function Log:setOffsetCanvas(offset_x, offset_y)
	local canvas_drv = self._drivers["canvas"] --[[@as LogCanvasDriver]]
	if canvas_drv then
		canvas_drv.offset_x = offset_x
		canvas_drv.offset_y = offset_y
	end
end

---Offset the canvas drawing by give rows/columns
---@param offset_x integer
---@param offset_y integer
function Log:setOffsetBy(offset_x, offset_y)
	local canvas_drv = self._drivers["canvas"] --[[@as LogCanvasDriver]]
	if canvas_drv then
		canvas_drv.offset_x = canvas_drv.offset_x - (offset_x * self.options.canvas.font_size)
		canvas_drv.offset_y = canvas_drv.offset_y - (offset_y * self.options.canvas.font_size)
	end
end

---Reset the offset for canvas drawing
function Log:resetOffsetCanvas()
	local canvas_drv = self._drivers["canvas"] --[[@as LogCanvasDriver]]
	if canvas_drv then
		canvas_drv.offset_x = 0
		canvas_drv.offset_y = 0
	end
end

---Add a message to the log
---@param msg string
---@param level? LogLevel Default: LogLevel.NOTSET
function Log:addMessage(msg, level)
	if self.options.enabled then
		level = level or LogLevel.NOTSET
		self._log[#self._log + 1] = {
			msg = msg,
			level = level,
		}
		if self.options.log_path then
			local time = os.date(self.options.date_format)
			local file = io.open(self.options.log_path, "a")
			if file ~= nil then
				local lvl_name = LogLevel_getName(level)
				if lvl_name ~= "" then
					lvl_name = "[" .. lvl_name .. "]"
				end
				file:write(string.format("%s %s %s\n", time, lvl_name, msg))
				file:close()
			end
		end

		for _, drv in pairs(self._drivers) do
			drv:addMessage(msg, level)
		end
	end
end

---Add debug to the log
---@param msg string
function Log:debug(msg)
	self:addMessage(msg, LogLevel.DEBUG)
end

---Add info to the log
---@param msg string
function Log:info(msg)
	self:addMessage(msg, LogLevel.INFO)
end

---Add warn to the log
---@param msg string
function Log:warn(msg)
	self:addMessage(msg, LogLevel.WARN)
end

---Add error to the log
---@param msg string
function Log:error(msg)
	self:addMessage(msg, LogLevel.ERROR)
end

---Add critical to the log
---@param msg string
function Log:critical(msg)
	self:addMessage(msg, LogLevel.CRITICAL)
end

---Draw the log. Call this in love.draw() method
function Log:draw()
	if self.options.enabled then
		for _, drv in pairs(self._drivers) do
			drv:draw()
		end
	end
end

Log.register("canvas", LogCanvasDriver)
Log.register("console", LogConsoleDriver)
return {
	LogLevel = LogLevel,
	Log = Log,
	LogOptions = LogOptions,
}
