-- theme plugins (set theme in options.lua)
return {
    -- darkearth
    {
        "ptdewey/darkearth-nvim",
        -- dir = "~/projects/darkearth-nvim",
        priority = 1000,
    },

    -- gruvbox material
    -- {
    --     "sainnhe/gruvbox-material",
    --     priority = 1000,
    -- },

    -- everforest
    -- {
    --     "neanias/everforest-nvim",
    --     priority = 1000,
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
