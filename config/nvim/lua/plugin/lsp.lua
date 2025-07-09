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

        opts = {
            servers = {
                lua_ls = vim.lsp.config["lua_ls"],
                gopls = vim.lsp.config["gopls"],
                ts_ls = vim.lsp.config["ts_ls"],
                ruff = vim.lsp.config["ruff"],
                pyright = vim.lsp.config["pyright"],
                tinymist = vim.lsp.config["tinymist"],
                harper_ls = vim.lsp.config["harper_ls"],
                rust_analyzer = vim.lsp.config["rust_analyzer"],
            },
        },

        config = function(_, opts)
            for server, config in pairs(opts.servers) do
                config.capabilities = require("blink.cmp").get_lsp_capabilities(
                    config.capabilities
                )
                require("lspconfig")[server].setup(config)
            end
        end,
    },

    {
        "williamboman/mason.nvim",
        cmd = { "Mason" },
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("mason").setup({})
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
                handler_opts = { border = "rounded" },
            })
        end,
    },

    {
        "MysticalDevil/inlay-hints.nvim",
        event = "LspAttach",
        dependencies = { "neovim/nvim-lspconfig" },
    },
}
