return {
    {
        "ptdewey/deez-nvim",
        branch = "feat-explorer",
        -- dir = "~/projects/deez-nvim/",
        keys = {
            { "<leader>gb", desc = "[G]it [B]rowse" },
            { "<leader>tf", desc = "Open Al[T]ernate [F]ile" },
            { mode = "x",   "<leader>wc",                    desc = "[W]ord [C]ount" },
            { "<leader>nn", desc = "File Explorer" },
            { "<C-n>",      desc = "File Explorer" },
        },
        cmd = { "GitBrowse", "RenameFile" },
        config = function()
            require("deez.gitbrowse").setup({})
            require("deez.altfile").setup({})
            require("deez.wordcount").setup({})
            require("deez.rename").setup({})
            require("deez.files").setup({
                keys = { toggle = { key = "<C-n>" }, },
                open_in_current_dir = true,
            })

            vim.keymap.set("n", "<leader>nn", function()
                require("deez.files").open({ open_in_current_dir = false })
            end, { desc = "File Explorer" })

            vim.keymap.set("n", "<leader>gb", function()
                require("deez.gitbrowse").open()
            end, { desc = "Open current Git repository in browser" })

            vim.keymap.set("n", "<leader>tf", function()
                require("deez.altfile").open()
            end, { desc = "Open alternate file" })

            vim.api.nvim_create_user_command("GitBrowse", function()
                require("deez.gitbrowse").open()
            end, { desc = "Open current Git repository in browser" })
        end,
    },
}
