local lgi = require 'lgi'
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local gtable = require("gears.table")
local player_widget = require("awesome-media-widget.playerwidget")
local dbg = require(".debug")
local setmetatable = setmetatable
local iparis = ipairs
local Playerctl = lgi.Playerctl
local Player = Playerctl.Player

local player_manager = nil

local media_widget = { mt = {} }

function media_widget:register_players()
    for _, player_name in ipairs(player_manager.player_names) do
        self:register_player(player_name)
    end
end

function media_widget:unregister_player(player)
    local index_to_remove = nil
    for i, player_widget in ipairs(self.children) do
        if player_widget:has_player(player) then
            index_to_remove = i
            break
        end
    end
    
    if index_to_remove ~= nil then
        self:remove(index_to_remove)
    end
end

function media_widget:register_player(player_name)
    local new_player = Player.new_from_name(player_name)
    player_manager:manage_player(new_player)
    self:add(player_widget({ player = new_player }))
end

local function new(args)
    local container = wibox.layout.fixed.horizontal()
    container.spacing = 2

    gtable.crush(container, media_widget, true)

    player_manager = Playerctl.PlayerManager.new()
    container:register_players()
    player_manager.on_name_appeared = function(_, player_name) container:register_player(player_name) end
    player_manager.on_player_vanished = function(_,player) container:unregister_player(player) end

    return container
end

function media_widget.mt:__call(...)
    return new(...)
end

return setmetatable(media_widget, media_widget.mt)