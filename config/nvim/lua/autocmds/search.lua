-- remove search highlight on instert or moving cursor
vim.api.nvim_create_autocmd({"InsertEnter", "CursorMoved"}, {
    callback = function()
        local function s()
            return vim.cmd("nohlsearch")
        end
        return vim.schedule(s)
    end
})

-- TODO: add back highlight on n/N search
