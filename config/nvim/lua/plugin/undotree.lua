-- undo tree
return {
    {
        'mbbill/undotree',
        event = "VeryLazy",
        vim.keymap.set("n", "<leader>ut", ":UndotreeToggle<CR>")
    }
}
