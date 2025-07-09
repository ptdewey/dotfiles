vim.lsp.config["lua_ls"] = {
    settings = {
        Lua = {
            hint = {
                enable = true,
            },
            telemetry = { enable = false },
            globals = { "vim", "hs" },
            workspace = {
                library = {
                    vim.fn.expand(
                        "~/dotfiles/home/hammerspoon/Spoons/EmmyLua.spoon/annotations"
                    ),
                },
                checkThirdParty = false,
            },
        },
    },

    on_attach = function(client, bufnr)
        require("inlay-hints").on_attach(client, bufnr)
    end,
}
