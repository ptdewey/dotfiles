-- statusline plugins
return {
    {
        -- nice statusline
        "nvim-lualine/lualine.nvim",
        -- dir = "~/Documents/projects/fix/harpoon-lualine",

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
                        no_harpoon = "Harpoon not loaded",
                    },
                },
                lualine_c = {
                    {
                        "filename",
                        padding = 1,
                    },
                },
                lualine_x = { "diagnostics", "diff" },
                -- lualine_y = { "filetype" },
                lualine_y = { "branch" },
                -- lualine_z = { "filetype" },
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
