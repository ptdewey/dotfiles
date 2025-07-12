return {
    -- {
    --     "tpope/vim-fugitive",
    --     -- cmd = { "Git" },
    --     keys = {
    --         {
    --             "<leader>gv",
    --             "<cmd>Gdiff<CR>",
    --             silent = true,
    --             desc = "View Git diff",
    --         },
    --         {
    --             "<leader>gl",
    --             "<cmd>Gclog<CR>",
    --             silent = true,
    --             desc = "View Git commit log",
    --         },
    --     },
    -- },

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
