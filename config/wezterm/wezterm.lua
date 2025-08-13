-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- force_reverse_video_cursor = true,

-- font settings
config.font = wezterm.font("IosevkaPatrick Nerd Font")
config.font_size = 18 -- (1080p) will be overridden later

-- set rendering device
config.enable_wayland = true
-- config.front_end = "OpenGL"
config.front_end = "WebGpu"
-- config.webgpu_power_preference = "HighPerformance"

-- hide tab bar
config.hide_tab_bar_if_only_one_tab = true

-- window_decorations = "RESIZE",
config.window_decorations = "TITLE|RESIZE"
-- window_decorations = "NONE",
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.use_fancy_tab_bar = false
-- window_background_opacity = 0.98,
config.set_environment_variables = {}

config.warn_about_missing_glyphs = false

-- colors
config.colors = {
    cursor_bg = "silver",
}

-- window padding
config.window_padding = {
    left = 5,
    right = 5,
    top = 10,
    bottom = 3,
}

config.tiling_desktop_environments = {
    "X11 bspwm",
    "X11 i3",
    "X11 awesome",
    "Wayland sway",
    "Wayland hyprland",
    "Wayland niri",
}

config.color_scheme = "MonaLisa"

-- Font size overrides
wezterm.on("window-resized", function(window, _)
    local window_dims = window:get_dimensions()
    local h = window_dims.pixel_height

    local font_size
    if h >= 1380 then
        font_size = 23
        -- font_size = 22
        -- font_size = 20
    elseif h >= 1080 then
        font_size = 18
    else
        font_size = 16
    end

    local overrides = window:get_config_overrides() or {}
    overrides.font_size = font_size
    config.font_size = font_size
    window:set_config_overrides(overrides)
end)

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
    local title = tab_info.tab_title
    -- if the tab title is explicitly set, take that
    if title and #title > 0 then return title end
    -- Otherwise, use the title from the active pane
    -- in that tab
    return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, _, _, _, hover, max_width)
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
end)

-- os specific configurations
if tostring(package.config):sub(1, 1) == "\\" then
    -- windows
    local windows = require("windows")
    windows.apply_to_config(config)
end

return config
