-- language server configuration plugins
return {
    {
        -- lsp setup
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile", "FileType" },

        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "saghen/blink.cmp",
        },

        vim.diagnostic.config({
            -- virtual_lines = true
            virtual_text = true,
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

        opts = {
            servers = {
                lua_ls = {
                    on_attach = function(client, bufnr)
                        require("inlay-hints").on_attach(client, bufnr)
                    end,
                    settings = {
                        Lua = {
                            hint = {
                                enable = true,
                            },
                            -- workspace = { checkThirdParty = false },
                            telemetry = { enable = false },
                            globals = { "vim" },
                        },
                    },
                },

                gopls = {
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
                },

                ts_ls = {
                    filetypes = { "typescript", "javascript", "svelte" },
                    settings = {
                        implicitProjectConfiguration = {
                            checkJs = true,
                        },
                    },
                },

                ruff = {
                    settings = {},
                },

                tinymist = {
                    settings = {
                        exportPdf = "onSave",
                        formatterMode = "typstyle",
                        semanticTokens = "disable",
                    },
                },

                harper_ls = {
                    settings = {
                        ["harper-ls"] = {
                            linters = {
                                ToDoHyphen = false,
                            },
                        },
                    },
                },

                rust_analyzer = {
                    on_attach = function(client, bufnr)
                        require("inlay-hints").on_attach(client, bufnr)
                    end,
                },
            },
        },

        config = function(_, opts)
            local lspconfig = require("lspconfig")

            for server, config in pairs(opts.servers) do
                config.capabilities = require("blink.cmp").get_lsp_capabilities(
                    config.capabilities
                )
                lspconfig[server].setup(config)
            end
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
        dependencies = { "neovim/nvim-lspconfig" },
    },
}
