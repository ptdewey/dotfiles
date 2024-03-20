-- latex plugins
return {
    -- compile latex files
    {
        "ptdewey/tex-compile-nvim",
        -- dir = "~/Documents/projects/tex-compile-nvim",
        ft = { "tex" },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("tex-compile-nvim").setup()
            vim.keymap.set("n", "<F6>", ":LatexCompile<CR>", { noremap = true })
            -- vim.keymap.set("n", "<F7>", ":LatexCompileLive<CR>", { noremap = true })
        end,
    },
}
