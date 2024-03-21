-- Custom options
local options = {
    number = true,
    rnu = true,
    autoindent = true,
    so = 6,
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
    -- TODO: highlight numbers instead of showing git signs?
    -- different colors for different mods (green: new, red: deletes, blue: changes?)
    signcolumn = "auto", -- alterntive: "auto, number, yes"
    background = "dark", -- alternative: "light"
}

-- set theme
-- vim.cmd([[colorscheme gruvbox]])
-- vim.cmd([[colorscheme gruvbox-material]])
vim.cmd([[colorscheme darkearth]])
-- vim.cmd([[colorscheme everforest]])

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
