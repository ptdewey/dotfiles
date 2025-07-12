local skip_lsps = {
    -- ["ts_ls"] = true,
    ["svelte"] = true,
    ["eslint"] = true,
}

-- inlay hints
vim.api.nvim_create_augroup("InlayHints", { clear = true })
vim.cmd.highlight("default link LspInlayHint Comment")
vim.api.nvim_create_autocmd("LspAttach", {
    group = "InlayHints",
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or skip_lsps[client.name] then
            return
        end

        if
            client:supports_method("textDocument/inlayHint")
            or client.server_capabilities.inlayHintProvider
        then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end
    end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = { "openapi.yaml", "openapi.yml", "openapi.json" },
    callback = function()
        vim.lsp.start(vim.lsp.config["vacuum"])
    end,
})
