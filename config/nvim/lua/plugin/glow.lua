-- markdown previewer
return {
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
}
