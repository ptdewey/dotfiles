vim.lsp.config["vacuum"] = {
    cmd = { "vacuum", "language-server" },
    filetypes = { "yaml", "json" },
    -- patterns = { "openapi.yaml", "openapi.yml", "openapi.json" },
    -- settings = {},
    on_attach = function(client, bufnr)
    end,
}
