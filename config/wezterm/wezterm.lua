-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = {
    -- force_reverse_video_cursor = true,

    -- font settings
    font = wezterm.font("IosevkaPatrick"),
    -- font_size = 13.0,
    -- font_size = 18,
    font_size = 21,
    -- dpi = 144, -- commenting this out fixes the weird tiling wm scaling issue

    -- set rendering device
    enable_wayland = false,
    -- front_end = "OpenGL",
    front_end = "WebGpu",
    -- webgpu_power_preference = "HighPerformance",

    -- hide tab bar
    hide_tab_bar_if_only_one_tab = true,

    -- window_decorations = "RESIZE",
    window_decorations = "INTEGRATED_BUTTONS|RESIZE",
    window_close_confirmation = "NeverPrompt",
    adjust_window_size_when_changing_font_size = false,
    use_fancy_tab_bar = false,
    -- window_background_opacity = 0.98,
    set_environment_variables = {},

    -- colors
    colors = {
        cursor_bg = "silver",
    },

    -- window padding
    window_padding = {
        left = 5,
        right = 5,
        top = 10,
        bottom = 3,
    },

    tiling_desktop_environments = {
        "X11 bspwm",
        "X11 i3",
        "X11 awesome",
        "Wayland sway",
        "Wayland hyprland",
        "Wayland niri",
    },
}

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
    local title = tab_info.tab_title
    -- if the tab title is explicitly set, take that
    if title and #title > 0 then
        return title
    end
    -- Otherwise, use the title from the active pane
    -- in that tab
    return tab_info.active_pane.title
end

wezterm.on(
    "format-tab-title",
    function(tab, tabs, panes, config, hover, max_width)
        local background = "transparent"
        local foreground = "#808080"

        if tab.is_active then
            background = "transparent"
            foreground = "#c0c0c0"
        elseif hover then
            foreground = "#909090"
        end

        local title = tab_title(tab)
        title = wezterm.truncate_right(title, max_width - 2)

        return {
            { Background = { Color = background } },
            { Foreground = { Color = foreground } },
            { Text = " " },
            { Background = { Color = background } },
            { Foreground = { Color = foreground } },
            { Text = title },
            { Background = { Color = background } },
            { Foreground = { Color = foreground } },
            { Text = " " },
        }
    end
)

-- os specific configurations
if package.config:sub(1, 1) == "\\" then
    -- windows
    local windows = require("windows")
    windows.apply_to_config(config)
else
    -- TODO:
end

return config
