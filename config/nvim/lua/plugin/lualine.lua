-- Nice statusline
return {
    {
        "nvim-lualine/lualine.nvim",

        opts = {
            options = {
                icons_enabled = false,
                theme = 'auto',
                component_separators = '|',
                section_separators = '',
            },
            sections = {
                -- center section
                lualine_b = {
                    { "harpoon2", },
                },
                lualine_c = {
                    {
                        "filename",
                        padding = 0,
                    },
                },
                lualine_x = {},
                lualine_y = {
                    "diagnostics", "diff", "branch", "filetype",
                },
            },
        },
    },

    {
        "letieu/harpoon-lualine",
        dependencies = {
            "ThePrimeagen/harpoon",
            branch = "harpoon2"
        }
    }
}
