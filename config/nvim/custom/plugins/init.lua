return  {
  -- discord presence
  ["andweeb/presence.nvim"] = { auto_update = true },
  ["folke/todo-comments.nvim"] = {
    config = function()
      require("todo-comments").setup()
    end
  },
}

