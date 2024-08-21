-- snippets
return {
    {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",

        config = function()
            local ls = require("luasnip")

            -- plugin setup
            ls.setup({
                load_ft_func =
                    -- load snippets defined for other languages
                    -- TODO: fix this
                    require("luasnip.extras.filetype_functions").extend_load_ft({
                        markdown = { "c", "cuda", "tex" },
                        rmd = { "r", "tex" },
                        cuda = { "c" },
                    })
            })

            -- keymaps for navigating editable regions
            -- jump down
            vim.keymap.set({ "i", "s" }, "<C-j>", function ()
                if ls.expand_or_jumpable() then
                    ls.expand_or_jump()
                end
            end, { silent = true })

            -- jump up
            vim.keymap.set({ "i", "s" }, "<C-k>", function ()
                if ls.jumpable(-1) then
                    ls.jump(-1)
                end
            end, { silent = true })

            -- cycle choices
            vim.keymap.set({ "i", "s" }, "<C-l>", function ()
                if ls.choice_active() then
                    ls.change_choice(1)
                end
            end, { silent = true })
        end,
    },
}
