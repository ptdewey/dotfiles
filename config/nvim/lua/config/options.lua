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

    -- dictionary file
    spelllang = "en_us",
    spellfile = vim.fn.expand("$HOME/.config/nvim/spell/en.utf-8.add"),

    -- aesthetics
    termguicolors = true,
    -- TODO: highlight numbers instead of showing git signs?
    -- different colors for different mods (green: new, red: deletes, blue: changes?)
    signcolumn = "auto", -- alterntive: "auto, number, yes"
    background = "dark", -- alternative: "light"
}

-- custom variables
local vars = {
    -- netrw settings
    netrw_banner = 0,
    netrw_bufsettings = "noma nomod nu nobl nowrap ro",
    -- netrw_list_hide = [[\(^|\s\s\)\zs\.\S\+]], -- TODO: this doesnt seem to work right
    netrw_hide = 1,
}


-- theme options
-- vim.cmd([[colorscheme gruvbox-material]])
vim.cmd([[colorscheme darkearth]])

-- apply options
for k, v in pairs(options) do
    vim.opt[k] = v
end

-- set variables
for k, v in pairs(vars) do
    vim.g[k] = v
end
