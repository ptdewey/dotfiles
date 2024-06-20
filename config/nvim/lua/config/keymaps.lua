-- key bindings

local M = {}

-- general keybindings
M.general = {
    { "n", ";", ":", noremap = true, desc = "semicolon to colon in normal mode" },

    -- buffer switching
    { "n", "<tab>", ":bnext <CR>", noremap = true, desc = "tab to switch buffers" },
    { "n", "<S-tab>", ":bprev <CR>", noremap = true, desc = "shift tab to switch buffers" },

    -- window movement
    { "n", "<A-h>", "<C-w>h", noremap = true, desc = "move to left window" },
    { "n", "<A-l>", "<C-w>l", noremap = true, desc = "move to right window" },
    { "n", "<A-j>", "<C-w>j", noremap = true, desc = "move to lower window" },
    { "n", "<A-k>", "<C-w>k", noremap = true, desc = "move to upper window" },

    -- move down visual lines
    { { "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true } },
    { { "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true } },

    -- recenter cursor upon page navigation
    { "n", "<C-b>", "<C-b>zz", desc = "Move up a page" },
    { "n", "<C-f>", "<C-f>zz", desc = "Move down a page" },
    { "n", "<C-u>", "<C-u>zz", desc = "Move up a half page" },
    { "n", "<C-d>", "<C-d>zz", desc = "Move down a half page" },

    -- recenter cursor on search
    { "n", "n", "nzz", desc = "Recenter on search" },
    { "n", "N", "Nzz", desc = "Recenter on search" },
    { "n", "*", "*zz", desc = "Recenter on search" },
    { "n", "#", "#zz", desc = "Recenter on search" },
    { "n", "g*", "g*zz", desc = "Recenter on search" },
    { "n", "g#", "g#zz", desc = "Recenter on search" },

    -- allow moving of highlighted blocks
    { "v", "J", ":m '>+1<CR>gv=gv", desc = "Move highlighted block down 1 line" },
    { "v", "K", ":m '<-2<CR>gv=gv", desc = "Move highlighted block up 1 line" },

    -- misc
    { "t", "<Esc>", "<C-\\><C-n>", nowait = true, { desc = "Exit terminal insert mode" }  },
    { {"n", "v"}, "<Space>", "<Nop>", silent = true },
    { "n", "<leader>n", ":noh<Cr>", { desc = "Clear search highlight on leader-n" } } ,
    { "n", "<Esc>", ":noh<Cr>", { desc = "Clear search highlight on escape", silent = true } } ,

    -- diagnostics
    { "n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" }  },
    { "n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" } },
    { "n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic msg" }  },
    { "n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics List" } },

    -- LSP settings
    { "n", "gd", function() vim.lsp.buf.definition() end, { desc = "LSP jump to definition" } },

    -- Toggle Netrw
    {
        "n", "<C-n>",
        function()
            if vim.bo.filetype == "netrw" then
                vim.cmd("bd")
            else
                vim.cmd("Explore")
            end
        end,
        desc = { "Toggle netrw" }
    },
}

-- Loop through the general_keymaps and set them
for _, table in pairs(M) do
    for _, keymap_data in pairs(table) do
        vim.keymap.set(unpack(keymap_data))
    end
end

return M
