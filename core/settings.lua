---@class Settings
---@field audio_master_volume number
---@field audio_music_enabled boolean
---@field audio_music_volume number
---@field audio_sfx_enabled boolean
---@field audio_sfx_volume number
local Settings = { class = "Settings" }
Settings.__index = Settings

local _instance = nil

---Constructor
---@return Settings
function Settings.new()
    return setmetatable({
        audio_master_volume = 1.0,
        audio_music_enabled = true,
        audio_music_volume = 1.0,
        audio_sfx_enabled = true,
        audio_sfx_volume = 1.0,
    }, Settings)
end

---Get intance
---@return Settings
function Settings.getInstance()
    if not _instance then
        _instance = Settings.new()
    end
    return _instance
end

return Settings