local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

-- initialize theme
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init(gears.filesystem.get_themes_dir() .. "zenburn/theme.lua")

-- set font and wallpaper
beautiful.font = user.font
beautiful.useless_gap = 5
beautiful.gap_single_client = true
beautiful.awesome_icon = "/home/patrick/.config/awesome/assets/plant.png"

awful.spawn.with_shell("feh --bg-fill " .. user.wallpaper)
