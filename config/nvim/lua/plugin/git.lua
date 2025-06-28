-- Git-related plugins
return {
    {
        "ptdewey/gitbrowse-nvim",
        opts = {},
    },

    -- git integration
    {
        "tpope/vim-fugitive",
        keys = {
            {
                "<leader>gv",
                "<cmd>Gdiff<CR>",
                silent = true,
                desc = "View Git diff",
            },
            {
                "<leader>gs",
                "<cmd>Git<CR>",
                silent = true,
                desc = "View Git status",
            },
            {
                "<leader>gl",
                "<cmd>Gclog<CR>",
                silent = true,
                desc = "View Git commit log",
            },
        },
    },

    -- add git signs to gutter
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost" },

        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "+" },
                    change = { text = "~" },
                    delete = { text = "-" },
                    topdelete = { text = "-" },
                    changedelete = { text = "~" },
                    untracked = { "/" },
                },
                signs_staged = {
                    add = { text = "+" },
                    change = { text = "~" },
                    delete = { text = "-" },
                    topdelete = { text = "-" },
                    changedelete = { text = "~" },
                    untracked = { "/" },
                },
                signs_staged_enable = true,
            })
        end,
    },
}
