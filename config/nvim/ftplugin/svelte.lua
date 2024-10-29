-- svelte filetype specific options
local options = {
    tabstop = 2,
    shiftwidth = 2,
}

-- apply options
for k, v in pairs(options) do
    vim.opt_local[k] = v
end
