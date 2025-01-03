-- treesitter
local M = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    priority = 999,
}

-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
    require("nvim-treesitter.configs").setup({
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = { "markdown", "html", "lua", "yaml", "latex" },

        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = true,

        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<c-space>",
                node_incremental = "<c-space>",
                scope_incremental = "<c-s>",
                node_decremental = "<M-space>",
            },
        },
    })
    -- local parser_config =
    --     require("nvim-treesitter.parsers").get_parser_configs()
    -- parser_config.plantuml = {
    --     install_info = {
    --         url = "https://github.com/ptdewey/tree-sitter-plantuml.git",
    --         -- url = "/home/patrick/projects/tree-sitter-plantuml.git/main",
    --         -- location = "plantuml.so",
    --         files = { "src/parser.c" },
    --         branch = "main",
    --     },
    --     filetype = "plantuml",
    --     highlight = {
    --         enable = true,
    --     },
    -- }
end, 0)

return M
