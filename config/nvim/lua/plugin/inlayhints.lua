return {
    {
        "MysticalDevil/inlay-hints.nvim",
        event = "LspAttach",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("inlay-hints").setup({
                commands = { enable = true },
                autocmd = { enable = true },
            })

            -- lua_ls
            require("lspconfig").lua_ls.setup({
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
            require("lspconfig").gopls.setup({
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
            require("lspconfig").ts_ls.setup({
                -- filetypes = { "typescript", "javascript", "html" },
                settings = {
                    implicitProjectConfiguration = {
                        checkJs = true,
                    },
                },
            })

            require("lspconfig").ruff.setup({
                init_options = {
                    settings = {
                        -- Ruff language server settings go here
                    },
                },
            })

            -- rust-analyzer (just works without any additional configuration)
        end,
    },
}
