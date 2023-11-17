-- fast 2 character searches
return {
    'ggandor/leap.nvim',
    config = function()
        require('leap').add_default_mappings()
        -- delete visual mode leap keybind because I don't like it
        vim.keymap.del({'x', 'o'}, 'x')
        vim.keymap.del({'x', 'o'}, 'X')
    end,
    lazy = false,
    -- TODO: rebind jump to next/prev binds since they currently use
    -- space which is reserved
}
