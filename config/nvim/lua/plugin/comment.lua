-- fast comment
return {
    'numToStr/Comment.nvim',
    lazy = false,
    config = function()
        require("Comment").setup()
    end,
    opts = {},

    -- keybinds
    vim.keymap.set("n", "<leader>/", "gcc", {
        desc = "toggle comment",
        remap = true,
    }),
    vim.keymap.set("v", "<leader>/", "gc", {
        desc = "toggle comment",
        remap = true,
    }),
}
