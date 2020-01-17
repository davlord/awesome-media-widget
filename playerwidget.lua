local wibox = require("wibox")
local awful = require("awful")
local gtable = require("gears.table")
local icon_helper = require("awesome-media-widget.iconhelper")
local setmetatable = setmetatable

local player_widget = { mt = {}}

function player_widget:toggle_play_pause()
    local player = self._private.player
    local status = player.playback_status
    if status == "PLAYING" then
        player:pause()
    elseif status == "PAUSED" or status == "STOPPED" then
        player:play()
    end
end

function player_widget:has_player(player)
    return self._private.player == player
end

function player_widget:update_icon()
    local icon = icon_helper.get_icon(self._private.player)
    local imagebox = self.imageboxcontainer.imagebox
    if icon ~= nil then
        imagebox.image = icon:load_surface()
    else
        imagebox.image = nil
    end
end

function player_widget:update_text()
    local player = self._private.player
    local player_name = player.player_name
    local artist = player:get_artist()
    local title = player:get_title()
    local text = string.format("[%s] %s - %s", player_name, artist, title)
    self.textbox:set_text(text)
end

function player_widget:update()
    self:update_icon()
    self:update_text()
end

local function new(args)

    local player = args.player

    local w = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        spacing = 2,
        {
            top    = 8,
            bottom = 8,
            layout = wibox.container.margin,
            id = "imageboxcontainer",
            {
                id = "imagebox",
                widget = wibox.widget.imagebox,
                resize = true,
            },
        },
        {
            id = "textbox",
            widget = wibox.widget.textbox,
        }        
    }

    gtable.crush(w, player_widget, true)

    
    w._private.player = player
    local update = function() w:update() end
    player.on_metadata = update
    player.on_playback_status = update

    w:update()

    w:buttons(gtable.join(
        awful.button({ }, 1, function() w:toggle_play_pause() end)
    ))

    return w
end

function player_widget.mt:__call(...)
    return new(...)
end

return setmetatable(player_widget, player_widget.mt)