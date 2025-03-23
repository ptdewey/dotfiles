local M = {}

---@param args table
function M.rename_file(args)
    local new_name = nil
    if #args == 0 then
        new_name = vim.fn.input("New name: ")
        if not new_name or new_name == "" then
            vim.print("No file name provided.")
            return
        end
    else
        new_name = args -- TODO: use previous path + new file name (separate function for move)
    end

    local old_name = vim.fn.expand("%")

    vim.cmd("silent f " .. new_name)
    vim.cmd("w")
    vim.cmd("silent !rm " .. old_name)
end

vim.api.nvim_create_user_command("RenameFile", function(opts)
    M.rename_file(opts.args)
end, { nargs = "?" })

return M
