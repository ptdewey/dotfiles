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
    -- front_end = "OpenGL",
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
}

-- colors
config.colors = {
    cursor_bg = "silver",
}

-- window padding
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

return config
