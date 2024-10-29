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
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "html",
            "vue",
            "svelte",
        },
        config = function()
            require("nvim-ts-autotag").setup({})
        end,
    },
}
