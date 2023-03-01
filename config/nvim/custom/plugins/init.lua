return  {
    -- discord presence
    ["andweeb/presence.nvim"] = { auto_update = true },
    ["folke/todo-comments.nvim"] = {
        config = function()
            require("todo-comments").setup()
        end
    },
    -- ["danilka4/ts_r"] = {
    --     config = function()
    --         local ts_r = require("ts_r")
    --         vim.keymap.set('n', '<leader>r', function() ts_r.open_term() end)
    --         vim.keymap.set('n', '<leader>q', function() ts_r.close_term() end)
    --     end
    -- },
}

