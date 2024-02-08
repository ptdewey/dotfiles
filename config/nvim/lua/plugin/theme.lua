-- theme plugins (set theme in options.lua)
local theme = {
    -- gruvbox light/dark
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme 'gruvbox'
        end,
    },

    -- gruvbox material
    {
        "sainnhe/gruvbox-material",
        priority = 1000,
        config = function() 
            vim.cmd.colorscheme 'gruvbox-material'
        end,
    },

    -- everforest
    {
        "neanias/everforest-nvim",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme 'everforest'
        end,
    },
}

return theme
