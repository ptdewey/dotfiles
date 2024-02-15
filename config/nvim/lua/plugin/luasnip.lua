local ls = require("luasnip")

return {
    -- plugin setup
    ls.setup({
        load_ft_func =
            -- load snippets defined for other languages
            -- TODO: fix this
            require("luasnip.extras.filetype_functions").extend_load_ft({
                markdown = { "c", "cuda" },
                rmd = { "r", "tex" },
                cuda = { "c" },
            })
    }),

    -- keymaps for navigating editable regions
    -- jump next
    vim.keymap.set({ "i", "s" }, "<C-k>", function ()
        if ls.expand_or_jumpable() then
            ls.expand_or_jump()
        end
    end, { silent = true }),

    -- jump prev
    vim.keymap.set({ "i", "s" }, "<C-j>", function ()
        if ls.jumpable(-1) then
            ls.jump(-1)
        end
    end, { silent = true }),

    -- cycle choices
    vim.keymap.set({ "i", "s" }, "<C-l>", function ()
        if ls.choice_active() then
            ls.change_choice(1)
        end
    end, { silent = true }),
}
