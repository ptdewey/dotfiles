vim.filetype.add({
    extension = {
        ["http"] = "http",
    },
    filename = {},
    pattern = {},
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "http",
    callback = function()
        vim.opt_local.commentstring = "# %s"
    end,
})
