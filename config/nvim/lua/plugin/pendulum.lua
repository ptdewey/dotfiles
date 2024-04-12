-- time tracking plugin
return {
    {
        -- dir = "~/Documents/projects/pendulum-nvim",
        "ptdewey/pendulum-nvim",
        config = function()
            -- require("pendulum").setup()
            require("pendulum").setup({
                log_file = vim.fn.expand("$HOME/Documents/pendulum-log.csv"),
                timeout_len = 180,
                timer_len = 120,
            })
        end,
    },
}
