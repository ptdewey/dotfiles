return {
    {
        -- dir = "~/projects/pendulum-nvim.git/main",
        "ptdewey/pendulum-nvim",
        branch = "main",
        config = function()
            require("pendulum").setup({
                log_file = vim.fn.expand("$HOME/.pendulum-log.csv"),
                timeout_len = 180,
                timer_len = 120,
                gen_reports = true,
                top_n = 5,
                top_hours = 10,
                time_zone = "America/New_York",
                time_format = "12h",
                report_section_excludes = {},
                report_excludes = {
                    branch = { "unknown_branch" },
                    directory = {},
                    file = {},
                    filetype = { "unknown_filetype" },
                    project = { "unknown_project" },
                },
            })
        end,
    },
}
