local M = {}

M.ui = {
   theme = "chocolate",
}

M.plugins = {
  user = require "custom.plugins"
}

M.mappings = require "custom.mappings"

return M
