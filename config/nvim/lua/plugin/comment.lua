-- fast comment
return {
    {
        'numToStr/Comment.nvim',

        events = "VeryLazy",

        opts = {},

        -- run plugin setup
        config = function()
            require("Comment").setup()
        end,

        -- set keybinds
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
