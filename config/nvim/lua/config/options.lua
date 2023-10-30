-- Custom options
local options = {
    number = true,
    autoindent = true,
    so = 5,
    splitright = true,
    splitbelow = true,
    showcmd = true,
    mouse = "a",

    -- tabs
    softtabstop = 4,
    shiftwidth = 4,
    tabstop = 4,
    expandtab = true,
    smarttab = true,

    -- Sync clipboard between OS and Neovim.
    clipboard = "unnamedplus",

    -- searching
    incsearch = true,
    ignorecase = true,
    smartcase = true,

    -- keep undo file
    undofile = true,

    -- decrease update time
    updatetime = 250,
    timeoutlen = 300,

    -- better completion
    completeopt = "menuone,noselect",

    -- break indent (TODO: figure out what this is)
    breakindent = true,

    -- aesthetics
    termguicolors = true,
    signcolumn = "number", -- alterntive: "auto, number"
    background = "dark", -- alternative: "light"
}

-- set theme
vim.cmd([[colorscheme gruvbox-material]])

for k, v in pairs(options) do
    vim.opt[k] = v
end
