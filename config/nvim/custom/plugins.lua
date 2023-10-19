local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {

    -- custom plugins
    {
        -- discord presence 
        "andweeb/presence.nvim",
        auto_update = true,
        lazy = false,
    },

    {
        -- r forwarding
        "danilka4/ts_r",
        config = function()
            local ts_r = require("ts_r")
            vim.keymap.set('n', '<leader>r', function() ts_r.open_term() end)
            vim.keymap.set('n', '<leader>q', function() ts_r.close_term() end)
            vim.keymap.set('n', '<leader>l', function() ts_r.send_line() end)
            vim.keymap.set('n', '<leader>c', function() ts_r.send_chunk() end)
            vim.keymap.set('n', '<leader>a', function() ts_r.send_all() end)
            vim.keymap.set('v', '<leader>s', function() ts_r.send_selection() end)
        end,
        lazy = false,
    },

    {
        -- TODO higlighting
        "folke/todo-comments.nvim",
        opts = {
            -- options
        },
        lazy = false,
    },

    -- {
    --     -- Java language server
    --     "mfussenegger/nvim-jdtls",
    -- },

    -- Override plugin definition options

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- format & linting
            {
                "jose-elias-alvarez/null-ls.nvim",
                config = function()
                    require "custom.configs.null-ls"
                end,
            },
        },
        config = function()
            require "plugins.configs.lspconfig"
            require "custom.configs.lspconfig"
        end, -- Override to setup mason-lspconfig
    },

    -- override plugin configs
    {
        "williamboman/mason.nvim",
        opts = overrides.mason,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = overrides.treesitter,
    },

    {
        "nvim-tree/nvim-tree.lua",
        opts = overrides.nvimtree,
    },

    -- Install a plugin
    {
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        config = function()
            require("better_escape").setup()
        end,
    },

    -- To make a plugin not be loaded
    -- {
    --   "NvChad/nvim-colorizer.lua",
    --   enabled = false
    -- },

    -- All NvChad plugins are lazy-loaded by default
    -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
    -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
    -- {
    --   "mg979/vim-visual-multi",
    --   lazy = false,
    -- }
}

return plugins
