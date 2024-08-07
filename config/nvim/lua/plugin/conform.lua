return {
    {
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup {
                formatters_by_ft = {
                    -- lua = { "stylua" },
                    javascript = { "prettierd" },
                    typescript = { "prettierd" },
                    javascriptreact = { "prettierd" },
                    typescriptreact = { "prettierd" },
                    go = { "gofmt" },
                    rust = { "rustfmt" },
                    python = { "blue", "isort" },
                    ["_"] = { "trim_whitespace" },
                },
                format_on_save = {
                    timeout_ms = 500,
                    lsp_format = "never",
                    -- lsp_format = "fallback",
                    -- async = true,
                },
            }
        end,
    },
}
