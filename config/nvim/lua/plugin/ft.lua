-- various filetype specific plugins
return {
    -- knit r files
    {
        "ptdewey/knitr-nvim",
        -- branch = "dev",
        branch = "main",

        -- load for correct file types only
        ft = { "r", "rmd" },

        dependencies = {
            "nvim-lua/plenary.nvim",
        },

        config = function()
            require("knitr").setup()
            vim.keymap.set("n", "<F6>", ":KnitRpdf<CR>", { noremap = true })
        end,

    },

    -- markdown previewer
    {
        "ellisonleao/glow.nvim",
        ft = { "markdown" },
        config = function()
            require("glow").setup({
                install_path = "~/.nix-profile/bin/glow"
            })
            vim.keymap.set("n", "<F6>", ":Glow<CR>", { desc = "Open Glow Preview" })
        end,
    },

    -- compile latex files
    {
        "ptdewey/tex-compile-nvim",
        -- dir = "~/Documents/projects/tex-compile-nvim",
        ft = { "tex" },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("tex-compile-nvim").setup()
            vim.keymap.set("n", "<F6>", ":LatexCompile<CR>", { noremap = true })
            -- vim.keymap.set("n", "<F7>", ":LatexCompileLive<CR>", { noremap = true })
        end,
    },

    -- http client
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
                },
                additional_curl_options = {},
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
