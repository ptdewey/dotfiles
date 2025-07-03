return {
    {
        "andythigpen/nvim-coverage",
        -- TODO: load on custom event where cover.out file exists (or on "Coverage" command)
        cmd = {
            "Coverage",
            "CoverageLoad",
            "CoverageToggle",
            "CoverageShow",
            "CoverageSummary",
        },
        config = function()
            require("coverage").setup({
                auto_reload = true,
                commands = true,
                lang = {
                    go = {
                        coverage_file = "cover.out",
                    },
                },
            })
        end,
    },
    {
        "nvim-neotest/neotest",
        cmd = { "Neotest" },
        keys = {
            { "<leader>tr", desc = "[T]est [R]un" },
            { "<leader>ts", desc = "[T]est [S]etup" },
            { "<leader>th", desc = "[T]est [H]ere" },
            { "<leader>ta", desc = "[T]est [A]ll" },
            { "<leader>tc", desc = "[T]oggle [C]overage" },
        },
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            {
                "fredrikaverpil/neotest-golang",
                dependencies = {
                    "andythigpen/nvim-coverage",
                },
            },
        },

        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("neotest").setup({
                adapters = {
                    require("neotest-golang")({
                        runner = "go",
                        go_test_args = {
                            "-v",
                            "-race",
                            "-count=1",
                            "-coverpkg=./...",
                            "-coverprofile=" .. vim.fn.getcwd() .. "/cover.out",
                        },
                    }),
                },
            })

            local coverage_loaded = false
            local setup_tests = function()
                local win = vim.api.nvim_get_current_win()
                if not coverage_loaded then
                    require("coverage").load(false)
                    coverage_loaded = true
                end
                require("coverage").toggle()
                require("neotest").summary.toggle()
                vim.api.nvim_set_current_win(win)
            end

            vim.api.nvim_create_user_command("TestsSetup", function()
                setup_tests()
            end, {
                desc = "Open the testing summary and start show coverage",
            })
            vim.api.nvim_create_user_command("TestsRunFile", function()
                require("neotest").run.run(vim.fn.expand("%"))
            end, {
                desc = "Run all tests in the current file with neotest",
            })

            vim.keymap.set("n", "<leader>th", function()
                require("neotest").run.run()
            end, { desc = "[T]est [H]ere" })
            -- TODO: make this run alternate file tests as well (i.e. in foo.go run foo_test.go, otherwise do nothing)
            vim.keymap.set("n", "<leader>tr", function()
                require("neotest").run.run(vim.fn.expand("%"))
                -- run_file_tests()
            end, { desc = "[T]est [R]un", silent = true })
            vim.keymap.set("n", "<leader>ta", function()
                require("neotest").run.run({ suite = true })
            end, { desc = "[T]est [A]ll" })
            vim.keymap.set(
                "n",
                "<leader>ts",
                setup_tests,
                { desc = "[T]ests [S]etup", silent = true }
            )
            vim.keymap.set("n", "<leader>tc", function()
                require("coverage").toggle()
            end, { desc = "[T]oggle [C]overage" })

            -- TODO: "<leader>tf" for jumping to paired test file (like that one plugin does, shouldn't be too hard for go)
        end,
    },
}
