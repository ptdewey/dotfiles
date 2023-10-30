-- terminal window plugin
return {
    "ptdewey/nvterm",
    config = function ()
        require("nvterm").setup()
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
