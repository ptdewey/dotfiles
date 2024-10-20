-- language server configuration plugins
return {
    {
        -- lsp setup
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },

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
    },
    {
        "folke/neodev.nvim",
        ft = "lua",
        opts = {},
    },
    -- { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    -- {
    --     -- neovim api completion
    --     "folke/lazydev.nvim",
    --     ft = "lua",
    --     opts = {
    --         library = {
    --             { path = "luvit-meta/library", words = { "vim%.uv" } },
    --             "lazy.nvim",
    --         },
    --     },
    -- },
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
        "aznhe21/actions-preview.nvim",
        event = "LspAttach",
        config = function()
            require("actions-preview").setup({
                telescope = {
                    sorting_strategy = "ascending",
                    layout_strategy = "vertical",
                    layout_config = {
                        width = 0.8,
                        height = 0.9,
                        prompt_position = "top",
                        preview_cutoff = 20,
                        preview_height = function(_, _, max_lines)
                            return max_lines - 15
                        end,
                    },
                },
            })
            vim.keymap.set(
                { "v", "n" },
                "<leader>ca",
                require("actions-preview").code_actions
            )
        end,
    },
}
