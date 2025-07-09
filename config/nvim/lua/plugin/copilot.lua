return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        keys = { { "<leader>ce", desc = "[C]opilot [E]nable" } },
        config = function()
            require("copilot").setup({
                panel = { enabled = false },
                suggestion = {
                    enabled = false,
                    auto_trigger = true,
                    keymap = {
                        accept = "<M-h>",
                        accept_line = "<M-l>",
                        next = "<M-j>",
                        prev = "<M-k>",
                        dismiss = "<C-/>",
                    },
                },
                filetypes = { markdown = true, typst = true, help = true },
            })

            vim.keymap.set(
                "n",
                "<leader>ce",
                "<cmd>Copilot enable<CR>",
                { desc = "[C]opilot [E]nable" }
            )
            vim.keymap.set(
                "n",
                "<leader>cd",
                "<cmd>Copilot disable<CR>",
                { desc = "[C]opilot [D]isable" }
            )
        end,
    },
}
