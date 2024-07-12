-- http file specific options

-- keymaps
vim.keymap.set("n", "<leader>hr",
    ":lua require('kulala').run()<CR>",
    { noremap = true, silent = true }
)
vim.keymap.set("n", "<leader>hn",
    ":lua require('kulala').jump_next()<CR>",
    { noremap = true, silent = true }
)
vim.keymap.set("n", "<leader>hp",
    ":lua require('kulala').jump_prev()<CR>",
    { noremap = true, silent = true }
)
