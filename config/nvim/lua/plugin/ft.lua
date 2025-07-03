---@diagnostic disable: missing-fields
return {
    {
        "fredrikaverpil/godoc.nvim",
        version = "*",
        dependencies = {
            "ibhagwan/fzf-lua",
            "nvim-treesitter/nvim-treesitter",
        },
        build = "go install github.com/lotusirous/gostdsym/stdsym@latest",
        cmd = { "GoDoc" },
        ft = { "go" },
        config = function()
            require("godoc").setup({
                window = { type = "vsplit" },
                picker = { type = "fzf_lua" },
            })

            vim.keymap.set(
                "n",
                "<leader>cg",
                "<cmd>GoDoc<CR>",
                { desc = "View [G]o Docs" }
            )
        end,
    },

    {
        "windwp/nvim-ts-autotag",
        ft = {
            "markdown",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "html",
            "vue",
            "svelte",
        },
        config = function()
            require("nvim-ts-autotag").setup({})
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
    --         vim.g.molten_output_win_max_height = 12
    --
    --         vim.keymap.set("n", "<leader>ip", function()
    --             local venv = os.getenv("VIRTUAL_ENV")
    --             if venv ~= nil then
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
