-- Nice statusline
return {
    'nvim-lualine/lualine.nvim',

    opts = {
        options = {
            icons_enabled = false,
            theme = 'auto',
            -- theme = 'pywal-nvim',
            component_separators = '|',
            section_separators = '',
        },
    },
}
