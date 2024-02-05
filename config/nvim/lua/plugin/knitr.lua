-- knit r files
return {
    "ptdewey/knitr-nvim",
    config = function()
        require("knitr")
    end,

    -- Map to F6
    vim.keymap.set("n", "<F6>", ":KnitRpdf<CR>", { noremap = true }),
}

