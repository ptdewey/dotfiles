local options = {
    tabstop = 4,
    shiftwidth = 4,
}

for k, v in pairs(options) do
    vim.opt[k] = v
end
