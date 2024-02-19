-- terminal window plugin
return {
    "ptdewey/nvterm",

    lazy = true,

    config = function ()
        require("nvterm").setup({
            behavior = {
                -- go into term-insert mode upon opening terminal
                auto_insert = true,
            },
        })
    end,

    -- terminal toggle bind
    vim.keymap.set(
        {"n", "t"},
        "<A-h>",
        function ()
            require("nvterm.terminal").toggle "horizontal"
        end
    ),
}
