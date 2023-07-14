---@type ChadrcConfig
local M = {}

local opt = vim.opt
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
    theme = "everforest",
    -- theme_toggle = { "onedark", "one_light" },

    hl_override = highlights.override,
    hl_add = highlights.add,
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
