-- TODO: consolidate the vim.system behavior into a function and just have params for flags
-- - create user command for quarto render and call with keymaps

vim.keymap.set("n", "<leader>cx", function()
    if vim.bo.filetype ~= "quarto" then
        print("Current file is not a quarto file.")
        return
    end
    print("Rendering quarto file...")
    vim.system(
        { "quarto", "render", vim.fn.expand("%:p"), "-t", "pdf" },
        { text = true },
        function(_)
            print("Finished rendering quarto file.")
        end
    )
end, { desc = "Run Quarto Render", noremap = true })

vim.keymap.set("n", "<leader>cq", function()
    if vim.bo.filetype ~= "quarto" then
        print("Current file is not a quarto file.")
        return
    end
    print("Rendering quarto file...")
    vim.system(
        { "quarto", "render", vim.fn.expand("%:p") },
        { text = true },
        function(_)
            print("Finished rendering quarto file.")
        end
    )
end, { desc = "Run Quarto Render", noremap = true })

vim.keymap.set("n", "<leader>cz", function()
    if vim.bo.filetype ~= "quarto" then
        print("Current file is not a quarto file.")
        return
    end
    local filepath = vim.fn.expand("%:p")
    local filename = vim.fn.fnamemodify(filepath, ":t")
    local html_filename = vim.fn.fnamemodify(filename, ":r") .. ".html"

    vim.system({ "firefox", html_filename }, {})
end, { desc = "Open quarto html presentation", noremap = true })
