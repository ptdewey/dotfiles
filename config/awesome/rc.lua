pcall(require, "luarocks.loader")
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.screen.set_auto_dpi_enabled(true)

require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors,
    })
end

local user = {
    batt = "BAT1",
    browser = "firefox",
    file_manager = "nautilus",
    font = "IosevkaPatrick Nerd Font 16",
    fontalt = "IosevkaPatrick 16",
    fonticon = "Material Icons 16",
    mod = "Mod1",
    passwd = "",
    reboot = "systemctl reboot",
    sessionlock = false,
    shotdir = "~/Pictures/screenshots",
    shutdown = "systemctl poweroff",
    terminal = "kitty",
    wallpaper = "~/Pictures/wallpapers/gruvbox15.png",
}

awful.spawn.with_shell("feh --bg-fill " .. user.wallpaper)

do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        if in_error then
            return
        end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err),
        })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

terminal = "kitty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

awful.layout.layouts = {
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.tile,
    awful.layout.suit.floating,
}
-- }}}

-- {{{ Menu
myawesomemenu = {
    {
        "hotkeys",
        function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end,
    },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    {
        "quit",
        function()
            awesome.quit()
        end,
    },
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after = { menu_terminal },
    })
else
    mymainmenu = awful.menu({
        items = {
            menu_awesome,
            { "Debian", debian.menu.Debian_menu.Debian },
            menu_terminal,
        },
    })
end

mylauncher =
    awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

menubar.utils.terminal = terminal
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
mytextclock = wibox.widget.textclock()

local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({ mod }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ mod }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t)
        awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", { raise = true })
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end)
)

local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    awful.tag(
        { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
        s,
        awful.layout.layouts[1]
    )

    s.mypromptbox = awful.widget.prompt()
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function()
            awful.layout.inc(1)
        end),
        awful.button({}, 3, function()
            awful.layout.inc(-1)
        end),
        awful.button({}, 4, function()
            awful.layout.inc(1)
        end),
        awful.button({}, 5, function()
            awful.layout.inc(-1)
        end)
    ))

    s.mytaglist = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
    })

    s.mytasklist = awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
    })

    s.mywibox = awful.wibar({ position = "top", screen = s })

    s.mywibox:setup({
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    })
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(
    gears.table.join(
        awful.button({}, 3, function()
            mymainmenu:toggle()
        end),
        awful.button({}, 4, awful.tag.viewnext),
        awful.button({}, 5, awful.tag.viewprev)
    )
)
-- }}}

-- {{{ Key bindings
local mod = user.mod
-- Mouse bindings for clients
client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        -- Move
        awful.button({ mod }, 1, function(c)
            c:activate({ context = "mouse_click", action = "mouse_move" })
        end),
        -- Resize
        awful.button({ mod }, 3, function(c)
            c:activate({ context = "mouse_click", action = "mouse_resize" })
        end),
    })
end)

-- Global keybindings
globalkeys = gears.table.join(
    -- Awesome controls
    awful.key(
        { mod, "Shift" },
        "r",
        awesome.restart,
        { description = "reload awesome", group = "awesome" }
    ),
    awful.key({ mod }, "r", function()
        awful.screen.focused().mypromptbox:run()
    end, { description = "run prompt", group = "launcher" }),
    awful.key({ mod }, "z", function()
        awful.layout.inc(1)
    end, { description = "next layout", group = "awesome" }),
    awful.key({ mod, "Shift" }, "z", function()
        awful.layout.inc(-1)
    end, { description = "previous layout", group = "awesome" }),

    -- Window focus
    awful.key({ mod }, "Tab", function()
        awful.client.focus.byidx(1)
    end, { description = "next window", group = "awesome" }),
    awful.key({ mod, "Shift" }, "Tab", function()
        awful.client.focus.byidx(-1)
    end, { description = "previous window", group = "awesome" }),

    -- Focus by direction
    awful.key({ mod }, "h", function()
        awful.client.focus.bydirection("left")
    end, { description = "focus left", group = "client" }),
    awful.key({ mod }, "j", function()
        awful.client.focus.bydirection("down")
    end, { description = "focus down", group = "client" }),
    awful.key({ mod }, "k", function()
        awful.client.focus.bydirection("up")
    end, { description = "focus up", group = "client" }),
    awful.key({ mod }, "l", function()
        awful.client.focus.bydirection("right")
    end, { description = "focus right", group = "client" }),

    -- Screen focus and movement
    awful.key(
        { mod, "Shift" },
        "o",
        awful.client.movetoscreen,
        { description = "move window between screens", group = "screen" }
    ),
    awful.key({ mod }, "Left", function()
        awful.screen.focus_bydirection("left")
    end, { description = "focus left screen", group = "screen" }),
    awful.key({ mod }, "Right", function()
        awful.screen.focus_bydirection("right")
    end, { description = "focus right screen", group = "screen" }),

    -- Programs
    awful.key({ mod }, "Return", function()
        awful.spawn.with_shell(user.terminal)
    end, { description = "open terminal", group = "programs" }),
    awful.key({ mod }, "b", function()
        awful.spawn.with_shell(user.browser)
    end, { description = "open browser", group = "programs" }),
    awful.key({ mod }, "n", function()
        awful.spawn(user.file_manager)
    end, { description = "open file manager", group = "programs" }),

    -- Screenshots
    awful.key({ mod }, "\\", function()
        awful.spawn.with_shell("screenshot -u")
    end, { description = "full screen screenshot", group = "screenshot" }),
    awful.key({ mod, "Control" }, "\\", function()
        awful.spawn.with_shell("screenshot -u -d 5")
    end, {
        description = "full screen screenshot with delay",
        group = "screenshot",
    }),
    awful.key({ mod, "Shift" }, "s", function()
        awful.spawn.with_shell("screenshot -s -u")
    end, { description = "partial screen screenshot", group = "screenshot" }),

    -- Volume control
    awful.key({}, "XF86AudioRaiseVolume", function()
        awful.spawn.with_shell(
            "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        )
    end, { description = "raise volume", group = "volume" }),
    awful.key({}, "XF86AudioLowerVolume", function()
        awful.spawn.with_shell(
            "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        )
    end, { description = "lower volume", group = "volume" }),
    awful.key({}, "XF86AudioMute", function()
        awful.spawn.with_shell("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
    end, { description = "mute volume", group = "volume" }),

    -- Brightness control
    awful.key({}, "XF86MonBrightnessUp", function()
        awful.spawn.with_shell("brightnessctl s 5%+")
    end, { description = "raise brightness", group = "brightness" }),
    awful.key({}, "XF86MonBrightnessDown", function()
        awful.spawn.with_shell("brightnessctl s 5%-")
    end, { description = "lower brightness", group = "brightness" })
)

-- Tag management
for i = 1, 9 do
    globalkeys = gears.table.join(
        globalkeys,
        -- View tag only.
        awful.key({ mod }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end, { description = "view tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key(
            { mod, "Shift" },
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }
        )
    )
end

-- Client keybindings
clientkeys = gears.table.join(
    awful.key({ mod }, "c", function(c)
        awful.placement.centered(c, { honor_workarea = true })
    end, { description = "center window", group = "client" }),
    awful.key({ mod }, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = "toggle fullscreen", group = "client" }),
    awful.key({ mod }, "y", function(c)
        c.floating = not c.floating
        c:raise()
    end, { description = "toggle floating", group = "client" }),
    awful.key({ mod }, "m", function(c)
        c.minimized = true
    end, { description = "minimize", group = "client" }),
    awful.key({ mod }, "g", function(c)
        c.maximized = not c.maximized
        c:raise()
    end, { description = "toggle maximize", group = "client" }),
    awful.key({ mod }, "q", function(c)
        c:kill()
    end, { description = "close", group = "client" })
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap
                + awful.placement.no_offscreen,
        },
    },
    {
        rule_any = {
            instance = {
                "DTA",
                "copyq",
                "pinentry",
            },
            class = {
                "Arandr",
                "Gpick",
                "Kruler",
                "MessageWin",
                "Sxiv",
                "Wpa_gui",
                "xtightvncviewer",
            },

            name = {
                "Event Tester",
            },
            role = {
                "AlarmWindow",
                "ConfigManager",
                "pop-up",
            },
        },
        properties = { floating = true },
    },

    {
        rule_any = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = false },
    },
}
-- }}}

-- {{{ Signals
client.connect_signal("manage", function(c)
    if
        awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position
    then
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("request::titlebars", function(c)
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c):setup({
        {
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal,
        },
        {
            {
                align = "center",
                widget = awful.titlebar.widget.titlewidget(c),
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal,
        },
        {
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal(),
        },
        layout = wibox.layout.align.horizontal,
    })
end)

client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)
-- }}}
