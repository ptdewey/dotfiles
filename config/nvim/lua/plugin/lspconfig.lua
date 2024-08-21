-- language server configuration plugin
return {
    {
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
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        event = "VeryLazy",
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
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
            local lspconfig = require('lspconfig')
            local configs = require('lspconfig.configs')
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "plantuml",
                callback = function()
                    if not configs.plantuml_lsp then
                        configs.plantuml_lsp = {
                            default_config = {
                                cmd = { "/home/patrick/projects/plantuml-lsp.git/dev/plantuml_lsp", "--stdlib-path=/home/patrick/projects/plantuml-stdlib" },
                                filetypes = { "plantuml" },
                                root_dir = function(fname)
                                    return lspconfig.util.find_git_ancestor(fname) or lspconfig.util.path.dirname(fname)
                                end,
                                settings = {},
                            },
                        }
                    end
                    lspconfig.plantuml_lsp.setup {}
                end,
            })
        end
    },
}
