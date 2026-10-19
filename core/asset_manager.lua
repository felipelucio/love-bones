local Tileset = require('core.tileset')
local Settings = require('core.settings')
local Utils = require('core.utils')

---@class AssetManager
---@field music table<love.Source>
---@field sfx table<love.Source>
---@field tilesets table<string, Tileset>
---@field textures table<string, love.Image>
---@field messages table<string, table>
---@field shaders table<string, love.Shader>
local AssetManager = {}
AssetManager.__index = AssetManager

local _instance = nil

---Get global instance
---@return AssetManager
function AssetManager.getInstance()
    if not _instance then
        _instance = AssetManager.new()
    end
    return _instance
end

---Constructor
---@return AssetManager
function AssetManager.new()
    return setmetatable({
        music = {},
        sfx = {},
        tilesets = {},
        textures = {},
        messages = {},
        shaders = {},
    }, AssetManager)
end

---Load music file
---@param alias string
---@param filepath string
function AssetManager:loadMusic(alias, filepath)
    self.music[alias] = love.audio.newSource(filepath, "stream")
end

---Load sound effect file
---@param alias string
---@param filepath string
function AssetManager:loadSfx(alias, filepath)
    self.sfx[alias] = love.audio.newSource(filepath, "static")
end

---Load tilesets
---@param alias string
---@param filepath string
---@param tile_w integer
---@param tile_h integer
function AssetManager:loadTileset(alias, filepath, tile_w, tile_h)
    local ts = Tileset.loadImageSize(filepath, tile_w, tile_h)
    self.tilesets[alias] = ts
end

---Load textures
---@param alias string
---@param filepath string
function AssetManager:loadTexture(alias, filepath)
    local texture = love.graphics.newImage(filepath)
    self.textures[alias] = texture
end

---Load messages
---@param filepath string
---@param lang? string
function AssetManager:loadMessages(filepath, lang)
    local lfpath = filepath
    if lang and not lang == 'en' then
        lfpath = lfpath .. "_" .. lang
    end
    lfpath = lfpath .. ".properties"
    if love.filesystem.getInfo(lfpath) == nil then
        lfpath = filepath .. ".properties"
    end
    local messages = self.messages
    for line in love.filesystem.lines(lfpath) do
        if not Utils.str_empty(line) and not line:match("^###") then
            local key, val = line:match("([%w%.%$_]+)=(.*)")
            local msg = messages
            local last_msg = messages
            local k
            if key then
                for kp in key:gmatch("([%w%$_]+)") do
                    k = kp
                    if not msg[kp] then
                        msg[kp] = {}
                    end
                    last_msg = msg
                    msg = msg[kp]
                end
                if last_msg ~= nil then
                    last_msg[k] = val
                end
            end
        end
    end
end

---Compile shader code and store it
---@param name string
---@param code string
---@return love.Shader|nil
function AssetManager:loadShader(name, code)
    local shader = love.graphics.newShader(code)
    if shader then
        self.shaders[name] = shader
    end
    return shader
end

---Get music asset
---@param alias string
---@return love.Source
function AssetManager:getMusic(alias)
    return self.music[alias]
end

---Get sound effect asset
---@param alias string
---@return love.Source
function AssetManager:getSfx(alias)
    return self.sfx[alias]
end

---Get tileset asset
---@param alias string
---@return Tileset
function AssetManager:getTileset(alias)
    return self.tilesets[alias]
end

---Get texture asset
---@param alias string
---@return love.Image
function AssetManager:getTexture(alias)
    return self.textures[alias]
end

---Get messages asset
---@param alias string
---@return table
function AssetManager:getMessages(alias)
    return self.messages[alias]
end

---Get a loaded shader
---@param name string
---@return love.Shader|nil
function AssetManager:getShader(name)
    return self.shaders[name]
end

---Play a random music in track_list
---@param track_list table<string>
---@param looping? boolean
function AssetManager:playRandomTracks(track_list, looping)
    local settings = Settings.getInstance()
    if settings.audio_music_enabled then
        local idx = love.math.random(#track_list)
        looping = looping or false
        local music = self:getMusic(track_list[idx])
        music:play()
    end
end

---Update settings values
function AssetManager:updateSettings()
    local settings = Settings.getInstance()
    local music_volume = settings.audio_master_volume * settings.audio_music_volume
    local sfx_volume = settings.audio_master_volume * settings.audio_sfx_volume
    for _, music in pairs(self.music) do
        music:setVolume(music_volume)
    end
    for _, sfx in pairs(self.sfx) do
        sfx:setVolume(sfx_volume)
    end
end


return AssetManager