-- fast 2 character searches
return {
    'ggandor/leap.nvim',
    config = function()
        require('leap').add_default_mappings()
    end,
    lazy = false
    -- TODO: rebind jump to next/prev binds since they currently use
    -- space which is reserved
}
