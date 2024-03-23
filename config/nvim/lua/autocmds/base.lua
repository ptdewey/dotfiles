-- autocmds for base nvim

-- fix netrw navigation for split keyboard (numpad '-' key)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        vim.cmd([[nnoremap <buffer> <kMinus> <Plug>NetrwBrowseUpDir]])
        vim.cmd([[nnoremap <buffer> <kPlus> <Plug>NetrwLocalBrowseCheck]])
    end
})

-- highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- remove search highlight on instert or moving cursor
-- TODO: add back highlight on n/N search
vim.api.nvim_create_autocmd({"InsertEnter", "CursorMoved"}, {
    callback = function()
        local function s()
            return vim.cmd("nohlsearch")
        end
        return vim.schedule(s)
    end
})

