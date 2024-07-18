-- todo and other tag highlights
return {
    "folke/todo-comments.nvim",

    lazy = false,

    config = function()
        require("todo-comments").setup({
            signs = false,
        })
        -- navigation
        vim.keymap.set("n", "]t", function()
            require("todo-comments").jump_next()
            vim.cmd("normal! zz")
        end, { desc = "Next todo comment" })

        vim.keymap.set("n", "[t", function()
            require("todo-comments").jump_prev()
            vim.cmd("normal! zz")
        end, { desc = "Previous todo comment" })

        -- telescope popup
        vim.keymap.set("n", "<leader>tt", function()
            vim.cmd("TodoTelescope")
        end, { desc = "[T]odo [T]elescope" })
    end,
}
