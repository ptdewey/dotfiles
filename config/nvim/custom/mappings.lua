---@type MappingsTable
local M = {}

M.general = {
    n = {
        [";"] = { ":", "enter command mode", opts = { nowait = true } },
    },
    t = {
        ["<Esc>"] = { "<C-\\><C-n>", "Exit terminal insert mode", opts = { nowait = true } },
    },
}

-- more keybinds!

return M
