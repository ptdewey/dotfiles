-- terminal window plugin
return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",

        keys = {
            { "<A-m>", desc = "Toggle horizontal terminal" },
            { "<A-n>", desc = "Toggle floating terminal" },
        },

        config = function()
            require("toggleterm").setup({
                size = 20 or function(term)
                    if term.direction == "horizontal" then
                        return 15
                    elseif term.direction == "vertical" then
                        return vim.o.columns * 0.4
                    end
                end,
            })

            -- terminal toggle bind for horizontal terminal
            vim.keymap.set({ "n", "t" }, "<A-m>", "<cmd>ToggleTerm direction=horizontal<CR>",
                { desc = "Toggle horizontal terminal" })

            -- terminal toggle bind for floating terminal
            vim.keymap.set({ "n", "t" }, "<A-n>", "<cmd>ToggleTerm direction=float<CR>",
                { desc = "Toggle floating terminal" })
        end,
    },
}
