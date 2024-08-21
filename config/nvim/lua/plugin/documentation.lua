-- documentation related plugins
return {
    -- auto-generate function annotations
    {
        "danymat/neogen",
        -- load plugin on keybinds
        keys = {
            {
                "<leader>dg",
                function()
                    require("neogen").generate({})
                end,
                desc = "[D]ocumentation [G]enerate",
                silent = true,
                noremap = true
            },
        },
        config = function()
            require("neogen").setup({})
        end,
    },
}
