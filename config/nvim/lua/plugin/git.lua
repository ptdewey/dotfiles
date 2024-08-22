-- Git-related plugins
return {
    -- git integration
    {
        "tpope/vim-fugitive",
        keys = {
            { "<leader>gd", "<cmd>Gdiff<CR>", silent = true, desc = "View Git diff" },
            { "<leader>gs", "<cmd>Gs<CR>", silent = true, desc = "View Git status" },
            { "<leader>gl", "<cmd>Gclog<CR>", silent = true, desc = "View Git commit log" },
            { "<leader>gb", "<cmd>GBrowse<CR>", silent = true, desc = "View Current Repository in Browser" },
        },
        dependencies = {
            -- also load vim-rhubarb when lazy loading
            "tpope/vim-rhubarb",
        },
    },

    -- github integration
    {
        "tpope/vim-rhubarb",
        lazy = true,
    },

    -- add git signs to gutter
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost" },

        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            on_attach = function(bufnr)
                vim.keymap.set('n', '<leader>gp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

                -- don't override the built-in and fugitive keymaps
                local gs = package.loaded.gitsigns
                vim.keymap.set({ 'n', 'v' }, ']c', function()
                    if vim.wo.diff then
                        return ']c'
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
                vim.keymap.set({ 'n', 'v' }, '[c', function()
                    if vim.wo.diff then
                        return '[c'
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
            end,
        },
    },
}
