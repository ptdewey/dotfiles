-- quick file switching
return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },

        config = function()
            local harpoon = require("harpoon")
            harpoon:setup({
                settings = {
                    save_on_toggle = true,
                    sync_on_ui_close = true,
                },
                -- BufLeave = HarpoonPartialConfigItem:BufLeave()
            })

            -- keymaps
            vim.keymap.set("n", "<leader>a", function()
                harpoon:list():append()
            end, { desc = '[H]arpoon [A]dd Mark' })

            vim.keymap.set("n", "<C-e>", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end, { desc = "[H]arpoon [T]oggle menu" })

            vim.keymap.set("n", "<C-h>", function()
                harpoon:list():select(1)
            end, { desc = "[H]arpoon [h]jkl nav" })

            vim.keymap.set("n", "<C-j>", function()
                harpoon:list():select(2)
            end, { desc = "[H]arpoon h[j]kl nav" })

            vim.keymap.set("n", "<C-k>", function()
                harpoon:list():select(3)
            end, { desc = "[H]arpoon hj[k]l nav" })

            vim.keymap.set("n", "<C-l>", function()
                harpoon:list():select(4)
            end, { desc = "[H]arpoon hjk[l] nav" })
        end,
    }
}
