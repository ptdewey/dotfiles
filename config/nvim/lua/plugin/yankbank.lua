-- yank history popup window plugin
return {
    {
        -- dir = "~/projects/yankbank-nvim",
        "ptdewey/yankbank-nvim",
        branch = "main",

        event = "VeryLazy",

        config = function()
            require("yankbank").setup({
                sep = "------",
                max_entries = 10,
                -- num_behavior = "prefix",
                num_behavior = "jump",
                focus_gain_poll = true,
                keymaps = {
                    -- navigation_next = "h",
                    -- navigation_prev = "l",
                },
            })

            -- set popup keymap
            vim.keymap.set("n", "<leader>p", "<cmd>YankBank<CR>",
                { noremap = true })
        end,
    },
}
