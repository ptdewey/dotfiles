local M = {}

local set = vim.opt
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.expandtab = true
set.smartindent = true

M.ui = {
    theme = "rosepine",
}

M.plugins = {
    user = require "custom.plugins"
}

M.mappings = require "custom.mappings"

return M
