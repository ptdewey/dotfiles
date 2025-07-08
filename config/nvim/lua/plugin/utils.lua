return {
    {
        -- "ptdewey/deez-nvim",
        dir = "~/projects/deez-nvim",
        keys = {
            { "<leader>gb", desc = "[G]it [B]rowse" },
            { "<leader>tf", desc = "Open Al[T]ernate [F]ile" },
        },
        cmd = { "GitBrowse", "AltFile" },
        config = function()
            require("deez").setup({
                load_all = true,
            })

            vim.keymap.set("n", "<leader>gb", function()
                require("deez.gitbrowse").open()
            end, { desc = "Open current Git repository in browser" })

            vim.keymap.set("n", "<leader>tf", function()
                require("deez.altfile").open()
            end, { desc = "Open alternate file" })

            vim.api.nvim_create_user_command("GitBrowse", function()
                require("deez.gitbrowse").open()
            end, { desc = "Open current Git repository in browser" })

            vim.api.nvim_create_user_command("AltFile", function()
                require("deez.altfile").open()
            end, { desc = "Open alternate file" })
        end,
    },
}
