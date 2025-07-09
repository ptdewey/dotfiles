vim.lsp.config["rust_analyzer"] = {
    on_attach = function(client, bufnr)
        require("inlay-hints").on_attach(client, bufnr)
    end,
}
