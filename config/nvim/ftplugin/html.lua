local options = {
    tabstop = 2,
    shiftwidth = 2,
}

for k, v in pairs(options) do
    vim.opt[k] = v
end
