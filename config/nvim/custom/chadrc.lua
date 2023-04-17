local M = {}

-- require('lspconfig').r_language_server.setup{}
local opt = vim.opt
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- require'lspconfig'.r_language_server.setup{}

M.ui = {
    theme = "everforest",
}

M.plugins = require("custom.plugins")


M.mappings = require("custom.mappings")

return M
