return {
    {
        "folke/todo-comments.nvim",
        dependencies = { "ibhagwan/fzf-lua" },
        event = { "BufReadPost", "BufNewFile" },

        config = function()
            require("todo-comments").setup({
                signs = false,
                keywords = {
                    DOC = { alt = { "DOCS" } },
                    REFACTOR = { color = "warning" },
                    CHANGE = { color = "warning" },
                },
            })

            vim.keymap.set("n", "]t", function()
                require("todo-comments").jump_next()
                vim.cmd("normal! zz")
            end, { desc = "Next todo comment" })

            vim.keymap.set("n", "[t", function()
                require("todo-comments").jump_prev()
                vim.cmd("normal! zz")
            end, { desc = "Previous todo comment" })
        end,
    },

    {
        "mbbill/undotree",
        keys = {
            {
                "<leader>ut",
                ":UndotreeToggle<CR>",
                desc = "[U]ndoTree [T]oggle",
            },
        },
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        main = "ibl",
        config = function()
            require("ibl").setup({
                scope = {
                    show_start = false,
                    show_end = false,
                },
            })
        end,
    },

    -- {
    --     "numToStr/Comment.nvim",
    --     event = "VeryLazy",
    --     config = function()
    --         require("Comment").setup()
    --
    --         vim.keymap.set(
    --             "n",
    --             "<leader>/",
    --             "gcc",
    --             { desc = "Toggle Comment", remap = true }
    --         )
    --
    --         vim.keymap.set(
    --             "x",
    --             "<leader>/",
    --             "gc",
    --             { desc = "Toggle Comment", remap = true }
    --         )
    --     end,
    -- },
}
