-- theme plugins (set theme in options.lua)
local theme = {
    -- gruvbox light/dark
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = true,
    },

    -- gruvbox material
    {
        "sainnhe/gruvbox-material",
        priority = 1000,
        config = true,
    },
}

return theme
