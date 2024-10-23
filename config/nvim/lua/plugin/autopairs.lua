-- autopairs
return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },
    {
        "windwp/nvim-ts-autotag",
        ft = {
            "markdown",
            "javascript",
            "javascriptreact",
            "typescriptreact",
            "html",
        },
        config = function()
            require("nvim-ts-autotag").setup({})
        end,
    },
}
