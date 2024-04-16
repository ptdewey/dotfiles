local extensions_dir = vim.fn.stdpath('config') .. '/lua/extensions'
local files = vim.fn.split(vim.fn.globpath(extensions_dir, '*.lua'), "\n")
for _, file in ipairs(files) do
    local filename = vim.fn.fnamemodify(file, ':t:r')
    if filename ~= "init" then
        require('extensions.' .. filename)
    end
end

