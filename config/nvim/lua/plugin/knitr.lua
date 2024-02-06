-- knit r files
return {
    "ptdewey/knitr-nvim",
    lazy = true,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("knitr")
    end,
    -- branch = "main",
    -- branch = "dev",

    -- Map to F6
    vim.keymap.set("n", "<F6>", ":KnitRpdf<CR>", { noremap = true }),
}

