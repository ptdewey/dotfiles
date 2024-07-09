-- Git-related plugins
return {
    -- git integration
    {
        "tpope/vim-fugitive",
        event = "VeryLazy",
        config = function()
            vim.keymap.set("n", "<leader>gd", "<cmd>Gdiff<CR>", { silent = true, desc = "View Git diff" })
            vim.keymap.set("n", "<leader>gs", "<cmd>Gs<CR>", { silent = true, desc = "View Git status" })
            vim.keymap.set("n", "<leader>gl", "<cmd>Gclog<CR>", { silent = true, desc = "View Git commit log" })
            vim.keymap.set("n", "<leader>gb", "<cmd>GBrowse<CR>", { silent = true, desc = "View Current Repository in Browser"})
        end,
    },

    -- github integration
    {
        "tpope/vim-rhubarb",
        event = "VeryLazy",
    },

    -- add git signs to gutter
    {
        "lewis6991/gitsigns.nvim",

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
