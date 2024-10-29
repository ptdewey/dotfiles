local options = {
    scrolloff = 5,
}

-- TODO: figure out how to do auto scroll up when near eof

for k, v in pairs(options) do
    vim.opt_local[k] = v
end
