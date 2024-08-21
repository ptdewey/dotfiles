-- language server configuration plugins
return {
    {
        -- lsp setup
        'neovim/nvim-lspconfig',
        event = { "BufReadPost", "BufNewFile" },

        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        },

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = true,
                header = "",
                prefix = "",
            },
        }),
    },
    {
        -- neovim api completion
        "folke/lazydev.nvim",
        ft = "lua",
        config = function()
            require("lazydev").setup({
                library = {
                    { path = "luvit-meta/library", words = { "vim%.uv" } },
                },
            })
        end
    },
    {
        -- useful status updates for LSP
        'j-hui/fidget.nvim',
        event = "LspAttach",
        tag = 'legacy',
        config = function()
            require("fidget").setup({})
        end
    },
    {
        -- floating signature help
        "ray-x/lsp_signature.nvim",
        event = "LspAttach",
        config = function()
            require("lsp_signature").setup({
                doc_lines = 0,
                hi_parameter = "IncSearch",
                -- hint_inline = function() return true end,
                hint_prefix = "",
                handler_opts = {
                    border = "rounded",
                },
            })
        end,
    },
}
