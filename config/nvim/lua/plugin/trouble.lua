return {
    {
        "folke/trouble.nvim",
        event = "VeryLazy",
        config = function()
            require("trouble").setup({})

            vim.keymap.set("n", "<leader>tt", function()
                require("trouble").toggle()
            end)

            vim.keymap.set("n", "<leader>to", function()
                require("trouble").toggle("todo")
            end)

            vim.keymap.set("n", "<leader>td", function()
                require("trouble").toggle("diagnostics")
            end)

            vim.keymap.set("n", "<leader>tb", function()
                require("trouble").toggle({
                    mode = "diagnostics",
                    filter = { buf = 0 },
                })
            end)
        end,
    },
}
