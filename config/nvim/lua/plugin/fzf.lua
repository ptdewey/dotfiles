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
                    --
                    actions = {
                        ["default"] = function(selected)
                            local trimmed = selected[1]:match("^%s*(.-)$")
                            require("fzf-lua").actions.file_edit(trimmed)
                        end,
                    },
                },
            })

            vim.keymap.set("n", "<leader>sg", function()
                -- fzf.grep_project({
                fzf.live_grep({
                    -- search = { "" },
                    fzf_opts = { ["--nth"] = "2.." },
                    winopts = {
                        preview = {
                            horizontal = "right:40%",
                        },
                    },
                })
            end, { desc = "[S]earch [G]rep" })

            vim.keymap.set("n", "<leader>sh", function()
                fzf.help_tags({
                    winopts = {
                        preview = {
                            horizontal = "right:60%",
                        },
                    },
                })
            end, { desc = "[S]earch [H]elp tags" })

            vim.keymap.set("n", "<leader>f", function()
                fzf.files({
                    winopts = {
                        preview = {
                            horizontal = "right:60%",
                        },
                    },
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
                fzf.live_grep({
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
        end,
    },
}
