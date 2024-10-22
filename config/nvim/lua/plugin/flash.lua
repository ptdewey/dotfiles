-- quick jumping and better f/t (with treesitter jumps)
return {
    {
        "folke/flash.nvim",

        -- keybinds (mode 'o' is operator-pending)
        event = "BufReadPost",

        config = function()
            require("flash").setup({
                modes = {
                    -- disable flash on search
                    search = {
                        enabled = false,
                    },
                },

                -- disable prompt
                prompt = {
                    enabled = false,
                },
            })

            -- keymaps
            vim.keymap.set({ "n", "x", "o" }, "s", function()
                require("flash").jump()
            end)
            vim.keymap.set({ "n", "x", "o" }, "S", function()
                require("flash").treesitter()
            end)
            vim.keymap.set("o", "r", function()
                require("flash").remote()
            end)
            vim.keymap.set({ "o", "x" }, "R", function()
                require("flash").treesitter_search()
            end)
        end,
    },
}
