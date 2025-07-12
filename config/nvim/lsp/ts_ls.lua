vim.lsp.config["ts_ls"] = {
    filetypes = { "typescript", "javascript" },
    settings = {
        implicitProjectConfiguration = {
            checkJs = true,
        },
    },
}
