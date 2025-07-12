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
            require("mini.pairs").setup({})
            -- require("mini.visits").setup({})
        end,
    },
}
