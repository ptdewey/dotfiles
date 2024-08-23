-- load custom autocmds
local autocmds_dir = vim.fn.stdpath("config") .. "/lua/autocmds"
local files = vim.fn.split(vim.fn.globpath(autocmds_dir, "*.lua"), "\n")

-- iterate through all files in the autocmds dir
for _, file in ipairs(files) do
    -- Extract the filename without extension to use in require
    local filename = vim.fn.fnamemodify(file, ":t:r")

    -- Skip init file to prevent recursive loading
    if filename ~= "init" then
        require("autocmds." .. filename)
    end
end
