-- yank history popup window plugin
return {
    {
        -- dir = "~/projects/yankbank-nvim.git/main",
        "ptdewey/yankbank-nvim",
        branch = "main",

        dependencies = {
            "kkharji/sqlite.lua",
        },

        -- load on keypress
        keys = {
            { "y" },
            { "Y" },
            { "D" },
            { "d" },
            { "x" },
            { "v" },
            { "V" },
            { "<leader>p", desc = "Open YankBank" },
        },

        cmd = { "YankBank" },

        event = { "FocusGained" },

        config = function()
            require("yankbank").setup({
                sep = "------",
                max_entries = 9,
                -- num_behavior = "prefix",
                num_behavior = "jump",
                focus_gain_poll = true,
                keymaps = {},
                persist_type = "sqlite",
                debug = true,
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
