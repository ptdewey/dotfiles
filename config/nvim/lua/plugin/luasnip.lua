-- snippets
return {
    {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",

        config = function()
            local ls = require("luasnip")

            -- plugin setup
            ls.setup({
                -- load snippets defined for other languages
                -- TODO: fix this
                load_ft_func = require("luasnip.extras.filetype_functions").extend_load_ft({
                    markdown = { "c", "cuda", "tex" },
                    rmd = { "r", "tex" },
                    cuda = { "c" },
                }),
            })

            -- keymaps for navigating editable regions
            -- jump down
            vim.keymap.set({ "i", "s" }, "<A-j>", function()
                if ls.expand_or_jumpable() then
                    ls.expand_or_jump()
                end
            end, { silent = true, noremap = true })

            -- jump up
            vim.keymap.set({ "i", "s" }, "<A-k>", function()
                if ls.jumpable(-1) then
                    ls.jump(-1)
                end
            end, { silent = true, noremap = true })

            -- cycle choices
            vim.keymap.set({ "i", "s" }, "<A-l>", function()
                if ls.choice_active() then
                    ls.change_choice(1)
                end
            end, { silent = true, noremap = true })
        end,
    },
}
