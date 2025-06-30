vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = { "openapi.yaml", "openapi.yml", "openapi.json" },
    callback = function()
        vim.lsp.start(vim.lsp.config["vacuum"])
    end,
})
