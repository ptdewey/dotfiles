-- yank history popup window plugin
return {
    {
        -- dir = "~/Documents/projects/yankbank-nvim",
        "ptdewey/yankbank-nvim",

        event = "VeryLazy",

        config = function()
            require("yankbank").setup()
            vim.keymap.set("n", "<leader>p", ":YankBank<CR>",
                { noremap = true, silent = true })
        end,
    },
}

