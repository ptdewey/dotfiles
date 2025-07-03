return {
    -- {
    --     "iamcco/markdown-preview.nvim",
    --     cmd = {
    --         "MarkdownPreviewToggle",
    --         "MarkdownPreview",
    --         "MarkdownPreviewStop",
    --     },
    --     build = "cd app && npm install",
    --     init = function()
    --         vim.g.mkdp_filetypes = { "markdown" }
    --     end,
    --     config = function()
    --         vim.g.mkdp_auto_close = 0
    --         vim.g.mkdp_preview_options = { disable_sync_scroll = 1 }
    --     end,
    --     ft = { "markdown" },
    -- },

    {
        "ellisonleao/glow.nvim",
        ft = { "markdown" },
        config = function()
            require("glow").setup({
                -- install_path = "~/.nix-profile/bin/glow",
            })
            vim.keymap.set(
                "n",
                "<F6>",
                ":Glow<CR>",
                { desc = "Open Glow Preview" }
            )
        end,
    },
}
