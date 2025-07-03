return {
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    javascript = { "prettierd" },
                    typescript = { "prettierd" },
                    javascriptreact = { "prettierd" },
                    typescriptreact = { "prettierd" },
                    html = { "prettierd" },
                    svelte = { "svelte" },
                    go = { "gofmt", "goimports" },
                    rust = { "rustfmt" },
                    -- bash = { "beautysh" },
                    -- zsh = { "beautysh" },
                    -- sh = { "beautysh" },
                    python = { "ruff" },
                    typst = { "tinymist" },
                    ["_"] = { "trim_whitespace" },
                },
                format_on_save = function(bufnr)
                    if
                        vim.g.disable_autoformat
                        or vim.b[bufnr].disable_autoformat
                    then
                        return
                    end
                    return {
                        timeout_ms = 500,
                        -- lsp_format = "never",
                        lsp_format = "fallback",
                        -- async = true,
                    }
                end,
                formatters = {
                    stylua = {
                        -- adjust stylua to use custom config file
                        append_args = {
                            "--config-path",
                            vim.fn.expand("$HOME/dotfiles/home/stylua.toml"),
                        },
                    },
                },
            })
        end,
        vim.api.nvim_create_user_command("ConformDisable", function(args)
            if args.bang then
                -- FormatDisable! will disable formatting just for this buffer
                vim.b.disable_autoformat = true
            else
                vim.g.disable_autoformat = true
            end
        end, {
            desc = "Disable autoformat-on-save",
            bang = true,
        }),
        vim.api.nvim_create_user_command("ConformEnable", function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
        end, {
            desc = "Re-enable autoformat-on-save",
        }),
    },
}
