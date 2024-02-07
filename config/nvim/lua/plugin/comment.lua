-- fast comment
return {
    'numToStr/Comment.nvim',

    lazy = false,
    opts = {},

    config = function()
        require("Comment").setup()

        -- keybinds
        vim.keymap.set("n", "<leader>/", "gcc", {
            desc = "toggle comment",
            remap = true,
        })
        vim.keymap.set("v", "<leader>/", "gc", {
            desc = "toggle comment",
            remap = true,
        })
    end,

}
