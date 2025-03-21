-- language server configuration plugins
return {
    {
        -- lsp setup
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile", "FileType" },

        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
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

        config = function()
            local lspconfig = require("lspconfig")

            -- lua_ls
            lspconfig.lua_ls.setup({
                on_attach = function(client, bufnr)
                    require("inlay-hints").on_attach(client, bufnr)
                end,

                settings = {
                    Lua = {
                        hint = {
                            enable = true, -- necessary
                        },
                        -- workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                        globals = { "vim" },
                    },
                },
            })
            -- gopls
            lspconfig.gopls.setup({
                on_attach = function(client, bufnr)
                    require("inlay-hints").on_attach(client, bufnr)
                end,
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
            })

            -- js and ts
            lspconfig.ts_ls.setup({
                filetypes = { "typescript", "javascript", "svelte" },
                settings = {
                    implicitProjectConfiguration = {
                        checkJs = true,
                    },
                },
            })

            -- ruff for python (also use pyright for completions)
            lspconfig.ruff.setup({
                settings = {},
            })

            lspconfig.rust_analyzer.setup({
                on_attach = function(client, bufnr)
                    require("inlay-hints").on_attach(client, bufnr)
                end,
            })

            -- typst lsp
            lspconfig.tinymist.setup({
                settings = {
                    -- format = "onSave",
                    -- formatterMode = "typstfmt",
                    exportPdf = "onSave",
                    formatterMode = "typstyle",
                    semanticTokens = "disable",
                },
            })

            lspconfig.harper_ls.setup({
                settings = {
                    ["harper-ls"] = {},
                },
            })
        end,
    },
    {
        -- useful status updates for LSP
        "j-hui/fidget.nvim",
        event = "LspAttach",
        tag = "legacy",
        config = function()
            require("fidget").setup({})
        end,
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
    {
        "MysticalDevil/inlay-hints.nvim",
        event = "LspAttach",
        -- event = "BufReadPost",
        dependencies = { "neovim/nvim-lspconfig" },
        -- config = function()
        --     require("inlay-hints").setup({
        --         commands = { enable = true },
        --         autocmd = { enable = true },
        --     })
        -- end,
    },
}
