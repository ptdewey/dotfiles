-- undo tree
return {
    'mbbill/undotree',
    vim.keymap.set("n", "<F5>", ":UndotreeToggle<CR>")
}
