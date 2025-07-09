vim.lsp.config["gopls"] = {
    settings = {
        gopls = {
            hints = {
                rangeVariableTypes = true,
                parameterNames = true,
                constantValues = true,
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                functionTypeParameters = true,
            },
        },
    },

    on_attach = function(client, bufnr)
        require("inlay-hints").on_attach(client, bufnr)
    end,
}
