-- statusline plugins
return {
    {
        -- nice statusline
        "nvim-lualine/lualine.nvim",

        opts = {
            options = {
                icons_enabled = false,
                theme = 'auto',
                component_separators = '|',
                section_separators = '',
            },
            -- winbar = {
            --     lualine_a = { "buffers" },
            --     lualine_z = { "hostname" },
            -- },
            sections = {
                lualine_b = {
                    {
                        "harpoon2",
                        padding = { left = 1, right = 0 },
                        indicators = { "h", "j", "k", "l" },
                        active_indicators = { "H", "J", "K", "L" },
                    },
                },
                lualine_c = {
                    {
                        "filename",
                        padding = 1,
                    },
                },
                lualine_x = { "diagnostics", "diff" },
                lualine_y = { "branch" },
            },
        },
    },

    -- harpoon status plugin
    {
        "letieu/harpoon-lualine",
        dependencies = {
            "ThePrimeagen/harpoon",
            branch = "harpoon2",
        },
    }
}
