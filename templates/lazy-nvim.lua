return {
    {
        "username/plugin",

        event = "VeryLazy",

        config = function()
            require("plugin").setup({})
        end,
    },
}
