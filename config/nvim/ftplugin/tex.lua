local function compile()
    local cmd = { "latexmk", "-pdf" }
    print("Compiling to pdf...")
    vim.system(cmd, { text = true }, function(obj)
        if obj.stderr ~= "" then
            print("Failed to compile: ", obj.stderr)
            return
        end

        print("Finished compilation.")
        cmd = { "latexmk", "-c" }
        vim.system(cmd, { text = true }, function(o)
            if obj.stderr ~= "" then
                print("Failed to clean latex build files: ", o.stderr)
            end
        end)
    end)
end

vim.api.nvim_create_user_command("LatexCompile", compile, {})

vim.keymap.set("n", "<F6>", ":LatexCompile<CR>", { noremap = true })
