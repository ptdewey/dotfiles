local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local rep = extras.rep

-- sh snippets
ls.add_snippets("sh", {
    s("usr/bin", fmt("#!/usr/bin/env bash{}", { i(0) })),
})
