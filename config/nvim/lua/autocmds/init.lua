local autocmds_dir = vim.fn.stdpath("config") .. "/lua/autocmds"
local files = vim.fn.split(vim.fn.globpath(autocmds_dir, "*.lua"), "\n")
for _, file in ipairs(files) do
    local filename = vim.fn.fnamemodify(file, ":t:r")
    if filename ~= "init" then
        require("autocmds." .. filename)
    end
end
