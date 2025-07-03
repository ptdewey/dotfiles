-- language server configuration plugins

-- TODO: replace inlay hints plugin with autocmd:
-- Something like the following may work (needs to be autocmd instead of keymap though)
-- ```
--   if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
--     map('<leader>th', function()
--       vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
--     end, '[T]oggle Inlay [H]ints')
--   end
-- ```
return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile", "FileType" },
        dependencies = {
            "williamboman/mason.nvim",
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
                            telemetry = { enable = false },
                            globals = { "vim", "hs" },
                            workspace = {
                                library = {
                                    vim.fn.expand(
                                        "~/dotfiles/home/hammerspoon/Spoons/EmmyLua.spoon/annotations"
                                    ),
                                },
                                checkThirdParty = false,
                            },
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
                    on_attach = function(client, bufnr)
                        vim.keymap.set("n", "<leader>tp", function()
                            client:exec_cmd({
                                title = "pin",
                                command = "tinymist.pinMain",
                                arguments = { vim.api.nvim_buf_get_name(0) },
                            }, {
                                bufnr = bufnr,
                            })

                            vim.print(
                                "Updated pinned main to "
                                    .. vim.api.nvim_buf_get_name(0)
                            )
                        end, {
                            desc = "tinymist: Pin buffer as main",
                            noremap = true,
                        })

                        vim.keymap.set("n", "<leader>tu", function()
                            client:exec_cmd({
                                title = "unpin",
                                command = "tinymist.pinMain",
                                arguments = { vim.v.null },
                            }, { bufnr = bufnr })
                            vim.print(
                                "Unpinned: " .. vim.api.nvim_buf_get_name(0)
                            )
                        end, {
                            desc = "[T]ypst [U]npin",
                            noremap = true,
                        })
                    end,
                },

                harper_ls = {
                    settings = {
                        ["harper-ls"] = {
                            linters = {
                                ToDoHyphen = false,
                                Dashes = false,
                                LongSentences = false,
                                SentenceCapitalization = false,
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
