-- fast comment
return {
    {
        "numToStr/Comment.nvim",
        keys = {
            { "<leader>/", mode = { "n", "x" }, desc = "Toggle Comment" },
        },
        config = function()
            require("Comment").setup()
            vim.keymap.set("n", "<leader>/", "gcc", {
                desc = "toggle comment",
                remap = true,
            })
            vim.keymap.set("x", "<leader>/", "gc", {
                desc = "toggle comment",
                remap = true,
            })
        end,
    },
}
