-- todo and other tag highlights
return {
    "folke/todo-comments.nvim",

    lazy = false,

    config = function()
        require("todo-comments").setup()
        -- navigation
        vim.keymap.set("n", "]t", function()
          require("todo-comments").jump_next()
        end, { desc = "Next todo comment" })

        vim.keymap.set("n", "[t", function()
          require("todo-comments").jump_prev()
        end, { desc = "Previous todo comment" })
    end,
}
