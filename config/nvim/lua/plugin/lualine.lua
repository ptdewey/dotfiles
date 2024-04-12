-- statusline plugins
return {
    -- harpoon status plugin
    {
        "letieu/harpoon-lualine",
        dependencies = {
            "ThePrimeagen/harpoon",
            branch = "harpoon2",
        },
    },
    {
        -- nice statusline
        "nvim-lualine/lualine.nvim",
        dependencies =  {
            "letieu/harpoon-lualine",
            -- "nvim-tree/nvim-web-devicons",
        },

        opts = {
            options = {
                icons_enabled = false,
                theme = 'auto',
                component_separators = '|',
                section_separators = '',
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
                        padding = { left = 1, right = 0 },
                        indicators = { "h", "j", "k", "l" },
                        active_indicators = { "H", "J", "K", "L" },
                        no_harpoon = "Harpoon not loaded",
                    },
                },
                lualine_c = {
                    { "filename", padding = 1, },
                },
                lualine_x = { "diagnostics", "diff" },
                -- lualine_y = { "filetype" },
                lualine_y = { "branch" },
                -- lualine_z = { "filetype" },
            },

            -- bufferline replacement
            -- winbar = {
            --     lualine_c = {
            --         {
            --             "buffers",
            --             buffers_color = {
            --                 active = "lualine_b_normal",
            --                 inactive = "lualine_c_normal",
            --             },
            --             symbols = {
            --                 alternate_file = "",
            --             },
            --         },
            --     },
            --     lualine_y = { "hostname"},
            -- },
        },
    },
}
