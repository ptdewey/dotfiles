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

local r = assert(io.open(".config/awesome/json/user.json", "r"))
local table = r:read("*all")
r:close()

user = require("json"):decode(table)

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
