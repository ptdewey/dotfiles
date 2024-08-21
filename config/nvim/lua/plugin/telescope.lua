-- Telescope
return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",

        lazy = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable "make" == 1
                end,
            },
        },

        -- load on keybinds
        keys = {
            { "<leader>?", desc = "[?] Find recently opened files" },
            { "<leader>b", desc = "Search [B]uffers" },
            { "<leader>sb", desc = "Fuzzily [S]earch in current [B]uffer" },
            { "<leader>gf", desc = "Search [G]it [F]iles" },
            { "<leader>ff", desc = "[F]ind [F]iles" },
            { "<leader>sh", desc = "[S]earch [H]elp" },
            { "<leader>sw", desc = "[S]earch current [W]ord" },
            { "<leader>ss", desc = "[S]earch [S]tring" },
            { "<leader>sg", desc = "[S]earch by [G]rep" },
            { "<leader>sd", desc = "[S]earch [D]iagnostics" },
            { "<leader>sr", desc = "[S]earch [R]esume" },
            { "<leader>gd", desc = "[G]oto [D]efinition" },
            { "<leader>gr", desc = "[G]oto [R]eferences" },
            { "<leader>D", desc = "Type [D]efinition" },
            { "<leader>ds", desc = "[D]ocument [S]ymbols" },
            { "<leader>ws", desc = "[W]orkspace [S]ymbols" },
            { "<leader>gI", desc = "[G]oto [I]mplementation" },
        },

        -- plugin configuration
        config = function()
            require("telescope").setup {
                defaults = {
                    mappings = {
                        i = {
                            ["<C-u>"] = false,
                            ["<C-d>"] = false,
                        },
                    },
                    -- TODO: figure out if this can be done on a per-bind basis
                    -- initial_mode = "normal",
                },
            }

            -- Enable telescope fzf native, if installed
            pcall(require("telescope").load_extension, "fzf")

            -- See `:help telescope.builtin`
            vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles,
                { desc = "[?] Find recently opened files" })
            vim.keymap.set("n", "<leader>b", require("telescope.builtin").buffers,
                { desc = "Search [B]uffers" })
            vim.keymap.set("n", "<leader>sb", function()
                -- You can pass additional configuration to telescope to change theme, layout, etc.
                require("telescope.builtin").current_buffer_fuzzy_find(
                    require("telescope.themes").get_dropdown {
                        winblend = 10,
                        previewer = false,
                    })
            end, { desc = "Fuzzily [S]earch in current [B]uffer" })
            vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_files,
                { desc = "Search [G]it [F]iles" })
            vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files,
                { desc = "[F]ind [F]iles" })
            -- { desc = "[S]earch [F]iles" })
            vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags,
                { desc = "[S]earch [H]elp" })
            vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string,
                { desc = "[S]earch current [W]ord" })
            vim.keymap.set("n", "<leader>ss", function()
                require("telescope.builtin").grep_string {
                    shorten_path = true,
                    word_match = "-w",
                    only_sort_text = true,
                    search = ""
                }
            end,
                { desc = "[S]earch [S]tring" })
            vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep,
                { desc = "[S]earch by [G]rep" })
            vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics,
                { desc = "[S]earch [D]iagnostics" })
            vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume,
                { desc = "[S]earch [R]esume" })

            -- lsp keybinds
            vim.keymap.set("n", "gd", function()
                require("telescope.builtin").lsp_definitions()
                vim.cmd("normal! zz")
            end, { desc = "[G]oto [D]efinition" })
            vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "[G]oto [R]eferences" })
            vim.keymap.set("n", "gI", require("telescope.builtin").lsp_implementations, { desc = "[G]oto [I]mplementation" })
            vim.keymap.set("n", "<leader>D", require("telescope.builtin").lsp_type_definitions, { desc = "Type [D]efinition" })
            vim.keymap.set("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, { desc = "[D]ocument [S]ymbols" })
            vim.keymap.set("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, { desc = "[W]orkspace [S]ymbols" })

        end
    },
}
