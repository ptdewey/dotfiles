return  {
    -- discord presence
    ["andweeb/presence.nvim"] = { auto_update = true },
    ["folke/todo-comments.nvim"] = {
        config = function()
            require("todo-comments").setup()
        end
    },
    -- require("nvim-web-devicons").set_icon {
    --     cu = {
    --         icon = "cuda", -- nvidia logo
    --         color= "#76B900", -- green
    --         cterm_color = "65", -- ???
    --         name = "Cuda"
    --     }
    -- }
}

