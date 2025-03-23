-- set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- load required files
require("lazy-nvim")
require("config.keymaps")
require("config.options")
require("autocmds")
require("extras")
