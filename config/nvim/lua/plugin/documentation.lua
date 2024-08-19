-- documentation related plugins
return {
    -- auto-generate function annotations
    {
        "danymat/neogen",
        config = function()
            require("neogen").setup({})
            vim.keymap.set("n", "<leader>dg", function()
                require("neogen").generate({})
            end, { desc = "[D]ocumentation [G]enerate", silent = true, noremap = true })
        end,
    },
}
