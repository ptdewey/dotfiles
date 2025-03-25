return {
    {
        "ibhagwan/fzf-lua",
        config = function()
            local fzf = require("fzf-lua")
            fzf.setup({
                winopts = {
                    height = 0.95,
                    width = 0.95,
                    preview = {
                        horizontal = "right:50%",
                    },
                },
                fzf_opts = {
                    ["--no-info"] = "",
                    ["--info"] = "hidden",
                    ["--header"] = " ",
                    -- ["--layout"] = "default",
                    -- ["--layout"] = "reverse",
                    ["--layout"] = "reverse-list",
                },
                files = {
                    git_icons = false,
                    file_icons = false,
                    formatter = "path.filename_first",
                },
                grep = {
                    --     rg_opts = "--sort-files --hidden --column --line-number --no-heading "
                    --         .. "--color=always --smart-case -g '!{.git,node_modules}/*'",
                    formatter = "path.filename_first",
                },
                file_ignore_patterns = { "%.pdf$" },
            })

            vim.keymap.set("n", "<leader>sr", function()
                fzf.live_grep({
                    fzf_opts = { ["--nth"] = "2.." },
                    winopts = { preview = { horizontal = "right:40%" } },
                })
            end, { desc = "[S]earch [R]egex" })

            vim.keymap.set("n", "<leader>sg", function()
                fzf.grep_project({
                    fzf_opts = { ["--nth"] = "2.." },
                    winopts = { preview = { horizontal = "right:40%" } },
                })
            end, { desc = "[S]earch [G]rep" })

            vim.keymap.set("n", "<leader>sh", function()
                fzf.help_tags({
                    winopts = { preview = { horizontal = "right:60%" } },
                })
            end, { desc = "[S]earch [H]elp tags" })

            vim.keymap.set("n", "<leader>f", function()
                fzf.files({
                    winopts = { preview = { horizontal = "right:60%" } },
                })
            end, { desc = "[S]earch [F]iles" })

            vim.keymap.set("n", "<leader>d", function()
                fzf.diagnostics_workspace({
                    winopts = {
                        preview = {
                            vertical = "down:40%",
                            layout = "vertical",
                        },
                    },
                })
            end, { desc = "Search [D]iagnostics" })

            vim.keymap.set("n", "<leader>b", function()
                fzf.buffers()
            end, { desc = "Browse [B]uffers" })

            vim.keymap.set("n", "<leader>tt", function()
                fzf.live_grep_native({
                    search = "TODO|PERF|NOTE|FIX|DOC|REFACTOR|BUG",
                    no_esc = true,
                    winopts = {
                        preview = {
                            horizontal = "right:40%",
                        },
                    },
                })
            end, { desc = "Search [T]odo", noremap = true })

            vim.keymap.set("n", "<leader>ca", function()
                fzf.lsp_code_actions()
            end, { desc = "[C]ode [A]ction preview" })

            vim.keymap.set("n", "<leader>nf", function()
                fzf.files({ cwd = "~/notes" })
            end, { desc = "Search [N]ote [F]iles" })

            vim.keymap.set("n", "<leader>ng", function()
                fzf.grep_project({ cwd = "~/notes", hidden = false })
            end, { desc = "[G]rep [N]otes" })

            vim.keymap.set("n", "gr", function()
                fzf.lsp_references()
            end, { desc = "[G]oto [R]eferences" })

            vim.keymap.set("n", "hf", function()
                fzf.files({ cwd = "~/", hidden = false })
            end, { desc = "[H]ome [F]iles" })

            vim.keymap.set("n", "hg", function()
                fzf.grep_project({ cwd = "~/", hidden = false })
            end, { desc = "[H]ome [G]rep" })
        end,
    },
}
