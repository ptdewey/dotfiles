-- set up plantuml language server
vim.api.nvim_create_autocmd("FileType", {
    pattern = "plantuml",
    callback = function(args)
        -- set up lsp configuration
        local config = {
            name = "plantuml_lsp",
            cmd = {
                "/home/patrick/projects/plantuml-lsp.git/dev/plantuml_lsp",
                "--stdlib-path=/home/patrick/projects/plantuml-stdlib",
            },
            root_dir = vim.fs.root(args.buf, ".git")
                or vim.fs.dirname(vim.api.nvim_buf_get_name(args.buf)),
            autostart = true,
        }

        -- start lsp client
        vim.lsp.start(config)
    end,
})
