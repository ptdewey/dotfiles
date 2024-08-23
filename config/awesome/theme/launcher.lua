local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local Gio = require("lgi").Gio
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local appicons = "/usr/share/icons/" .. beautiful.icons .. "/64x64/apps/"

-- Widgets

local launcherbox = wibox({
    width = dpi(395),
    height = dpi(470),
    ontop = true,
    visible = false,
})

local prompt = colortext()

local entries = wibox.widget({
    homogeneous = false,
    expand = true,
    forced_num_cols = 1,
    layout = wibox.layout.grid,
})

local settings = button({
    run = function()
        awesome.emit_signal("widget::launcher")
        awesome.emit_signal("widget::config")
    end,
})

local shutdown = button({
    type = "text",
    image = "",
    run = function()
        awful.spawn.with_shell(user.shutdown)
    end,
})

local reboot = button({
    type = "text",
    image = "",
    run = function()
        awful.spawn.with_shell(user.reboot)
    end,
})

local exit = button({
    type = "text",
    image = "",
    run = function()
        awesome.emit_signal("widget::launcher")
        awesome.quit()
    end,
})

local lock = button({
    type = "text",
    image = "",
    run = function()
        awesome.emit_signal("widget::launcher")
        awesome.emit_signal("widget::lockscreen")
    end,
})

launcherbox:setup({
    {
        {
            {
                settings,
                nil,
                {
                    shutdown,
                    reboot,
                    exit,
                    lock,
                    spacing = dpi(10),
                    layout = wibox.layout.fixed.vertical,
                },
                layout = wibox.layout.align.vertical,
            },
            {
                entries,
                nil,
                {
                    {
                        prompt,
                        margins = dpi(10),
                        widget = wibox.container.margin,
                    },
                    shape = function(cr, width, height)
                        gears.shape.rounded_rect(cr, width, height, dpi(10))
                    end,
                    widget = live(wibox.container.background, { bg = "bgmid" }),
                },
                forced_width = dpi(350),
                layout = wibox.layout.align.vertical,
            },
            spacing = dpi(10),
            layout = wibox.layout.fixed.horizontal,
        },
        margins = dpi(10),
        widget = wibox.container.margin,
    },
    widget = live(wibox.container.background, { bg = "bg" }),
})

-- Functions

local function next()
    if entryindex ~= #filtered then
        entries:get_widgets_at(entryindex, 1)[1].bg = nil
        entries:get_widgets_at(entryindex + 1, 1)[1].bg = beautiful.bgmid
        entryindex = entryindex + 1
        if entryindex > startindex + 9 then
            entries:get_widgets_at(entryindex - 10, 1)[1].visible = false
            entries:get_widgets_at(entryindex, 1)[1].visible = true
            startindex = startindex + 1
        end
    end
    move = true
end

local function back()
    if entryindex ~= 1 then
        entries:get_widgets_at(entryindex, 1)[1].bg = nil
        entries:get_widgets_at(entryindex - 1, 1)[1].bg = beautiful.bgmid
        entryindex = entryindex - 1
        if entryindex < startindex then
            entries:get_widgets_at(entryindex + 10, 1)[1].visible = false
            entries:get_widgets_at(entryindex, 1)[1].visible = true
            startindex = startindex - 1
        end
    end
    move = true
end

local function gen()
    local entries = {}
    for _, entry in ipairs(Gio.AppInfo.get_all()) do
        if entry:should_show() then
            local name = entry:get_name():gsub("&", "&amp;"):gsub("<", "&lt;"):gsub("'", "&#39;")
            local icon = entry:get_icon()
            if icon then
                local name = icon:to_string()
                icon = appicons .. name .. ".svg"
                local function exists(file)
                    local file = io.open(file, "r")
                    if file ~= nil then
                        io.close(file)
                        return true
                    else
                        return false
                    end
                end
                if exists(icon) then
                    icon = appicons .. name .. ".svg"
                else
                    icon = appicons .. "application-default-icon.svg"
                end
            else
                icon = appicons .. "application-default-icon.svg"
            end
            table.insert(entries, { icon = icon, name = name, appinfo = entry })
        end
    end
    return entries
end

local function filter(cmd)
    filtered = {}
    regfiltered = {}

    -- Filter entries

    for _, entry in ipairs(unfiltered) do
        if entry.name:lower():sub(1, cmd:len()) == cmd:lower() then
            table.insert(filtered, entry)
        elseif entry.name:lower():match(cmd:lower()) then
            table.insert(regfiltered, entry)
        end
    end

    -- Sort entries

    table.sort(filtered, function(a, b)
        return a.name:lower() < b.name:lower()
    end)
    table.sort(regfiltered, function(a, b)
        return a.name:lower() < b.name:lower()
    end)

    -- Merge entries

    for i = 1, #regfiltered do
        filtered[#filtered + 1] = regfiltered[i]
    end

    -- Clear entries

    entries:reset()

    -- Fix position

    entryindex, startindex = 1, 1

    -- Add filtered entries

    for i, entry in ipairs(filtered) do
        local widget = hovercursor(wibox.widget({
            {
                {
                    wibox.widget.imagebox(entry.icon),
                    colortext({ text = entry.name }),
                    spacing = dpi(5),
                    layout = wibox.layout.fixed.horizontal,
                },
                forced_height = dpi(40),
                margins = dpi(10),
                widget = wibox.container.margin,
            },
            buttons = {
                awful.button({}, 1, function()
                    if entryindex == i then
                        local entry = filtered[entryindex]
                        entry.appinfo:launch()
                        awful.keygrabber.stop()
                        launcherbox.visible = false
                    else
                        entries:get_widgets_at(entryindex, 1)[1].bg = nil
                        entryindex = i
                        entries:get_widgets_at(entryindex, 1)[1].bg = beautiful.bgmid
                    end
                end),
                awful.button({}, 4, function()
                    back()
                end),
                awful.button({}, 5, function()
                    next()
                end),
            },
            id = "background_role",
            shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, dpi(10))
            end,
            widget = wibox.container.background,
        }))

        if startindex <= i and i <= startindex + 9 then
            widget.visible = true
        else
            widget.visible = false
        end

        entries:add(widget)

        if i == entryindex then
            widget.bg = beautiful.bgmid
        end
    end

    collectgarbage("collect")
end

local function open()
    -- Reset variables

    startindex, entryindex, move = 1, 1, false

    -- Get entries

    unfiltered = gen() -- TODO: Make this local
    filter("")

    -- Prompt

    awful.prompt.run({
        prompt = markup({ text = "Launch " }),
        textbox = prompt,
        done_callback = function()
            launcherbox.visible = false
        end,
        changed_callback = function(cmd)
            if move == false then
                filter(cmd)
            else
                move = false
            end
        end,
        exe_callback = function(cmd)
            local entry = filtered[entryindex]
            if entry then
                entry.appinfo:launch()
            else
                awful.spawn.with_shell(cmd)
            end
        end,
        keypressed_callback = function(_, key)
            if key == "Down" then
                next()
            elseif key == "Up" then
                back()
            end
        end,
    })
end

awesome.connect_signal("widget::launcher", function()
    awesome.emit_signal("widget::preview:hide")

    launcherbox.visible = not launcherbox.visible

    if launcherbox.visible then
        open()
    else
        awful.keygrabber.stop()
    end

    if client.focus and client.focus.fullscreen == true then
        awful.placement.bottom_left(launcherbox, {
            margins = {
                bottom = dpi(16),
                left = dpi(16),
            },
            parent = awful.screen.focused(),
        })
    else
        awful.placement.bottom_left(launcherbox, {
            margins = {
                bottom = dpi(56),
                left = dpi(16),
            },
            parent = awful.screen.focused(),
        })
    end
end)

awesome.connect_signal("widget::launcher:hide", function()
    launcherbox.visible = false
    awful.keygrabber.stop()
end)
