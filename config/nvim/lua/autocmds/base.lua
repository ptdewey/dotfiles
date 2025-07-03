-- fix netrw navigation for split keyboard (numpad '-' key)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        vim.cmd([[nnoremap <buffer> <kMinus> <Plug>NetrwBrowseUpDir]])
        vim.cmd([[nnoremap <buffer> <kPlus> <Plug>NetrwLocalBrowseCheck]])
    end,
})

-- highlight on yank
local highlight_group =
    vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- close empty buffer on buffer switch
vim.api.nvim_create_autocmd("BufLeave", {
    callback = function()
        local buf_type = vim.bo.buftype
        local is_listed = vim.bo.buflisted
        local listed_buffers = vim.fn.len(
            vim.fn.filter(
                vim.fn.range(1, vim.fn.bufnr("$")),
                "buflisted(v:val)"
            )
        )
        local is_unnamed_and_empty = vim.fn.bufname("%") == ""
            and vim.fn.line("$") == 1
            and vim.fn.getline(1) == ""
            and not vim.bo.modified
        if
            is_unnamed_and_empty
            and is_listed
            and buf_type == ""
            and listed_buffers > 1
        then
            vim.cmd("bd")
        end
    end,
})

-- remove trailing whitespace upon save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    end,
})
