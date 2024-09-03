vim.filetype.add({
    extension = {
        puml = "plantuml",
        pu = "plantuml",
        plantuml = "plantuml",
        wsd = "plantuml",
        iuml = "plantuml",
    },
    filename = {},
    pattern = {},
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "plantuml",
    callback = function()
        vim.opt_local.commentstring = "' %s"
    end,
})
