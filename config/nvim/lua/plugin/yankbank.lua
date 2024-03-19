-- yank history popup window plugin
return {
    {
        -- dir = "~/Documents/projects/yankbank-nvim",
        "ptdewey/yankbank-nvim",

        event = "VeryLazy",

        config = function()
            require("yankbank").setup({
                sep = "------",
                max_entries = 10,
            })
            vim.keymap.set("n", "<leader>p", ":YankBank<CR>",
                { noremap = true, silent = true })
        end,
    },
}

