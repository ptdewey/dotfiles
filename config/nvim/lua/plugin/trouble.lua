return {
    {
        "folke/trouble.nvim",
        event = "VeryLazy",
        config = function()
            require("trouble").setup({})

            vim.keymap.set("n", "<leader>to", function()
                require("trouble").toggle()
            end, { desc = "[T]rouble T[o]ggle" })

            -- vim.keymap.set("n", "<leader>to", function()
            --     require("trouble").toggle("todo")
            -- end, { desc = "[T]rouble T[o]do" })

            vim.keymap.set("n", "<leader>td", function()
                require("trouble").toggle("diagnostics")
            end, { desc = "[T]rouble [D]iagnostics" })

            vim.keymap.set("n", "<leader>tb", function()
                require("trouble").toggle({
                    mode = "diagnostics",
                    filter = { buf = 0 },
                })
            end, { desc = "[T]rouble [B]uffer Diagnostics" })
        end,
    },
}
