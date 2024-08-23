-- yank history popup window plugin
return {
    {

        -- dir = "~/projects/yankbank-nvim.git/feature-4-persistence",
        "ptdewey/yankbank-nvim",
        -- branch = "main",

        dependencies = {
            "kkharji/sqlite.lua",
        },

        -- load on keypress
        keys = {
            { "<leader>p", desc = "Open YankBank" },
        },

        config = function()
            require("yankbank").setup({
                sep = "------",
                max_entries = 9,
                -- num_behavior = "prefix",
                num_behavior = "jump",
                focus_gain_poll = true,
                keymaps = {
                    -- navigation_next = "h",
                    -- navigation_prev = "l",
                },
                -- persist_type = "sqlite",
            })

            -- set popup keymap
            vim.keymap.set(
                "n",
                "<leader>p",
                "<cmd>YankBank<CR>",
                { noremap = true, desc = "Open YankBank" }
            )
        end,
    },
}
