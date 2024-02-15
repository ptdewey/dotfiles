-- undo tree
return {
    'mbbill/undotree',

    lazy = false,

    config = function()
        vim.keymap.set("n", "<leader>ut", ":UndotreeToggle<CR>")
    end,
}
