-- documentation related plugins
return {
    -- auto-generate function annotations
    {
        "danymat/neogen",
        -- load plugin on keybinds
        keys = {
            {
                "<leader>gd",
                function()
                    require("neogen").generate({})
                end,
                desc = "[G]enerate [D]ocumentation",
                silent = true,
                noremap = true,
            },
        },
        config = function()
            require("neogen").setup({})
        end,
    },
}
