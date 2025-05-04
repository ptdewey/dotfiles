-- statusline plugins
return {
    -- harpoon status plugin
    {
        "letieu/harpoon-lualine",
        lazy = true,
        dependencies = {
            "ThePrimeagen/harpoon",
            branch = "harpoon2",
        },
    },
    {
        -- nice statusline
        "ptdewey/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            "letieu/harpoon-lualine",
            -- "nvim-tree/nvim-web-devicons",
        },
        opts = {
            options = {
                icons_enabled = false,
                theme = "auto",
                component_separators = "|",
                section_separators = "",
                disabled_filetypes = {
                    statusline = {
                        "undotree",
                        "diff",
                    },
                },
            },
            sections = {
                lualine_b = {
                    {
                        "harpoon2",
                        icon = "",
                        padding = { left = 1, right = 1 },
                        -- indicators = { "h", "j", "k", "l" },
                        -- active_indicators = { "H", "J", "K", "L" },
                        indicators = { "j", "k", "l" },
                        active_indicators = { "J", "K", "L" },
                        no_harpoon = "Harpoon not loaded",
                    },
                },
                lualine_c = {
                    { "filename", path = 5, padding = 1 },
                },
                lualine_x = { "diagnostics", "diff" },
                lualine_y = { "branch" },
            },
        },
    },
}
