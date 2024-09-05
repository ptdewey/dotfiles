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
        -- "cat /sys/class/power_supply/" .. user.batt .. "/capacity",
        "acpi | sed -n 's/.* \\([0-9]\\{1,3\\}%\\).* \\([0-9]\\{2\\}:[0-9]\\{2\\}\\):[0-9]\\{2\\}.*/\\1 - \\2/p'",
        function(stdout)
            -- local battery_capacity = tonumber(stdout:match("%d+"))
            local battery_capacity = stdout

            if battery_capacity then
                battery_widget.text = "Battery: " .. battery_capacity .. "%"
            else
                battery_widget.text = "Battery: N/A"
            end
        end
    )
end

gears.timer({
    timeout = 20,
    autostart = true,
    callback = update_battery,
})

update_battery()

return battery_widget
