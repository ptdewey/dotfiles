-- undo tree
return {
    'mbbill/undotree',

    lazy = false,

    config = function()
        vim.keymap.set("n", "<F5>", ":UndotreeToggle<CR>")
    end,
}
