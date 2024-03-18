-- R related plugins
return {
    -- send r code to r term
    {
        "danilka4/ts_r",

        ft = { "r", "rmd" },
    },

    -- knit r files
    {
        "ptdewey/knitr-nvim",

        -- branch = "dev",
        branch = "main",

        -- load for correct file types only
        ft = { "r", "rmd" },

        dependencies = {
            "nvim-lua/plenary.nvim",
        },

        config = function()
            require("knitr").setup()
        end,

        vim.keymap.set("n", "<F6>", ":KnitRpdf<CR>", { noremap = true })
    },
}
