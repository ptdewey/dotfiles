-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = {
    force_reverse_video_cursor = true,

    -- font settings
    font = wezterm.font("IosevkaPatrick Nerd Font"),
    font_size = 13.0,

    -- hide tab bar
    hide_tab_bar_if_only_one_tab = true,

    -- set rendering device
    -- enable_wayland = true,
    front_end = "OpenGL",
    -- front_end = "WebGpu",
    -- webgpu_preferred_adapter = {
    --     backend = "Vulkan",
    --     -- backend = "Gl",
    --     -- device_type = "Cpu",
    --     -- name  = "llvmpipe (LLVM 15.0.7, 256 bits)",
    --     device_type = "DiscreteGpu",
    --     name = "NVIDIA GeForce RTX 3060 Ti"
    -- },
    -- webgpu_power_preference = "HighPerformance",

    -- window_decorations = "RESIZE",
    window_decorations = "TITLE|RESIZE",
}

config.set_environment_variables = {}

-- colors
config.colors = {
    cursor_bg = "silver",
}

-- window padding
config.window_padding = {
    left = 2,
    right = 2,
    top = 0,
    bottom = 0,
}

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
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
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local edge_background = 'black'
    local background = 'black'
    local foreground = '#808080'

    if tab.is_active then
      background = '#2b2042'
      foreground = '#c0c0c0'
    elseif hover then
      background = '#3b3052'
      foreground = '#909090'
    end

    local edge_foreground = background

    local title = tab_title(tab)

    -- ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    title = wezterm.truncate_right(title, max_width - 2)

    return {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_LEFT_ARROW },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title },
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_RIGHT_ARROW },
    }
  end
)

-- os specific configurations
if package.config:sub(1,1) == "\\" then
    -- windows
    local windows = require("windows")
    windows.apply_to_config(config)
else
    -- unix
end

return config
