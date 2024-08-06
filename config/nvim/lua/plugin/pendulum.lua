-- time tracking plugin
return {
    {
        -- dir = "~/projects/pendulum-nvim.git/dev",
        "ptdewey/pendulum-nvim",
        branch = "main",
        -- branch = "dev",
        config = function()
            require("pendulum").setup({
                log_file = vim.fn.expand("$HOME/projects/pendulum-log.csv"),
                timeout_len = 180,
                timer_len = 120,
                gen_reports = true,
                top_n = 5,
            })
        end,
    },
}
