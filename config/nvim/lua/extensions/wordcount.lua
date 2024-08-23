local M = {}

function M.get_visual_selection()
    local s_start = vim.fn.getpos("'<")
    local s_end = vim.fn.getpos("'>")
    local n_lines = math.abs(s_end[2] - s_start[2]) + 1
    local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
    lines[1] = string.sub(lines[1], s_start[3], -1)
    if n_lines == 1 then
        lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
    else
        lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
    end
    return table.concat(lines, "\n")
end

function M.count_words_visual_selection()
    local text = M.get_visual_selection()
    local result = vim.fn.system("echo " .. vim.fn.shellescape(text) .. " | wc -w")
    result = result:gsub("%s+", "")
    vim.api.nvim_command("echo 'Word count: " .. result .. "'")
end

vim.api.nvim_create_user_command(
    "CountWordsInSelection",
    M.count_words_visual_selection,
    { nargs = 0 }
)

vim.api.nvim_set_keymap(
    "v",
    "<leader>wc",
    ":<C-u>CountWordsInSelection<CR>",
    { noremap = true, silent = true }
)

return M
