-- yank history popup window plugin
return {
    {
        -- dir = "~/Documents/projects/yankbank-nvim",
        "ptdewey/yankbank-nvim",
        branch = "main",

        event = "VeryLazy",

        config = function()
            require("yankbank").setup({
                sep = "------",
                max_entries = 10,
                -- num_behavior = "prefix",
                num_behavior = "jump",
                keymaps = {
                    -- navigation_next = "h",
                    -- navigation_prev = "l",
                },
            })
            vim.keymap.set("n", "<leader>p", "<cmd>YankBank<CR>",
                { noremap = true })
        end,

    },
}
