-- load snippets after luasnip is loaded
vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
        if pcall(require, "luasnip") then
            require('snippets.init')
        else
            print("LuaSnip is not available.")
        end
    end
})

