-- Autocompletion
return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",

            -- Adds LSP completion capabilities
            "hrsh7th/cmp-nvim-lsp",

            -- Buffer source
            "hrsh7th/cmp-buffer",

            -- nvim lua api
            "hrsh7th/cmp-nvim-lua",

            -- Path source
            "hrsh7th/cmp-path",

            -- completion source from dictionary
            "octaltree/cmp-look",
        },

        -- configure plugin
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api
                            .nvim_buf_get_lines(0, line - 1, line, true)[1]
                            :sub(col, col)
                            :match("%s")
                        == nil
            end
            cmp.setup({
                view = {
                    entries = {
                        name = "custom",
                        selection_order = "near_cursor",
                        follow_cursor = true,
                    },
                },
                luasnip.config.setup({}),
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                preselect = cmp.PreselectMode.None,
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-y>"] = cmp.mapping.complete({}),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<C-h>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                            -- elseif luasnip.expand_or_locally_jumpable() then
                            --     luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                            -- elseif luasnip.locally_jumpable(-1) then
                            --     luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),

                sources = {
                    { name = "luasnip", priority = 15 },
                    { name = "nvim_lua", priority = 11 },
                    { name = "nvim_lsp", priority = 10 },
                    -- { name = "lazydev", priority = 11 },
                    { name = "path", priority = 10 },
                    { name = "buffer", priority = 5 },
                },

                formatting = {
                    format = function(entry, vim_item)
                        vim_item.menu = ({
                            luasnip = "[snip]",
                            nvim_lsp = "[lsp]",
                            buffer = "[buf]",
                            nvim_lua = "[api]",
                            -- lazydev = "[lazy]",
                            path = "[path]",
                            look = "[dict]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
            })

            local function toggle_source(source)
                local sources = cmp.get_config().sources
                if not sources then
                    return
                end
                for i = #sources, 1, -1 do
                    if sources[i].name == source.name then
                        table.remove(sources, i)
                        return
                    end
                end
                table.insert(sources, source)
            end

            -- enable dictionary completion source upon toggle
            vim.keymap.set("n", "<leader>ts", function()
                toggle_source({
                    name = "look",
                    keyword_length = 3,
                    priority = 1,
                    max_item_count = 15,
                    option = {
                        convert_case = true,
                        loud = true,
                        --dict = "/usr/share/dict/words",
                    },
                })
            end, { desc = "[T]oggle dictionary completion [s]ource" })
        end,
    },

    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    {
        -- neovim api completion
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
                "lazy.nvim",
            },
        },
    },
}
