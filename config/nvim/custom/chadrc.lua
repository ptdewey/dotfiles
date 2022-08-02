local M = {}

M.ui = {
   theme = "gruvbox",
}

M.plugins = {
  user = require "custom.plugins"
}

M.mappings = require "custom.mappings"

return M
