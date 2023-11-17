function DoubleNumber()
    -- Save the current cursor position
    local save_cursor = vim.fn.getpos('.')

    -- Get the current line number and column number
    local pos = vim.fn.searchpos('\\%d', 'bn', save_cursor)
    local line_number, col_number = pos[1], pos[2]

    -- Move to the beginning of the number under the cursor
    vim.fn.search('\\%d', 'bnW')

    -- Get the number under the cursor
    local current_number = vim.fn.getline('.') + 0

    -- Double the number
    local doubled_number = current_number * 2

    -- Replace the current number with the doubled number
    vim.fn.setline('.', doubled_number)

    -- Restore the cursor position
    vim.fn.setpos('.', save_cursor)
end

-- Map your function to <C-b>
-- vim.api.nvim_set_keymap('n', '<C-b>', '<cmd>lua DoubleNumber()<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', "<C-m>", "<cmd>s/d+/=submatch(0)*5/<CR>", { noremap = true, silent = true })
