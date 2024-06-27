-- key bindings

-- general keybindings
vim.keymap.set("n", ";", ":", { noremap = true, desc = "semicolon to colon in normal mode" })

-- buffer switching
vim.keymap.set("n", "<tab>", ":bnext <CR>", { noremap = true, desc = "tab to switch buffers" })
vim.keymap.set("n", "<S-tab>", ":bprev <CR>", { noremap = true, desc = "shift tab to switch buffers" })

-- window movement
vim.keymap.set("n", "<A-h>", "<C-w>h", { noremap = true, desc = "move to left window" })
vim.keymap.set("n", "<A-l>", "<C-w>l", { noremap = true, desc = "move to right window" })
vim.keymap.set("n", "<A-j>", "<C-w>j", { noremap = true, desc = "move to lower window" })
vim.keymap.set("n", "<A-k>", "<C-w>k", { noremap = true, desc = "move to upper window" })

-- move down visual lines
vim.keymap.set({ "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- recenter cursor upon page navigation
vim.keymap.set("n", "<C-b>", "<C-b>zz", { desc = "Move up a page" })
vim.keymap.set("n", "<C-f>", "<C-f>zz", { desc = "Move down a page" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move up a half page" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move down a half page" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Stay in place on line merging" })

-- recenter cursor on search
vim.keymap.set("n", "n", "nzzzv", { desc = "Recenter on search" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Recenter on search" })
vim.keymap.set("n", "*", "*zz", { desc = "Recenter on search" })
vim.keymap.set("n", "#", "#zz", { desc = "Recenter on search" })
vim.keymap.set("n", "g*", "g*zz", { desc = "Recenter on search" })
vim.keymap.set("n", "g#", "g#zz", { desc = "Recenter on search" })

-- allow moving of highlighted blocks
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move highlighted block down 1 line" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move highlighted block up 1 line" })


-- misc
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { nowait = true, desc = "Exit terminal insert mode" })
vim.keymap.set({"n", "v"}, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "<leader>n", ":noh<Cr>", { desc = "Clear search highlight on leader-n" } )
vim.keymap.set("n", "<Esc>", ":noh<Cr>", { desc = "Clear search highlight on escape", silent = true } )

-- diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic msg" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics List" })

-- LSP settings
vim.keymap.set("n", "gd", function()
    vim.lsp.buf.definition()
    vim.cmd("normal! zz")
end, { desc = "LSP jump to definition" })

-- Toggle Netrw
vim.keymap.set(
    "n", "<C-n>",
    function()
        if vim.bo.filetype == "netrw" then
            vim.cmd("bd")
        else
            vim.cmd("Explore")
        end
    end,
    { desc = "Toggle netrw" }
)

-- Make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>silent !chmod +x %<CR>", { desc = "Make current file executable" })

-- Tmux sessionizer
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww ~/dotfiles/scripts/tmux-sessionizer.sh<CR>", { desc = "Open tmux sessionizer" })

