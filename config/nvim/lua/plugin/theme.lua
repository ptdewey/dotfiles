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

    -- biscuit
    {
        "Biscuit-Colorscheme/nvim",
        priority = 1000,
        config = true,
    },

    -- everforest
    {
        "neanias/everforest-nvim",
        priority = 1000,
        -- config = true,
    },

    -- {
    --     -- Theme inspired by Atom
    --     'navarasu/onedark.nvim',
    --     priority = 1000,
    --     config = function()
    --         vim.cmd.colorscheme 'onedark'
    --     end,
    -- },
}

return theme
