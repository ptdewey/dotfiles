local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- language servers
local servers = {
    "r_language_server",
    "clangd",
    "pylsp",
    "dockerls",
    "docker_compose_language_service",
}

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

lspconfig.r_language_server.setup{debug = true}

