return {
    {
        "mistweaverco/kulala.nvim",
        ft = "http",
        config = function()
            require("kulala").setup({
                icons = {
                    inlay = {
                        loading = "...",
                        done = ""
                    },
                    lualine = "",
                }
            })
        end,

        -- NOTE: Potential plugin improvements
        -- - return status code instead of icon (or in addition to)
        -- - text coloring for icons? (hlgroups)
        -- - output in temporary buffer
        --   - toggle keybind (close 'ui' window)
        -- - option for split direction
    }
}
