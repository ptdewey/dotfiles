-- terminal window plugin
return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                size = 20 or function(term)
                    if term.director == "horizontal" then
                        return 15
                    elseif term.director == "vertical" then
                        return vim.o.columns * 0.4
                    end
                end,
            })
        end,

        -- terminal toggle bind
        vim.keymap.set(
            { "n", "t" },
            "<A-m>",
            "<cmd>ToggleTerm direction=horizontal<CR>",
            { desc = "Toggle horizontal terminal" }
        ),

        -- terminal toggle bind
        vim.keymap.set(
            { "n", "t" },
            "<A-n>",
            "<cmd>ToggleTerm direction=float<CR>",
            { desc = "Toggle floating terminal" }
        ),
    },
}
