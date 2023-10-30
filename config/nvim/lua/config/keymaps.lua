-- key bindings

local M = {}

-- general keybindings
M.general = {
    { "n", ";", ":", remap = true, desc = "semicolon to colon in normal mode" },

    -- buffer switching
    { "n", "<tab>", ":bnext <CR>", remap = true, desc = "tab to switch buffers" },
    { "n", "<S-tab>", ":bprev <CR>", remap = true, desc = "shift tab to switch buffers" },

    -- window movement
    { "n", "<C-h>", "<C-w>h", remap = true, desc = "move to left window" },
    { "n", "<C-l>", "<C-w>l", remap = true, desc = "move to right window" },
    { "n", "<C-j>", "<C-w>j", remap = true, desc = "move to lower window" },
    { "n", "<C-k>", "<C-w>k", remap = true, desc = "move to upper window" },

    -- move down visual lines
    { "n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true } },
    { "n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true } },

    -- misc
    { "t", "<Esc>", "<C-\\><C-n>", nowait = true, desc = "Exit terminal insert mode" },
    { {"n", "v"}, "<Space>", "<Nop>", silent = true, desc = "Unbind space"},
    { "n", "<Esc><Esc>", ":noh<Cr>", desc = "Clear search highlight on double escape"},

    -- diagnostics
    { "n", "[d", vim.diagnostic.goto_prev, desc = "Go to previous diagnostic message" },
    { "n", "]d", vim.diagnostic.goto_next, desc = "Go to next diagnostic message" },
    { "n", "<leader>e", vim.diagnostic.open_float, desc = "Open floating diagnostic msg" },
    { "n", "<leader>q", vim.diagnostic.setloclist, desc = "Open diagnostics List" },
}


-- Loop through the general_keymaps and set them
for _, table in pairs(M) do
    for _, keymap_data in pairs(table) do
        vim.keymap.set(unpack(keymap_data))
    end
end

return M
