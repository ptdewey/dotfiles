-- todo and other tag highlights
return {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    keys = { "<leader>tt", desc = "[T]odo [T]elescope" },
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },

    -- TODO: replace plugin with vanilla variant + custom telescope keybind
    -- https://www.reddit.com/r/neovim/comments/1cmgp9k/comment/l33co7r/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button

    config = function()
        require("todo-comments").setup({
            signs = false,
            keywords = {
                DOC = {
                    alt = { "DOCS" },
                },
                REFACTOR = {
                    color = "warning",
                    alt = { "REFAC" },
                },
                CHANGE = {
                    color = "warning",
                },
            },
            -- colors = {
            --     default = { "Operator" },
            -- },
            -- TODO: change colors to better work with darkearth (or change darkearth)
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
