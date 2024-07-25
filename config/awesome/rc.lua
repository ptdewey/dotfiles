local gears = require("gears")

-- Errors

require("naughty").connect_signal("request::display_error", function(message, startup)
	require("naughty").notification({
		urgency = "critical",
		title = "Error" .. (startup and " during startup!" or "!"),
		message = message,
	})
end)

-- User

user = {
	batt = "BAT0",
	browser = "firefox",
	color = "darkearth",
	file_manager = "nemo",
	font = "IosevkaPatrick Nerd Font 16",
	fontalt = "IosevkaPatrick 16",
	fonticon = "Material Icons 16",
	mod = "Mod4",
	passwd = "",
	reboot = "systemctl reboot",
	sessionlock = false,
	shotdir = "~/Pictures/Screenshots",
	shutdown = "systemctl poweroff",
	terminal = "wezterm",
	wallpaper = "~/dotfiles/config/awesome/color/darkearth/darkearth.png"
}

-- Config

require("awful.autofocus")
require("signal")
require("config")
require("theme")
require("color.desktop")

-- Autostart

local autostart = {
	"picom",
	"xsettingsd",
	"nm-applet",
	"/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1",
}

for _, command in ipairs(autostart) do
	require("awful").spawn.easy_async_with_shell(command)
end

-- Theme Init

awesome.emit_signal("live::reload")

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
gears.timer({
    timeout = 5,
    autostart = true,
    call_now = true,
    callback = function()
        collectgarbage("collect")
    end,
})
