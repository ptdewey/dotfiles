return {
    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        priority = 49,
    },

    {
        "ellisonleao/glow.nvim",
        ft = { "markdown" },
        config = function()
            require("glow").setup()
            vim.keymap.set(
                "n",
                "<F6>",
                ":Glow<CR>",
                { desc = "Open Glow Preview" }
            )
        end,
    },

    {
        "obsidian-nvim/obsidian.nvim",
        version = "*",
        lazy = true,
        ft = "markdown",
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
        --   -- refer to `:h file-pattern` for more examples
        --   "BufReadPre path/to/my-vault/*.md",
        --   "BufNewFile path/to/my-vault/*.md",
        -- },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("obsidian").setup({
                workspaces = {
                    {
                        name = "notes",
                        path = "~/notes",
                    },
                },

                notes_subdir = "notes",

                daily_notes = {
                    folder = "notes/daily",
                    -- daily_format = "",
                    -- alias_format = "",
                    -- default_tags = { "" },
                    -- template = nil,
                },

                completion = {
                    nvim_cmp = false,
                    blink = true,
                    min_chars = 2,
                },

                new_notes_location = "notes_subdir",

                picker = {
                    name = "fzf-lua",
                },

                ui = {
                    enable = false,
                    -- bullets = { char = "-", hl_group = "Keyword" },
                },
            })
        end,
    },
}
