---@diagnostic disable: missing-fields
-- theme plugins (set theme in options.lua)
return {
    -- darkearth
    {
        "ptdewey/darkearth-nvim",
        -- dir = "~/projects/darkearth-nvim",
        -- dev = true,
        priority = 1000,
    },

    {
        "ptdewey/monalisa-nvim",
        -- dir = "~/projects/monalisa-nvim/",
        priority = 1000,
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
    -- { "savq/melange-nvim", priority = 1000 },
    -- { "ramojus/mellifluous.nvim", priority = 1000 },
    -- { "ficcdaf/ashen.nvim", priority = 1000 },
    -- {
    --     "vague2k/vague.nvim",
    --     config = function()
    --         require("vague").setup({
    --             style = {
    --                 boolean = "none",
    --                 number = "none",
    --                 float = "none",
    --                 error = "none",
    --                 comments = "none",
    --                 conditionals = "none",
    --                 functions = "none",
    --                 headings = "none",
    --                 operators = "none",
    --                 strings = "none",
    --                 variables = "none",
    --
    --                 -- keywords
    --                 keywords = "none",
    --                 keyword_return = "none",
    --                 keywords_loop = "none",
    --                 keywords_label = "none",
    --                 keywords_exception = "none",
    --
    --                 -- builtin
    --                 builtin_constants = "none",
    --                 builtin_functions = "none",
    --                 builtin_types = "none",
    --                 builtin_variables = "none",
    --             },
    --         })
    --     end,
    -- },

    {
        "ptdewey/witchesbrew.nvim",
        priority = 1000,
    },

    -- {
    --     "sho-87/kanagawa-paper.nvim",
    --     priority = 1000,
    --     config = function()
    --         require("kanagawa-paper").setup({
    --             undercurl = false,
    --             commentStyle = { italic = false },
    --             functionStyle = { italic = false },
    --             keywordStyle = { italic = false },
    --         })
    --     end,
    -- },

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
