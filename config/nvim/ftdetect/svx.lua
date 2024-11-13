vim.filetype.add({
    extension = {
        svx = "svx",
    },
})

vim.treesitter.language.register("markdown", "svx")
