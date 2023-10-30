-- todo and other tag highlights
return {
    "folke/todo-comments.nvim",
    lazy = false,
    config = function()
        require("todo-comments").setup()
    end,
}
