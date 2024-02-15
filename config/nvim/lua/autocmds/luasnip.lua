-- luasnip autocmds

-- load snippets after luasnip is loaded
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Check if LuaSnip is available
    if pcall(require, "luasnip") then
      -- Require your snippets init file to load all snippets
      require('snippets.init')
    else
      -- Optional: Print a warning if LuaSnip is not found (useful for debugging)
      print("LuaSnip is not available.")
    end
  end
})

