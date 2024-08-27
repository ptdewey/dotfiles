local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local battery_widget = wibox.widget({
    widget = wibox.widget.textbox,
    align = "center",
    valign = "center",
    font = "IosevkaPatrick Nerd Font 14",
})

local function update_battery()
    awful.spawn.easy_async_with_shell(
        "cat /sys/class/power_supply/" .. user.batt .. "/capacity",
        function(stdout)
            local battery_capacity = tonumber(stdout:match("%d+"))

            if battery_capacity then
                battery_widget.text = "Battery: " .. battery_capacity .. "%"
            else
                battery_widget.text = "Battery: N/A"
            end
        end
    )
end

gears.timer({
    timeout = 15,
    autostart = true,
    callback = update_battery,
})

update_battery()

return battery_widget
