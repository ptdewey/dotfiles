return {
    {
        "folke/todo-comments.nvim",
        dependencies = { "ibhagwan/fzf-lua" },
        event = { "BufReadPost", "BufNewFile" },

        -- TODO: replace plugin with vanilla variant + custom telescope keybind
        -- https://www.reddit.com/r/neovim/comments/1cmgp9k/comment/l33co7r/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button

        config = function()
            require("todo-comments").setup({
                signs = false,
                keywords = {
                    DOC = { alt = { "DOCS" } },
                    REFACTOR = { color = "warning" },
                    CHANGE = { color = "warning" },
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
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({})
        end,
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
}
