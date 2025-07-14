return {
    {
        "ibhagwan/fzf-lua",
        event = "VeryLazy",
        config = function()
            local fzf = require("fzf-lua")
            fzf.setup({
                winopts = {
                    height = 0.85,
                    width = 0.85,
                    preview = {
                        horizontal = "right:50%",
                    },
                },
                fzf_opts = {
                    ["--no-info"] = "",
                    ["--info"] = "hidden",
                    ["--header"] = " ",
                    -- ["--layout"] = "default",
                    ["--layout"] = "reverse-list",
                },
                files = {
                    git_icons = false,
                    file_icons = true,
                    formatter = "path.filename_first",
                },
                grep = { formatter = "path.filename_first" },
                file_ignore_patterns = { "%.pdf$" },
            })

            fzf.register_ui_select(function(_, items)
                local min_h, max_h = 0.15, 0.70
                local h = (#items + 4) / vim.o.lines
                if h < min_h then
                    h = min_h
                elseif h > max_h then
                    h = max_h
                end
                return { winopts = { height = h, width = 0.50, row = 0.40 } }
            end)

            vim.keymap.set("n", "<leader>sr", function()
                fzf.live_grep({
                    fzf_opts = { ["--nth"] = "2.." },
                    winopts = { preview = { horizontal = "right:40%" } },
                })
            end, { desc = "[S]earch [R]egex" })

            vim.keymap.set("n", "<leader>sg", function()
                fzf.grep_project({
                    fzf_opts = { ["--nth"] = "2.." },
                    winopts = {
                        preview = {
                            vertical = "down:40%",
                            layout = "vertical",
                        },
                    },
                })
            end, { desc = "[S]earch [G]rep" })

            vim.keymap.set("n", "<leader>sb", function()
                fzf.grep_curbuf({
                    winopts = {
                        height = 0.6,
                        width = 0.5,
                        preview = {
                            hidden = true,
                        },
                    },
                })
            end, { desc = "[S]earch [B]uffer" })

            vim.keymap.set("n", "<leader>sh", function()
                fzf.help_tags({
                    winopts = { preview = { horizontal = "right:60%" } },
                    actions = {
                        ["default"] = fzf.actions.buf_tabedit,
                    },
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
                fzf.grep_project({
                    search = [[\b(TODO|PERF|NOTE|FIX|DOC|REFACTOR|BUG):]],
                    no_esc = true,
                    winopts = {
                        preview = {
                            vertical = "down:35%",
                            layout = "vertical",
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

            vim.keymap.set("n", "<leader>sd", function()
                fzf.lsp_document_symbols()
            end, { desc = "[H]ome [W]orkspace symbols" })

            vim.keymap.set("n", "gr", function()
                fzf.lsp_references({
                    winopts = {
                        preview = {
                            vertical = "down:60%",
                            layout = "vertical",
                        },
                    },
                })
            end, { noremap = true, desc = "[G]oto [R]eferences" })

            vim.keymap.set("n", "gd", function()
                fzf.lsp_definitions()
                vim.cmd("normal! zz")
            end, { noremap = true, desc = "[G]oto [D]efinition" })

            vim.keymap.set("n", "<leader>gs", function()
                fzf.git_status()
            end, { noremap = true, desc = "[G]it [S]tatus" })
        end,
    },

    {
        "bassamsdata/namu.nvim",
        cmd = { "Namu" },
        keys = {
            { "<leader>ss", desc = "[S]earch [S]ymbols" },
            { "<leader>sw", desc = "[S]ymbols [W]orkspace" }
        },
        config = function()
            require("namu").setup({
                namu_symbols = { enable = true, options = {} },
                namu_ctags = { enable = true, options = {} },
            })

            vim.keymap.set("n", "<leader>ss", "<cmd>Namu symbols<cr>", {
                desc = "[S]earch [S]ymbols",
                silent = true,
            })

            vim.keymap.set("n", "<leader>sw", "<cmd>Namu workspace<cr>", {
                desc = "[S]ymbols [W]orkspace",
                silent = true,
            })

            vim.keymap.set("n", "<leader>so", "<cmd>Namu watchtower<cr>", {
                desc = "[S]earch [O]pen symbols",
                silent = true,
            })
        end,
    },
}
