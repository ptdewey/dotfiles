-- knit r files
return {
    "ptdewey/knitr-nvim",

    -- branch = "dev",
    branch = "main",

    -- load for correct file types only
    ft = { "rmd", "r" },

    dependencies = {
        "nvim-lua/plenary.nvim",
    },

    config = function()
        require("knitr").setup()
        -- Map to F6/F7
        vim.keymap.set("n", "<F6>", ":KnitRpdf<CR>", { noremap = true })
        vim.keymap.set("n", "<F7>", ":KnitRhtml<CR>", { noremap = true })
    end,
}

