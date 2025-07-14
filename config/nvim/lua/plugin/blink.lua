return {
    {
        "saghen/blink.cmp",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "fang2hou/blink-copilot",
            "mikavilpas/blink-ripgrep.nvim",
        },

        version = "1.*",
        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = {
                preset = "none",
                ["<C-h>"] = { "select_and_accept" },
                ["<C-space>"] = {
                    "show",
                    "show_documentation",
                    "hide_documentation",
                },
                ["<C-e>"] = { "hide" },
                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<C-n>"] = { "select_next", "fallback_to_mappings" },
                ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
                ["<C-l>"] = { "show_signature", "hide_signature", "fallback" },
            },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            completion = {
                -- (Default) Only show the documentation popup when manually triggered
                documentation = { auto_show = true },
                menu = {
                    draw = {
                        align_to = "cursor",
                        columns = {
                            { "label" },
                            { "kind", "source_name", gap = 1 },
                            -- { "label_description" },
                        },

                        components = {
                            label = {
                                text = function(ctx)
                                    return require("colorful-menu").blink_components_text(
                                        ctx
                                    )
                                end,
                                highlight = function(ctx)
                                    return require("colorful-menu").blink_components_highlight(
                                        ctx
                                    )
                                end,
                            },
                            source_name = {
                                text = function(ctx)
                                    return "[" .. ctx.source_name .. "]"
                                end,
                            },
                        },
                    },
                },
            },

            snippets = { preset = "luasnip" },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {

                default = {
                    "lazydev",
                    "lsp",
                    "path",
                    "snippets",
                    "buffer",
                    "ripgrep",
                    "copilot",
                    -- "dictionary",
                },

                providers = {
                    lsp = { score_offset = 45 },
                    snippets = { score_offset = 55 },
                    path = { score_offset = 10 },
                    buffer = { score_offset = 15 },
                    lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 46 },
                    ripgrep = {
                        module = "blink-ripgrep",
                        name = "Ripgrep",
                        opts = {
                            max_filesize = "200K",
                            future_features = {},
                        },
                        score_offset = 1,
                    },
                    copilot = {
                        name = "copilot",
                        module = "blink-copilot",
                        score_offset = 100,
                        async = true,
                    },

                },
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
        opts_extend = { "sources.default" },
    },

    {
        "xzbdmw/colorful-menu.nvim",
        lazy = true,
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("colorful-menu").setup({})
        end,
    },

    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                "lazy.nvim",
            },
        },
    },
}
