-- Git-related plugins
return {
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
            {
                "<leader>gb",
                "<cmd>GBrowse<CR>",
                silent = true,
                desc = "View Current Repository in Browser",
            },
        },
        dependencies = {
            -- also load vim-rhubarb when lazy loading
            "tpope/vim-rhubarb",
        },
    },

    -- github integration
    {
        "tpope/vim-rhubarb",
        lazy = true,
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
