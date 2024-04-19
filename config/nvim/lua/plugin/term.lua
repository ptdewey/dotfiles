-- terminal window plugin
return {
    -- {
    --     "ptdewey/nvterm",
    --
    --     -- only load when requested
    --     lazy = true,
    --
    --     -- plugin setup
    --     config = function ()
    --         require("nvterm").setup({
    --             behavior = {
    --                 -- go into term-insert mode upon opening terminal
    --                 auto_insert = true,
    --             },
    --         })
    --     end,
    --
    --     -- terminal toggle bind
    --     vim.keymap.set(
    --         { "n", "t" },
    --         "<A-m>",
    --         function ()
    --             require("nvterm.terminal").toggle "horizontal"
    --         end
    --     ),
    -- },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = true,

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
