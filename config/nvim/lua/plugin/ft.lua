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
                install_path = "~/.nix-profile/bin/glow",
            })
            vim.keymap.set(
                "n",
                "<F6>",
                ":Glow<CR>",
                { desc = "Open Glow Preview" }
            )
        end,
    },

    -- jupyter notebooks
    -- {
    --     "GCBallesteros/jupytext.nvim",
    --     -- doesn't seem to work with any kind of lazy loading
    --     -- ft = { "jupyter", "python" },
    --     config = function()
    --         require("jupytext").setup({})
    --     end,
    -- },
    -- {
    --     "benlubas/molten-nvim",
    --     ft = { "python" },
    --     version = "^1.0.0",
    --     build = ":UpdateRemotePlugins",
    --     init = function()
    --         -- this is an example, not a default. Please see the readme for more configuration options
    --         vim.g.molten_output_win_max_height = 12
    --
    --         vim.keymap.set("n", "<leader>ip", function()
    --             local venv = os.getenv("VIRTUAL_ENV")
    --             if venv ~= nil then
    --                 -- in the form of /home/benlubas/.virtualenvs/VENV_NAME
    --                 venv = string.match(venv, "/.+/(.+)")
    --                 vim.cmd(("MoltenInit %s"):format(venv))
    --             else
    --                 vim.cmd("MoltenInit python3")
    --             end
    --         end, {
    --             desc = "Initialize Molten for python3",
    --             silent = true,
    --         })
    --
    --         vim.keymap.set(
    --             "n",
    --             "<localleader>mi",
    --             ":MoltenInit<CR>",
    --             { silent = true, desc = "Initialize the plugin" }
    --         )
    --         vim.keymap.set(
    --             "n",
    --             "<localleader>e",
    --             ":MoltenEvaluateOperator<CR>",
    --             { silent = true, desc = "run operator selection" }
    --         )
    --         vim.keymap.set(
    --             "n",
    --             "<localleader>rl",
    --             ":MoltenEvaluateLine<CR>",
    --             { silent = true, desc = "evaluate line" }
    --         )
    --         vim.keymap.set(
    --             "n",
    --             "<localleader>rr",
    --             ":MoltenReevaluateCell<CR>",
    --             { silent = true, desc = "re-evaluate cell" }
    --         )
    --         vim.keymap.set(
    --             "x",
    --             "<localleader>r",
    --             ":<C-u>MoltenEvaluateVisual<CR>gv",
    --             { silent = true, desc = "evaluate visual selection" }
    --         )
    --     end,
    -- },
}
