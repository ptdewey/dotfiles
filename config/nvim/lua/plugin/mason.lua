return {
    {
        "williamboman/mason.nvim",
        -- event = { "BufReadPost", "BufNewFile" },
        cmd = { "Mason" },
        config = function()
            require("mason").setup({})
        end,
    },
}
