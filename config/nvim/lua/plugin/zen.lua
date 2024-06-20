return {
    {
        "folke/twilight.nvim",
        config = function()
            require("twilight").setup({
                context = 20,
                treesitter = true,
            })
        end
    },
    {
        "folke/zen-mode.nvim",
        config = function()
            require("zen-mode").setup({
                backdrop = 0.95,
                plugins = {
                    twilight = { enabled = true },
                    gitsigns = { enabled = false },
                    tmux = { enabled = false },
                }
            })
        end
    },
}
