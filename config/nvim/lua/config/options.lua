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

    -- break indent
    breakindent = true,

    -- aesthetics
    termguicolors = true,
    signcolumn = "number", -- alterntive: "auto, number"
    background = "dark", -- alternative: "light"
}

-- set theme
vim.cmd([[colorscheme gruvbox-material]])

-- highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})


for k, v in pairs(options) do
    vim.opt[k] = v
end
