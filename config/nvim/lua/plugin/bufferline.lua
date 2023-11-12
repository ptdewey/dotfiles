local bufferline = require("bufferline")
return {
    bufferline.setup({
        options = {
            always_show_bufferline = false,
            buffer_close_icon = '',
            separator_style = "vertical", -- alternative "vertical, slope"
            style_preset = {
                bufferline.style_preset.no_italic,
                -- bufferline.style_preset.no_bold,
            },
        },
    })
}