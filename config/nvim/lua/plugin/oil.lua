return {
    {
        "stevearc/oil.nvim",
        dependencies = { "echasnovski/mini.nvim" },
        -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
        -- lazy = false,
        keys = { "-", "<C-n>" },
        cmd = { "Oil" },
        config = function()
            require("oil").setup({
                keymaps = {
                    ["<C-n>"] = { "actions.close", mode = "n" },
                }
            })
            vim.keymap.set("n", "-", require("oil").open, {})
            vim.keymap.set("n", "<C-n>", require("oil").open, {})
        end,
    }
}
