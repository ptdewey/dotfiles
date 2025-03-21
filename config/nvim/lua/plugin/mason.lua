-- lsp management
return {
    {
        -- install and manage lsp installations
        "williamboman/mason.nvim",
        event = { "BufReadPost", "BufNewFile" },

        cmd = { "Mason" },
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
        },

        config = function()
            -- Configure LSP
            vim.keymap.set(
                "n",
                "<leader>rn",
                vim.lsp.buf.rename,
                { desc = "[R]e[n]ame" }
            )
            local on_attach = function(_, bufnr)
                vim.keymap.set("n", "K", function()
                    vim.lsp.buf.hover()
                end, { desc = "Hover Documentation" })
                vim.keymap.set("n", "<leader>k", function()
                    vim.lsp.buf.signature_help()
                end, { desc = "Signature Documentation" })

                vim.keymap.set("i", "<C-k>", function()
                    vim.lsp.buf.signature_help()
                end, { desc = "LSP: Signature Documentation" })

                -- Lesser used LSP functionality
                vim.keymap.set(
                    "n",
                    "gD",
                    vim.lsp.buf.declaration,
                    { desc = "[G]oto [D]eclaration" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>wa",
                    vim.lsp.buf.add_workspace_folder,
                    { desc = "[W]orkspace [A]dd Folder" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>wr",
                    vim.lsp.buf.remove_workspace_folder,
                    { desc = "[W]orkspace [R]emove Folder" }
                )
                vim.keymap.set("n", "<leader>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, { desc = "[W]orkspace [L]ist Folders" })

                -- Create a command `:Format` local to the LSP buffer
                vim.api.nvim_buf_create_user_command(
                    bufnr,
                    "Format",
                    function(_)
                        vim.lsp.buf.format()
                    end,
                    { desc = "Format current buffer with LSP" }
                )
            end

            -- mason-lspconfig requires that these setup functions are called in this order
            -- before setting up the servers.
            require("mason").setup({
                -- registries = {
                --     "file:~/projects/mason-registry",
                -- },
            })
            require("mason-lspconfig").setup()

            -- language servers to automatically install
            local servers = {
                gopls = {},
                lua_ls = {
                    Lua = {
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                        globals = { "vim" },
                    },
                },
            }

            -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities =
                require("cmp_nvim_lsp").default_capabilities(capabilities)

            -- Ensure the servers above are installed
            local mason_lspconfig = require("mason-lspconfig")

            mason_lspconfig.setup({
                ensure_installed = vim.tbl_keys(servers),
            })

            mason_lspconfig.setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = servers[server_name],
                        filetypes = (servers[server_name] or {}).filetypes,
                    })
                end,
            })
        end,
    },
    {
        -- link mason and lspconfig
        "williamboman/mason-lspconfig.nvim",
        lazy = true,
    },
}
