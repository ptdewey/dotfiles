local extensions_dir = vim.fn.stdpath("config") .. "/lua/extras"
local files = vim.fn.split(vim.fn.globpath(extensions_dir, "*.lua"), "\n")
for _, file in ipairs(files) do
    local filename = vim.fn.fnamemodify(file, ":t:r")
    if filename ~= "init" then
        require("extras." .. filename)
    end
end
