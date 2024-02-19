-- special file specific mappings

-- fix netrw navigation for split keyboard (numpad '-' key)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        vim.cmd([[nnoremap <buffer> <kMinus> <Plug>NetrwBrowseUpDir]])
    end
})

