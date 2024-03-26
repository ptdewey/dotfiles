-- quick jumping and better f/t (with treesitter jumps)
return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",

        -- keybinds (mode 'o' is operator-pending)
        keys = {
            { "s", mode = { "n", "x", "o" }, function()
                require("flash").jump()
            end, desc = "Flash" },

            -- { "S", mode = { "n", "x", "o" }, function()
            --     require("flash").treesitter()
            -- end, desc = "Flash Treesitter" },

            { "r", mode = "o", function()
                require("flash").remote()
            end, desc = "Remote Flash" },

            { "R", mode = { "o", "x" }, function()
                require("flash").treesitter_search()
            end, desc = "Teesitter Search" },

            { "<c-s>", mode = { "c" }, function()
                require("flash").toggle()
            end, desc = "Toggle Flash Search" },
        },

        opts = {
            -- disable prompt
            prompt = {
                enabled = false,
            }
        }
    },
}
