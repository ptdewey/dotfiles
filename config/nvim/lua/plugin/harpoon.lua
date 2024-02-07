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
        { "<leader>fa", function() require('harpoon.mark').add_file() end,  desc = 'Harpoon [A]dd Mark' },
        { "<leader>fm", function() require('harpoon.ui').toggle_quick_menu() end, desc = 'Harpoon Toggle [M]enu' },
        { "<leader>fh", function() require('harpoon.ui').nav_file(1) end, desc = 'Harpoon [h]jkl nav' },
        { "<leader>fj", function() require('harpoon.ui').nav_file(2) end, desc = 'Harpoon h[j]kl nav' },
        { "<leader>fk", function() require('harpoon.ui').nav_file(3) end, desc = 'Harpoon hj[k]l nav' },
        { "<leader>fl", function() require('harpoon.ui').nav_file(4) end, desc = 'Harpoon hjk[l] nav' },
        { "<leader>ft", function() require("harpoon.term").gotoTerminal(1) end, desc = "[H]arpoon [t]erm" },
    },
}
