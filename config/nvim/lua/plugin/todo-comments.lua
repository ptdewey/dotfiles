-- todo and other tag highlights
return {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },

    config = function()
        require("todo-comments").setup({
            signs = false,
            keywords = {
                DOCS = {
                    alt = { "DOC", "DOCUMENT" },
                },
            },
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
            -- start in normal mode (requires very small delay before sending esc command)
            vim.defer_fn(function()
                vim.cmd("stopinsert")
            end, 0.01)
        end, { desc = "[T]odo [T]elescope" })
    end,
}
