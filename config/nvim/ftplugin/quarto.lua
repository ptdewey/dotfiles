-- TODO: consolidate the vim.system behavior into a function and just have params for flags
-- - create user command for quarto render and call with keymaps

---@param args table?
local function render(args)
    local cmd = { "quarto", "render" }
    if args then
        if args.file and args.file ~= "%" then
            table.insert(cmd, args.file)
        else
            table.insert(cmd, vim.fn.expand("%:p"))
        end
        if args.ft then
            table.insert(cmd, "-t")
            table.insert(cmd, args.ft)
            print("Attempting to render quarto file into " .. args.ft .. "...")
        else
            print("Attempting to render quarto file into html...")
        end
    end

    vim.system(cmd, { text = true }, function(_)
        print("Finished rendering quarto file.")
    end)
end

vim.keymap.set("n", "<leader>cx", function()
    if vim.bo.filetype ~= "quarto" then
        print("Current file is not a quarto file.")
        return
    end
    render({ ft = "pdf" })
end, { desc = "Run Quarto Render", noremap = true })

vim.keymap.set("n", "<leader>cq", function()
    if vim.bo.filetype ~= "quarto" then
        -- TODO: check for qmd files in dir, render them instead?
        print("Current file is not a quarto file.")
        return
    end
    render({})
end, { desc = "Run Quarto Render", noremap = true })
