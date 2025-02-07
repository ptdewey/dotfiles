---@diagnostic disable: missing-fields
-- theme plugins (set theme in options.lua)
return {
    -- darkearth
    {
        "ptdewey/darkearth-nvim",
        -- dir = "~/projects/darkearth-nvim",
        priority = 1000,
    },

    {
        "thesimonho/kanagawa-paper.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("kanagawa-paper").setup({
                commentStyle = { italic = false },
                undercurl = false,
            })
        end,
    },

    -- gruvbox material
    -- { "sainnhe/gruvbox-material", priority = 1000 },

    -- everforest
    -- { "neanias/everforest-nvim", priority = 1000 },

    -- {
    --     "comfysage/evergarden",
    --     priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
    --     opts = {
    --         transparent_background = true,
    --         variant = "medium", -- 'hard'|'medium'|'soft'
    --         overrides = {}, -- add custom overrides
    --     },
    -- },
    {
        "vague2k/vague.nvim",
        config = function()
            require("vague").setup({
                -- optional configuration here
            })
        end,
    },

    {
        "sho-87/kanagawa-paper.nvim",
        priority = 1000,
        config = function()
            require("kanagawa-paper").setup({
                undercurl = false,
                commentStyle = { italic = false },
                functionStyle = { italic = false },
                keywordStyle = { italic = false },
            })
        end,
    },

    -- highlight color codes
    {
        "brenoprata10/nvim-highlight-colors",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("nvim-highlight-colors").setup({})
        end,
    },

    -- for designing colorschemes
    {
        "rktjmp/lush.nvim",
        cmd = "Lushify",
    },

    -- for building with lush
    {
        "rktjmp/shipwright.nvim",
        cmd = "Shipwright",
    },
}
