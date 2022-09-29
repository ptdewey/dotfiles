local M = {}

M.ui = {
   theme = "everforest",
}

M.plugins = {
  user = require "custom.plugins"
}

M.mappings = require "custom.mappings"

return M
