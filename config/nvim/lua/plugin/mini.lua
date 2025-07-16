return {
    {
        "echasnovski/mini.nvim",
        version = false,
        event = "VeryLazy",
        config = function()
            -- better `a/i` text objects
            require("mini.ai").setup({})
            -- better f/t motions
            require("mini.jump").setup({})
            require("mini.icons").setup({})
            require("mini.tabline").setup({})
            require("mini.visits").setup({})
            -- require("mini.pairs").setup({}) -- NOTE: doesn't function as well as autopairs

            local get_git_root = function()
                local result = vim.fn.systemlist(
                    "git rev-parse --show-toplevel 2>/dev/null"
                )
                if vim.v.shell_error == 0 and #result > 0 then
                    return result[1]
                end
                return vim.fn.getcwd()
            end

            local open_index = function(i, cwd)
                local pins = require("mini.visits").list_paths(
                    cwd or get_git_root(),
                    { filter = "pin" }
                )
                if #pins >= i then
                    vim.cmd("edit " .. pins[i])
                else
                    print("mini.visits: no pin with index '" .. i .. "'")
                end
            end

            vim.keymap.set("n", "<leader>a", function()
                local path = vim.fn.expand("%:p")
                if path ~= "" then
                    require("mini.visits").add_label(
                        "pin",
                        path,
                        get_git_root()
                    )
                end
            end, { desc = "add visit" })

            for i, key in ipairs({ "<C-h>", "<C-j>", "<C-k>", "<C-l>" }) do
                vim.keymap.set("n", key, function()
                    open_index(i)
                end, {})
            end

            vim.keymap.set("n", "<C-e>", function()
                -- TODO: keybinds for removing from list?
                require("mini.visits").select_path(
                    get_git_root(),
                    { filter = "pin" }
                )
            end, {})

            vim.keymap.set("n", "<leader>vr", require("mini.visits").select_path, {})
        end,
    },
}
