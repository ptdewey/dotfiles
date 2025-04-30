local options = {
    tabstop = 2,
    shiftwidth = 2,
    commentstring = "// %s",
}

for k, v in pairs(options) do
    vim.opt_local[k] = v
end

function WrapVisualSelectionWithDollar()
    local _, ls, cs = unpack(vim.fn.getpos("'<"))
    local _, le, ce = unpack(vim.fn.getpos("'>"))

    local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)

    if #lines == 1 then
        local line = lines[1]
        local new_line = line:sub(1, cs - 1)
            .. "$"
            .. line:sub(cs, ce)
            .. "$"
            .. line:sub(ce + 1)
        vim.api.nvim_buf_set_lines(0, ls - 1, le, false, { new_line })
    else
        lines[1] = lines[1]:sub(1, cs - 1) .. "$" .. lines[1]:sub(cs)
        lines[#lines] = lines[#lines]:sub(1, ce)
            .. "$"
            .. lines[#lines]:sub(ce + 1)
        vim.api.nvim_buf_set_lines(0, ls - 1, le, false, lines)
    end
end

local function setup()
    vim.keymap.set(
        "x",
        "<leader>mw",
        [[:<C-u>lua WrapVisualSelectionWithDollar()<CR>]], -- TODO: find a less bad way of doing this, i.e. no global function
        { desc = "Wrap selection with $" }
    )

    -- vim.keymap.set(
    --     "x",
    --     "<leader>mw",
    --     function() vim.cmd("lua WrapVisualSelectionWithDollar()") end,
    --     { desc = "Wrap selection with $" }
    -- )
    vim.keymap.set("n", "<leader>mw", function()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        local line = vim.api.nvim_get_current_line()
        local word = vim.fn.expand("<cword>")
        local start_col, end_col = col + 1, col + #word
        local new_line = line:sub(1, start_col - 1)
            .. "$"
            .. word
            .. "$"
            .. line:sub(end_col + 1)

        vim.api.nvim_set_current_line(new_line)
    end, { desc = "Wrap word under cursor with $" })
end

local function open_pdf()
    local filepath = vim.api.nvim_buf_get_name(0)
    if filepath:match("%.typ$") then
        local pdf_path = filepath:gsub("%.typ$", ".pdf")
        vim.system({ "zathura", pdf_path })
    end
end

vim.keymap.set("n", "<leader>co", open_pdf, { desc = "Open PDF Preview" })
vim.api.nvim_create_user_command("OpenPdf", open_pdf, {})

-- NOTE: Mason is still being used
-- vim.lsp.enable("tinymist")

setup()
