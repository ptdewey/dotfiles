return {
    {
        "ptdewey/oolong-nvim",
        -- dir = "~/projects/oolong-nvim",
        cmd = { "OolongGraph", "OolongSearch", "OolongRebuild" },
        config = function()
            require("oolong").setup({})
        end,
    },

    -- markdown previewer
    {
        "ellisonleao/glow.nvim",
        ft = { "markdown" },
        config = function()
            require("glow").setup({
                install_path = "~/.nix-profile/bin/glow",
            })
            vim.keymap.set(
                "n",
                "<F6>",
                ":Glow<CR>",
                { desc = "Open Glow Preview" }
            )
        end,
    },

    -- {
    --     "OXY2DEV/markview.nvim",
    --     lazy = false,
    -- },
}
