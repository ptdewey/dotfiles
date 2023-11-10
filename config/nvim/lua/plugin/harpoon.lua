-- fast navigation
return {
    "ThePrimeagen/harpoon",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    config = function()
        require("harpoon").setup({})
    end,

    -- keymaps
    keys = {
        { "<leader>ha", function() require('harpoon.mark').add_file() end,  desc = '[H]arpoon [A]dd Mark' },
        { "<leader>ht", function() require('harpoon.ui').toggle_quick_menu() end, desc = '[H]arpoon [T]oggle Menu' },
        { "<leader>hh", function() require('harpoon.ui').nav_file(1) end, desc = '[H]arpoon [h]jkl nav' },
        { "<leader>hj", function() require('harpoon.ui').nav_file(2) end, desc = '[H]arpoon h[j]kl nav' },
        { "<leader>hk", function() require('harpoon.ui').nav_file(3) end, desc = '[H]arpoon hj[k]l nav' },
        { "<leader>hl", function() require('harpoon.ui').nav_file(4) end, desc = '[H]arpoon hjk[l] nav' },
    },
}
