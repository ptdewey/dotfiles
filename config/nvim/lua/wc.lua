local function get_visual_selection()
    local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
    local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))
    if start_row > end_row or (start_row == end_row and start_col > end_col) then
        start_row, start_col, end_row, end_col = end_row, end_col, start_row, start_col
    end
    local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
    if #lines == 0 then return '' end
    if #lines == 1 then
        return lines[1]:sub(start_col, end_col)
    else
        lines[1] = lines[1]:sub(start_col)
        lines[#lines] = lines[#lines]:sub(1, end_col)
    end
    return table.concat(lines, "\n")
end

-- Ensure your Lua function is globally accessible or properly scoped
local function run_wc_on_visual_selection()
    local visual_selection = get_visual_selection() -- This should be your function to capture visual text

    -- The command to pass the visual selection to `wc`. Adjust as necessary.
    local command = "wc"
    local result = vim.fn.systemlist(command, visual_selection)

    if vim.v.shell_error ~= 0 then
        print("Error running wc on selection")
    else
        print("WC Output:", table.concat(result, "\n"))
    end
end

-- Add a command in Neovim to call this function
vim.api.nvim_create_user_command(
    'WCOnVisual',
    run_wc_on_visual_selection,
    {range = false}
)

 
vim.api.nvim_set_keymap('v', '<Leader>wc', ":WCOnVisual<CR>", { noremap = true, silent = true })

return {}
