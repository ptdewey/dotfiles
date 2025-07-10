return {
    {
        "ptdewey/lualine.nvim",
        event = "VeryLazy",
        -- dependencies = { "nvim-tree/nvim-web-devicons" },
        -- dependencies = { "echasnovski/mini.icons" },
        opts = {
            options = {
                icons_enabled = true,
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
                    { "grapple" },
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
