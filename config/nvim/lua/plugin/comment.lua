-- fast comment
return {
    {
        'numToStr/Comment.nvim',
        event = "VeryLazy",
        config = function()
            require("Comment").setup()
        end,
        vim.keymap.set("n", "<leader>/", "gcc", {
            desc = "toggle comment",
            remap = true,
        }),
        vim.keymap.set("v", "<leader>/", "gc", {
            desc = "toggle comment",
            remap = true,
        })
    },
}
