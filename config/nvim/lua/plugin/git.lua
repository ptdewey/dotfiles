-- Git-related plugins
return {
    {
        "ptdewey/gitbrowse-nvim",
        config = function()
            require("gitbrowse").setup({})

            -- Keymap
            vim.keymap.set("n", "<leader>gb", function()
                require("gitbrowse").open()
            end, { desc = "Open current Git repository in browser" })

            -- Command
            vim.api.nvim_create_user_command("GitBrowse", function()
                require("gitbrowse").open()
            end, { desc = "Open current Git repository in browser" })
        end
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
