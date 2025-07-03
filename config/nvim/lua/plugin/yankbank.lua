--  # Define your hostname. yank history popup window plugin

return {
    {
        -- dir = "~/projects/yankbank-nvim.git/main",
        -- dir = "~/projects/yankbank-nvim.git/feat-lua-api",
        "ptdewey/yankbank-nvim",
        branch = "main",
        -- branch = "feat-lua-api",

        dependencies = {
            "kkharji/sqlite.lua",
        },

        -- load on keypress
        keys = {
            "y",
            { "Y", "y$" }, -- redefine Y behavior to y$ to avoid breaking lazy
            { "D" },
            { "d" },
            { "x" },
            { "v" },
            { "V" },
            { "<leader>p", desc = "Open YankBank" },
            { "<leader>y", desc = "Paste from YankBank by index" },
        },

        cmd = { "YankBank" },
        event = { "FocusGained" },

        config = function()
            -- band-aid solution for working with nix
            vim.g.sqlite_clib_path =
                "/run/current-system/sw/share/nix-ld/lib/libsqlite3.so"

            require("yankbank").setup({
                sep = "------",
                max_entries = 9,
                -- num_behavior = "prefix",
                num_behavior = "jump",
                focus_gain_poll = true,
                keymaps = {},
                persist_type = "sqlite",
                debug = true,
                bind_indices = "<leader>y",
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
