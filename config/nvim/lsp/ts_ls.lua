vim.lsp.config["ts_ls"] = {
    filetypes = { "typescript", "javascript", "svelte" },
    settings = {
        implicitProjectConfiguration = {
            checkJs = true,
        },
    },
}
