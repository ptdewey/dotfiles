return {
    {
        "cbochs/grapple.nvim",
        opts = {
            scope = "git", -- TODO: try "git_branch" (and figure out cwd based scope as well?)
            icons = false,
            status = false,
        },
        keys = {
            { "<leader>a", "<cmd>Grapple toggle<cr>", desc = "Tag a file" },
            {
                "<C-e>",
                "<cmd>Grapple toggle_tags<cr>",
                desc = "Toggle tags menu",
            },

            {
                "<C-h>",
                "<cmd>Grapple select index=1<cr>",
                desc = "Select first tag",
            },
            {
                "<C-j>",
                "<cmd>Grapple select index=2<cr>",
                desc = "Select second tag",
            },
            {
                "<C-k>",
                "<cmd>Grapple select index=3<cr>",
                desc = "Select third tag",
            },
            {
                "<C-l>",
                "<cmd>Grapple select index=4<cr>",
                desc = "Select fourth tag",
            },

            -- FIX: cycling keybinds don't work with Wezterm
            -- {
            --     "<leader>h",
            --     "<cmd>Grapple cycle_tags next<cr>",
            --     desc = "Go to next tag",
            -- },
            -- {
            --     "<leader>j",
            --     "<cmd>Grapple cycle_tags prev<cr>",
            --     desc = "Go to previous tag",
            -- },
        },
    },
}
