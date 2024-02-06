-- undo tree
return {
    'mbbill/undotree',
    lazy = false,
    vim.keymap.set("n", "<F5>", ":UndotreeToggle<CR>")
}
