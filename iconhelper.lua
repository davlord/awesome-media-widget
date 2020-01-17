local lgi = require 'lgi'

local icon_theme = lgi.Gtk.IconTheme.get_default()
local IconLookupFlags = lgi.Gtk.IconLookupFlags

local iconhelper = {}

local function lookup_icon(name)
    return icon_theme:lookup_icon(name, 64, {IconLookupFlags.GENERIC_FALLBACK})
end

local icon = {
    playable = lookup_icon("media-playback-start-symbolic"),
    pausable = lookup_icon("media-playback-pause-symbolic"),
}

function iconhelper.get_icon(player)
    local status = player.playback_status
    if status == "PLAYING" then
        return icon.pausable
    elseif status == "PAUSED" then
        return icon.playable
    elseif status == "STOPPED" then
        return icon.playable
    end

end

return iconhelper